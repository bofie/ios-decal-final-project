//
//  MainMenuViewController.swift
//  Concentration
//
//  Created by Bofan Chen on 4/10/17.
//  Copyright © 2017 Bofan Chen. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    
    var playerNum: Int = -1
    var cardsNum: Int = -1
    var timeLimit: Int = -1
    var previousPlayerButton: UIButton? = nil
    var previousCardButton: UIButton? = nil
    var previousTimeButton: UIButton? = nil
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectPlayersNum(sender: AnyObject) {
        guard let button = sender as? UIButton else {
        return
        }
        if previousPlayerButton != nil && previousPlayerButton?.tag != button.tag {
            previousPlayerButton?.titleLabel?.font = UIFont(name: "Marker Felt", size: 22)
        }
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 30)
        switch button.tag {
        case 1:
            playerNum = 1
            previousPlayerButton = button
        case 2:
            playerNum = 2
            previousPlayerButton = button
        default:
            print("Unknown player num")
        return
        }
    }
    
    @IBAction func selectCardsNum(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        if previousCardButton != nil && previousCardButton?.tag != button.tag {
            previousCardButton?.titleLabel?.font = UIFont(name: "Marker Felt", size: 22)
        }
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 30)
        switch button.tag {
        case 1:
            cardsNum = 12
            previousCardButton = button
        case 2:
            cardsNum = 24
            previousCardButton = button
        case 3:
            cardsNum = 36
            previousCardButton = button
        default:
            print("Unknown cards num")
        return
        }
    }
    
    @IBAction func selectTimeLimit(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        if previousTimeButton != nil && previousTimeButton?.tag != button.tag {
            previousTimeButton?.titleLabel?.font = UIFont(name: "Marker Felt", size: 22)
        }
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 30)
        switch button.tag {
        case 1:
            timeLimit = 60
            previousTimeButton = button
        case 2:
            timeLimit = 120
            previousTimeButton = button
        case 3:
            timeLimit = 180
            previousTimeButton = button
        case 4:
            timeLimit = 240
            previousTimeButton = button
        case 5:
            timeLimit = 300
            previousTimeButton = button
        case 6:
            previousTimeButton = button
            timeLimit = 0
        default:
            print("Unknown time limit")
            return
        }
    }
    
    @IBAction func enterGameButton(_ sender: Any) {
        if playerNum == -1 || cardsNum == -1 || timeLimit == -1 {
            let alert = UIAlertController(title: "Error", message: "You have unselected items.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "enterGameSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "enterGameSegue" {
                if let dest = segue.destination as? GameViewController {
                    dest.playerNum = playerNum
                    dest.cardsNum = cardsNum
                    dest.timeLimit = timeLimit
                }
            }
        }
    }
    
}
