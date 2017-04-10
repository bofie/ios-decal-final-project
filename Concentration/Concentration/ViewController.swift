//
//  ViewController.swift
//  Concentration
//
//  Created by Bofan Chen on 3/31/17.
//  Copyright © 2017 Bofan Chen. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cardsCollectionView: UICollectionView!

    var cardsSelected: Int = 0
    var firstSelectedCard: Int = -1
    var cardsNum: Int = 30
    var cardsArray: [Int] = []
    var firstCell: CardCollectionViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsArray = createRandomCards(num: cardsNum)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let (number, suits) = indexToSuits(index: cardsArray[indexPath.row])
        cardsSelected = cardsSelected + 1
        print (cardsSelected)
        if cardsSelected == 1 {
            firstSelectedCard = card
            firstCell = cell
            cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
            return
        }
        if cardsSelected == 2 {
            print ("hi")
            if card == firstSelectedCard {
                print ("ho")
                cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
                cell.CardImageView.image  = nil
            } else {
                print ("ha")
                cell.CardImageView.image  = UIImage(named: String(number) + "_of_" + suits)
                delay(bySeconds: 2) {
                    cell.CardImageView.image  = UIImage(named: "back")
                    self.firstCell?.CardImageView.image  = UIImage(named: "back")
                }
            }
            cardsSelected = 0
            firstSelectedCard = -1
            firstCell = nil
            return
        }
    }
    
    func suitsToIndex(number: Int, suits: String) -> Int {
        switch(suits) {
        case "clubs":
            return number
        case "diamonds":
            return 13 + number
        case "hearts":
            return 26 + number
        case "spades":
            return 39 + number
        default:
            return 0
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
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }

}

