//
//  MainMenuViewController.swift
//  Concentration
//
//  Created by Bofan Chen on 4/10/17.
//  Copyright © 2017 Bofan Chen. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController, UITextFieldDelegate {
    
    var playerNum: Int = -1
    var cardsNum: Int = -1
    var timeLimit: Int = -1
    var previousPlayerButton: UIButton? = nil
    var previousCardButton: UIButton? = nil
    var previousTimeButton: UIButton? = nil
    

    @IBOutlet weak var playerOneNameTextField: UITextField!
    @IBOutlet weak var playerTwoNameTextField: UITextField!
    @IBOutlet weak var singlePlayerNameTextField: UITextField!
    @IBOutlet weak var vsImage: UIImageView!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        playerOneNameTextField.isHidden = true
        playerTwoNameTextField.isHidden = true
        singlePlayerNameTextField.isHidden = true
        self.playerOneNameTextField.delegate = self
        self.playerTwoNameTextField.delegate = self
        self.singlePlayerNameTextField.delegate = self
        vsImage.isHidden = true
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
        previousPlayerButton = button
        switch button.tag {
        case 1:
            playerNum = 1
            singlePlayerNameTextField.isHidden = false
            playerOneNameTextField.isHidden = true
            playerTwoNameTextField.isHidden = true
            singlePlayerNameTextField.placeholder = "What's your name?"
            vsImage.isHidden = true
        case 2:
            playerNum = 2
            vsImage.isHidden = false
            singlePlayerNameTextField.isHidden = true
            playerOneNameTextField.isHidden = false
            playerTwoNameTextField.isHidden = false
            playerOneNameTextField.placeholder = "P1 Name "
            playerTwoNameTextField.placeholder = "P2 Name "
        default:
            print("Unknown player num")
        return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func selectCardsNum(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        if previousCardButton != nil && previousCardButton?.tag != button.tag {
            previousCardButton?.titleLabel?.font = UIFont(name: "Marker Felt", size: 22)
        }
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 30)
        previousCardButton = button
        switch button.tag {
        case 1:
            cardsNum = 12
        case 2:
            cardsNum = 24
        case 3:
            cardsNum = 36
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
        previousTimeButton = button
        switch button.tag {
        case 1:
            timeLimit = 60
        case 2:
            timeLimit = 120
        case 3:
            timeLimit = 180
        case 4:
            timeLimit = 240
        case 5:
            timeLimit = 300
        case 6:
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
                    if playerOneNameTextField.text != "" {
                        dest.playerOneName = playerOneNameTextField.text!
                    }
                    if playerTwoNameTextField.text != "" {
                        dest.playerTwoName = playerTwoNameTextField.text!
                    }
                    if singlePlayerNameTextField.text != "" {
                        dest.singlePlayerName = singlePlayerNameTextField.text!
                    }
                }
            }
        }
    }
    
}
