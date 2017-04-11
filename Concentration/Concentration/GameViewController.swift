//
//  GameViewController.swift
//  Concentration
//
//  Created by Bofan Chen on 3/31/17.
//  Copyright © 2017 Bofan Chen. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cardsCollectionView: UICollectionView!

    @IBOutlet weak var flipsTakenLabel: UILabel!
    @IBOutlet weak var popUpLabel: UILabel!
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBAction func startOverButton(_ sender: UIButton) {
        if timeLimit != 0 {
          timer.invalidate()
        }
        self.viewDidLoad()
        self.cardsCollectionView.reloadData()
    }
    
    var cardsSelected: Int = 0
    var firstSelectedCard: Int = -1
    var cardsNum: Int = 36
    var cardsArray: [Int] = []
    var firstCellIndexPath: IndexPath? = nil
    var copyOfCardsArray: [Int] = []
    var flipsNum: Int = 0
    var playerNum: Int = 1
    var timeLimit: Int = 100
    var countDown: Int = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsArray = createRandomCards(num: cardsNum)
        copyOfCardsArray = cardsArray.map {$0}
        popUpLabel.text = "Let's get started!😍"
        flipsTakenLabel.text = "0 Flips Taken"
        flipsNum = 0
        if timeLimit != 0 {
            countDown = timeLimit
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
        } else {
            countDownLabel.text = ""
        }
        print (cardsArray)
    }
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        self.cardsCollectionView.reloadData()
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
                    let alert = UIAlertController(title: "Congratulations!", message: "You win!!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Start over", style: UIAlertActionStyle.default, handler: {action in
                        self.viewDidLoad()
                        self.cardsCollectionView.reloadData()}))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                popUpLabel.text = "Almost!🤓"
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
        let suits = index / 13
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
        case 3...4:
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
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
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

