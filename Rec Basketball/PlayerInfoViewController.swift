//
//  PlayerInfoViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/13/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit

class PlayerInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let playerArrayKey = "playerListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var team: Team!
    var playerIndex: Int = 0
    var viewDisappear: Int = 0
    var teamArray = [Team]()
    var playerOffensivePosition: Int = 0
    var playerDefensivePosition: Int = 0
    var integerPhoneNumber: String = ""
    var tenDigitsReached: Bool = false
    var previousCharacterCount: Int = 0
    var testString: String = ""
    var stringPhoneNumber: String = ""
    var playerName: String = ""
    var positions = [1, 2, 3, 4, 5]
    var positionsName = ["PG - 1", "SG - 2", "SF - 3", "PF - 4", "C - 5"]
    let ratingArray = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
    var rating: Int = 0
    var email: String = ""

    @IBOutlet weak var PlayerNameTextField: UITextField!
    @IBOutlet weak var positionPicker: UIPickerView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var NumberLabel: UILabel!
    
    @IBOutlet weak var NumberInput: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var EmailInput: UITextField!
    
    // Save player email
    @IBAction func EmailChanged(_ sender: UITextField) {
        email = EmailInput.text!
        team.playerList[playerIndex].email = email
        savePlayers()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Save player phone number
    @IBAction func PhoneNumberChanged(_ sender: Any) {
        if (NumberInput.text?.count)! >= 12 {
            var input: String = NumberInput.text!
            var inputString = String(input.dropLast())
            NumberInput.text = inputString
        }
    }
    
    // Manipulate entered phone number to make it standard format with dashes and check for complete number
    @IBAction func NumberChanged(_ sender: UITextField) {
        do {
            if NumberInput.text!.range(of:"-") == nil && (NumberInput.text?.count)! > 4 {
                integerPhoneNumber = NumberInput.text!
                var stringPhoneNumber = integerPhoneNumber
                stringPhoneNumber.insert("-", at: stringPhoneNumber.index(stringPhoneNumber.startIndex, offsetBy: 3))
                stringPhoneNumber.insert("-", at: stringPhoneNumber.index(stringPhoneNumber.startIndex, offsetBy: 7))
                NumberInput.text = stringPhoneNumber
            
            }
            
            if tenDigitsReached == false {
                stringPhoneNumber = NumberInput.text!
                if (stringPhoneNumber.count == 3 || stringPhoneNumber.count == 7) && (NumberInput.text?.count)! > previousCharacterCount {
                    stringPhoneNumber = "\(stringPhoneNumber)-"
                    NumberInput.text = stringPhoneNumber
                }
            }
            
            if (NumberInput.text?.count)! >= 12 {
                tenDigitsReached = true
                NumberInput.text = stringPhoneNumber
                NumberLabel.text = "Parent Phone Number (Compelete)"
                NumberLabel.textColor = UIColor.green
                textFieldShouldReturn(NumberInput)
            } else {
                tenDigitsReached = false
                NumberLabel.text = "Parent Phone Number (Incomplete)"
                NumberLabel.textColor = UIColor.red
            }
            previousCharacterCount = (NumberInput.text?.count)!
            testString = stringPhoneNumber
            
            if let range = testString.range(of: "-") {
                testString.removeSubrange(range)
                integerPhoneNumber = testString
            }
            
            if let range = testString.range(of: "-") {
                testString.removeSubrange(range)
                integerPhoneNumber = testString
            }
            team.playerList[playerIndex].phoneNumber = integerPhoneNumber
            team.playerList[playerIndex].displayNumber = stringPhoneNumber
            savePlayers()
        } catch {
            let alert = UIAlertController(title: "Error Code 7", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // For position and rating pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == positionPicker {
            return 2
        } else if pickerView == ratingPicker {
            return 1
        } else {
            return 0
        }
    }
    
    // Set titles of pickers to standard ratings and positions
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == positionPicker {
            if component == 0 {
                return positionsName[row]
            } else if component == 1 {
                return positionsName[row]
            } else {
                return ""
            }
        }
    
        if pickerView == ratingPicker {
            return String(ratingArray[row])
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == positionPicker {
            if component == 0 {
                return 5
            } else if component == 1 {
                return 5
            } else {
                return 0
            }
        }
        
        if pickerView == ratingPicker {
            return 9
        } else {
            return 0
        }
    }
    
    // When a position or rating is picked, change it to required terms and save data
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == positionPicker {
            if component == 0 {
                playerOffensivePosition = row+1
            } else if component == 1 {
                playerDefensivePosition = row+1
            }
            team.playerList[playerIndex].offensivePosition = playerOffensivePosition
            team.playerList[playerIndex].defensivePosition = playerDefensivePosition
            savePlayers()
        }
        
        if pickerView == ratingPicker {
            rating = Int(ratingArray[row]*10)
            team.playerList[playerIndex].rating = rating
            savePlayers()
        }
        
        if team.playerList[playerIndex].name != "" && team.playerList[playerIndex].offensivePosition != 0 && team.playerList[playerIndex].defensivePosition != 0 && team.playerList[playerIndex].rating != 0 {
            savePlayers()
        }
    }
    
    // Set text fields as delegated
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.EmailInput.delegate = self
        self.PlayerNameTextField.delegate = self
        self.NumberInput.delegate = self
    }
    
    // Save player name when edited
    @IBAction func playerNameTextField(_ sender: UITextField) {
        if viewDisappear != 1 {
            playerName = PlayerNameTextField.text!
            team.playerList[playerIndex].name = playerName
            savePlayers()
        }
    }
    
    // Populate text fields and pickers with saved player data
    override func viewWillAppear(_ animated: Bool) {
        do {
            super.viewWillAppear(animated)
            savePlayers()
            playerOffensivePosition = team.playerList[playerIndex].offensivePosition
            playerDefensivePosition = team.playerList[playerIndex].defensivePosition
            
            if team.playerList[playerIndex].displayNumber.count >= 12 {
                NumberInput.text = team.playerList[playerIndex].displayNumber
                NumberLabel.text = "Parent Phone Number (Compelete)"
                NumberLabel.textColor = UIColor.green
            }
            
            if team.playerList[playerIndex].email != "" {
                EmailInput.text = team.playerList[playerIndex].email
            }
            viewDisappear = 0
        
            if team.playerList[playerIndex].offensivePosition >= 1 {
                self.positionPicker.selectRow(team.playerList[playerIndex].offensivePosition-1, inComponent: 0, animated: false)
            }
            
            if team.playerList[playerIndex].defensivePosition >= 1 {
                self.positionPicker.selectRow(team.playerList[playerIndex].defensivePosition-1, inComponent: 1, animated: false)
            }
            
            if team.playerList[playerIndex].rating >= 10 {
                self.ratingPicker.selectRow(team.playerList[playerIndex].rating/5-2, inComponent: 0, animated: false)
            }
            
            if team.playerList[playerIndex].name != "" {
                PlayerNameTextField.text = team.playerList[playerIndex].name
            }
        } catch {
            let alert = UIAlertController(title: "Error Code 6", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // Watch for incomplete players and manipulate name so other views can recognize and delete incomplete players
    override func viewWillDisappear(_ animated: Bool) {
        do {
            if team.playerList[playerIndex].name == "" {
                team.playerList[playerIndex].name = "remove"
                if team.numberOfGames>=1 && team.gameList[0].playerList.indices.contains(playerIndex) {
                    for var a in 1...self.team.numberOfGames{
                        print(self.team.gameList[a-1].Venue)
                        if self.team.gameList[a-1].playerList.count >= playerIndex {
                            self.team.gameList[a-1].playerList.remove(at: playerIndex)
                        }
                    }
                }
            }
            
            if team.gamesPulled == true {
                if team.playerList[playerIndex].newPlayer == true{
                    if team.numberOfGames>=1 {
                        for var a in 1...team.numberOfGames{
                            team.playerList[playerIndex].availability = 0
                            team.gameList[a-1].playerList.append(team.playerList[playerIndex])
                            for x in 0...team.playerList.count-1 {
                                team.gameList[a-1].playerList.append(team.playerList[playerIndex])
                            }
                        }
                    }
                    team.playerList[playerIndex].newPlayer = false
                }
            }
            viewDisappear = 1
        } catch {
            let alert = UIAlertController(title: "Error Code 5", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func savePlayers() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 20", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

