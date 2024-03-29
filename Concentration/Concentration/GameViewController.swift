//
//  GameViewController.swift
//  Concentration
//
//  Created by Bofan Chen on 3/31/17.
//  Copyright © 2017 Bofan Chen. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class GameViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cardsCollectionView: UICollectionView!

    @IBOutlet weak var flipsTakenLabel: UILabel!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBAction func startOverButton(_ sender: UIButton) {
        if timeLimit != 0 {
          timer.invalidate()
        }
        startOver()
        self.cardsCollectionView.reloadData()
    }
    
    @IBAction func bgmButton(_ sender: UIButton) {
        if bgmPlayer!.isPlaying {
            bgmPlayer!.pause()
        } else {
            bgmPlayer!.prepareToPlay()
            bgmPlayer!.play()
        }
    }
    
    var cardsNum: Int = 36
    var playerNum: Int = 1
    var timeLimit: Int = 100

    var cardsArray: [Int] = []
    var cardsSelected: Int = 0
    var firstSelectedCard: Int = -1
    var firstCellIndexPath: IndexPath? = nil
    var copyOfCardsArray: [Int] = []
    var flipsNum: Int = 0
    var countDown: Int = 0
    var timer = Timer()
    var bgmPlayer: AVAudioPlayer?

    
    var playerOneScore: Int = 0
    var playerTwoScore: Int = 0
    var playerOneTurn: Bool = true
    var playerOneName: String = "Player 1"
    var playerTwoName: String = "Player 2"
    var singlePlayerName: String = "Player"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        if cardsNum == 12 {
            if playerNum == 1 {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 120)
            } else {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 130)
            }
            cardsCollectionView.contentInset.top = 100
        }
        if cardsNum == 24 {
            if playerNum == 1 {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 100)
            } else {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 110)
            }
            cardsCollectionView.contentInset.top = 50
        }
        if cardsNum == 36 {
            if playerNum == 1 {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 75)
            } else {
                popUpLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: 90)
            }

        }
        let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3")
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url!)
        }catch{
            print(error)
        }
        startOver()
    }
    
    func startOver() {
        cardsArray = createRandomCards(num: cardsNum)
        print (cardsArray)
        copyOfCardsArray = cardsArray.map {$0}
        popUpLabel.text = "Let's get started!😍"
        popUpLabel.numberOfLines = 0
        if playerNum == 1 && singlePlayerName != "Player" {
            popUpLabel.text = singlePlayerName + ", let's get started!😍"
        }
        flipsTakenLabel.text = "0 Flips Taken"
        flipsNum = 0
        if timeLimit != 0 {
            countDown = timeLimit
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
        } else {
            countDownLabel.text = ""
        }
        if playerNum == 1 {
            playerOneLabel.text = ""
            playerTwoLabel.text = ""
        } else {
            playerOneLabel.numberOfLines = 0
            playerOneLabel.text = playerOneName + "\n0 🃏"
            playerOneLabel.layer.borderColor = UIColor.black.cgColor
            playerOneLabel.layer.borderWidth = 2
            playerTwoLabel.layer.borderColor = UIColor.black.cgColor
            playerTwoLabel.layer.borderWidth = 0
            playerTwoLabel.numberOfLines = 0
            playerTwoLabel.text = playerTwoName + "\n0 🃏"
        }

    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        self.cardsCollectionView.reloadData()
        bgmPlayer?.stop()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        cell.CardImageView.image  = UIImage(named: "back")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cardsArray[indexPath.row]
        let cell = cardsCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        if cell.CardImageView.image == nil {
            return
        }
        let (number, suits) = indexToSuits(index: card)
        var firstCell: CardCollectionViewCell? = nil
        if firstCellIndexPath != nil {
            if firstCellIndexPath == indexPath {
                return
            }
            firstCell = cardsCollectionView.cellForItem(at: firstCellIndexPath!) as? CardCollectionViewCell
        }
        cardsSelected = cardsSelected + 1
        if cardsSelected == 1 {
            firstSelectedCard = card
            firstCellIndexPath = indexPath
            cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
            return
        }
        if cardsSelected == 2 {
            flipsNum = flipsNum + 1
            flipsTakenLabel.text = String(flipsNum) + " Flips Taken"
            if card == firstSelectedCard {
                popUpLabel.text = "It's a pair!!😗"
                if playerNum == 2 {
                    if playerOneTurn {
                        playerOneScore = playerOneScore + 2
                        playerOneLabel.text = playerOneName + "\n" + String(playerOneScore) + " 🃏"
                    } else {
                        playerTwoScore = playerTwoScore + 2
                        playerTwoLabel.text = playerTwoName + "\n" + String(playerTwoScore) + " 🃏"
                    }
                }
                cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
                delay(bySeconds: 1) {
                    cell.CardImageView.image = nil
                    firstCell?.CardImageView.image = nil
                }
                copyOfCardsArray = copyOfCardsArray.filter() {$0 != card}
                if copyOfCardsArray.isEmpty {
                    popUpLabel.text = "Congratulations!!🤗🤗"
                    if timeLimit != 0 {
                     timer.invalidate()
                    }
                    var alert = UIAlertController(title: "Congratulations!", message: "You win!!", preferredStyle: UIAlertControllerStyle.alert)
                    if playerNum == 1 && singlePlayerName != "Player" {
                        alert = UIAlertController(title: "Congratulations, " + singlePlayerName + "!", message: "You win!!", preferredStyle: UIAlertControllerStyle.alert)
                    }
                    if playerNum == 2 {
                        if playerOneScore > playerTwoScore {
                            alert = UIAlertController(title: "Congratulations!", message: playerOneName + " is the WINNER!!", preferredStyle: UIAlertControllerStyle.alert)
                        } else if playerOneScore < playerTwoScore {
                            alert = UIAlertController(title: "Congratulations!", message: playerTwoName + " is the WINNER!!", preferredStyle: UIAlertControllerStyle.alert)
                        } else {
                            alert = UIAlertController(title: "It's a draw!", message: "Rematch?", preferredStyle: UIAlertControllerStyle.alert)
                        }
                        playerOneTurn = true
                        playerOneScore = 0
                        playerTwoScore = 0
                    }
                    alert.addAction(UIAlertAction(title: "Start over", style: UIAlertActionStyle.default, handler: {action in
                        self.startOver()
                        self.cardsCollectionView.reloadData()}))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                popUpLabel.text = "Almost!🤓"
                if playerNum == 2 {
                    if playerOneTurn {
                        delay(bySeconds: 1) {
                            self.playerTwoLabel.layer.borderWidth = 2
                            self.playerOneLabel.layer.borderWidth = 0
                        }
                        playerOneTurn = false
                    } else {
                        delay(bySeconds: 1) {
                            self.playerOneLabel.layer.borderWidth = 2
                            self.playerTwoLabel.layer.borderWidth = 0
                        }
                        playerOneTurn = true
                    }
                }
                cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
                delay(bySeconds: 1) {
                    cell.CardImageView.image = UIImage(named: "back")
                    firstCell?.CardImageView.image = UIImage(named: "back")
                }
            }
            cardsSelected = 0
            firstSelectedCard = -1
            firstCellIndexPath = nil
            self.cardsCollectionView.isUserInteractionEnabled = false
            delay(bySeconds: 1) {
                self.cardsCollectionView.isUserInteractionEnabled = true
            }
            return
        }
    }
    
    
    func indexToSuits(index: Int) -> (Int, String) {
        var number:Int = 0
        number = index % 13
        let suits = (index - 1) / 13
        if number == 0 {
            number = 13
        }
        switch(suits) {
        case 0:
            return (number, "clubs")
        case 1:
            return (number, "diamonds")
        case 2:
            return (number, "hearts")
        case 3:
            return (number, "spades")
        default:
            return (0, "blah")
        }
    }
    
    func createRandomCards(num:Int ) -> [Int] {
        var result:[Int] = []
        while result.count != cardsNum {
            let card = Int(arc4random_uniform(52)) + 1
            if !result.contains(card) {
                result.append(card)
                result.append(card)
            }
        }
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: result) as! [Int]
    }
    
    //    Referenced from http://stackoverflow.com/questions/4139219/how-do-you-trigger-a-block-after-a-delay-like-performselectorwithobjectafter
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }

    //    Referenced from http://stackoverflow.com/questions/4139219/how-do-you-trigger-a-block-after-a-delay-like-performselectorwithobjectafter
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:
                return DispatchQueue.main
            case .userInteractive:
                return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:
                return DispatchQueue.global(qos: .userInitiated)
            case .utility:
                return DispatchQueue.global(qos: .utility)
            case .background:
                return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    func update() {
        if (countDown > 0) {
            countDownLabel.text = String(countDown) + "s left"
            countDown = countDown - 1
        } else {
            countDownLabel.text = String(countDown) + "s left"
            let alert = UIAlertController(title: "Sorry!", message: "Time's Up!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Start over", style: UIAlertActionStyle.default, handler: {action in self.viewDidLoad()
                self.cardsCollectionView.reloadData()}))
            self.present(alert, animated: true, completion: nil)
            timer.invalidate()
        }
    }

}

