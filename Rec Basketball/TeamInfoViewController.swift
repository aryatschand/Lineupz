//
//  TeamInfoViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/14/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit
import SwiftSoup

class TeamInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var GenderControl: UISegmentedControl!
    @IBOutlet weak var GradePicker: UIPickerView!
    @IBOutlet weak var TeamNamePicker: UIPickerView!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var team: Team!
    var teamArray = [Team]()
    var teamIndex: Int = 0
    var teamGrade: Int = 0
    var teamGender: Int = 0
    var idNumber: Int = 0
    var htmlcontents: String = ""
    var Array1: [String] = ["Default"]
    var Array2: [String] = ["Default"]
    var Array3: [String] = ["Default"]
    var Array4: [String] = ["Default"]
    var Array5: [String] = ["Default"]
    var Array6: [String] = ["Default"]
    var Array7: [String] = ["Default"]
    var Array8: [String] = ["Default"]
    var Array15: [String] = ["Default"]
    var Array9: [String] = ["Default"]
    var Array11: [String] = ["Default"]
    var Array12: [String] = ["Default"]
    var Array13: [String] = ["Default"]
    var Array14: [String] = ["Default"]
    var arraylist: [[String]] = []
    let emptyarray: [String] = []
    var coachName = ""
    let idArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 15, 9, 11, 12, 13, 14]
    let NBATeamArray: [String] = ["Default","Lakers", "Warriors", "Cavs", "Celtics", "Rockets", "Spurs", "Raptors", "Knicks", "Bulls", "Heat", "Thunder", "76ers", "Mavericks", "Suns", "Pelicans", "Hawks", "Bucks", "Clippers", "Timberwolves", "Pistons", "Blazers", "Wizards", "Pacers", "Nets", "Jazz", "Kings", "Magic", "Nuggets", "Grizzlies", "Hornets"]
    let WNBATeamArray: [String] = ["Default", "Dream", "Sky", "Sun", "Fever", "Liberty", "Mystics", "Wings", "Aces", "Sparks", "Lynx", "Mercury", "Storm"]
    let CBBTeamArray: [String] = ["Default", "Michigan State", "Ohio State", "Louisville", "Kentucky", "UConn", "Duke", "Seton Hall", "Rutgers", "North Carolina", "Villanova"]
    let BoysGradeNames: [String] = ["Default", "3rd Grade", "4th Grade", "5th Grade", "6th Grade", "7th Grade", "8th Grade", "9th Grade", "10th Grade", "11th Grade", "12th Grade"]
    let GirlsGradeNames: [String] = ["Default", "3rd and 4th Grade", "5th and 6th Grade", "7th and 8th Grade", "HS Division"]
    
    @IBOutlet weak var CoachNameEntry: UITextField!
    
    // Save coach name
    @IBAction func CoachEntryChanged(_ sender: UITextField) {
        team.coachName = CoachNameEntry.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Draw and parse HTML contents to load the various team names for each grade and gender
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.CoachNameEntry.delegate = self
        if team.teamsPulled == false {
            arraylist.append(emptyarray)
            arraylist.append(Array1)
            arraylist.append(Array2)
            arraylist.append(Array3)
            arraylist.append(Array4)
            arraylist.append(Array5)
            arraylist.append(Array6)
            arraylist.append(Array7)
            arraylist.append(Array8)
            arraylist.append(Array15)
            arraylist.append(Array9)
            arraylist.append(Array11)
            arraylist.append(Array12)
            arraylist.append(Array13)
            arraylist.append(Array14)
            
            // Draw HTML contents from specific marlborobasketball.com link based on team gender and grade
            for x in 1...14 {
                idNumber = idArray[x]
                if let url = URL(string: "https://www.marlborobasketball.com/standings.php?div_id=\(idNumber)") {
                    do {
                        htmlcontents = try String(contentsOf: url)
                    } catch {
                        let alert = UIAlertController(title: "Error Code 26", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Error Code 28", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                
                // Find specific contents using SwiftSoup pod and parse the string into usable arrays
                do {
                    let doc = try SwiftSoup.parse(htmlcontents)
                    do{
                        let element = try doc.select("table").array()
                        do {
                            var text = try element[1].text()
                            let wordToRemove = "Team Name Wins Losses "
                            if let range = text.range(of: wordToRemove) {
                                text.removeSubrange(range)
                            }
                            let fullSched = text
                            var fullSchedArr = fullSched.components(separatedBy: " ")
                            var countval: Int = fullSchedArr.count
                            var y: Int = 0
                            while y < countval {
                                if Int(fullSchedArr[y]) != nil {
                                    fullSchedArr.remove(at: y)
                                    countval = countval - 1
                                } else {
                                    if Int(fullSchedArr[y+1]) == nil {
                                        arraylist[x].append("\(fullSchedArr[y]) \(fullSchedArr[y+1])")
                                        fullSchedArr.remove(at: y+1)
                                        countval = countval - 1
                                    } else {
                                        arraylist[x].append(fullSchedArr[y])
                                    }
                                }
                                y = y+1
                            }
                        } catch {
                            let alert = UIAlertController(title: "Error Code 2", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    } catch {
                        let alert = UIAlertController(title: "Error Code 8", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                } catch {
                    let alert = UIAlertController(title: "Error Code 9", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
            team.teamsPulled = true
            team.arrayList = arraylist
        } else {
            arraylist = team.arrayList
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // For grade and team name picker views
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == GradePicker {
            if GenderControl.selectedSegmentIndex == 0 {
                return 11
            } else if GenderControl.selectedSegmentIndex == 1 {
                return 5
            } else {
                return 0
            }
        }
        
        if pickerView == TeamNamePicker {
            if teamGrade != 0 {
                if GenderControl.selectedSegmentIndex == 0 && teamGrade < 12 {
                    return arraylist[teamGrade-2].count
                } else if GenderControl.selectedSegmentIndex == 1 {
                    return arraylist[((teamGrade-2)/2)+10].count
                } else if GenderControl.selectedSegmentIndex == 0 && teamGrade == 12 {
                    return arraylist[10].count
                } else {
                    return 0
                }
            } else {
                teamGrade = 3
                return arraylist[0].count
            }
        }
        else {
            return 0
        }
    }
    
    // Set labels for the team name rows based on grade and gender
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == GradePicker && GenderControl.selectedSegmentIndex == 0 {
            return BoysGradeNames[row]
        } else if pickerView == GradePicker && GenderControl.selectedSegmentIndex == 1 {
            return GirlsGradeNames[row]
        }
        
        if teamGrade != 0 {
            if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 0 && teamGrade < 12 {
                return arraylist[teamGrade-2][row]
            } else if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 0 && teamGrade == 12 {
                return arraylist[10][row]
            } else if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 1 {
                return arraylist[((teamGrade-2)/2)+10][row]
            } else{
                return ""
            }
        } else {
            teamGrade = 3
            return arraylist[0][row]
        }
    }
    
    // When a row is selected, save the selected team name and grade
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == GradePicker && GenderControl.selectedSegmentIndex == 0{
            teamArray[teamIndex].grade = BoysGradeNames[row]
            teamGrade = row + 2
            teamArray[teamIndex].teamGradeNumber = row

        } else if pickerView == GradePicker && GenderControl.selectedSegmentIndex == 1{
            teamArray[teamIndex].grade = GirlsGradeNames[row]
            teamGrade = 2*row+2
            teamArray[teamIndex].teamGradeNumber = row
        } else if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 0 && teamGrade < 12 {
            teamArray[teamIndex].name = arraylist[teamGrade-2][row]
            teamArray[teamIndex].teamNameNumber = row
        } else if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 0 && teamGrade == 12 {
            teamArray[teamIndex].name = arraylist[10][row]
            teamArray[teamIndex].teamNameNumber = row
            
        } else if pickerView == TeamNamePicker && GenderControl.selectedSegmentIndex == 1 {
            teamArray[teamIndex].name = arraylist[((teamGrade-2)/2)+10][row]
            teamArray[teamIndex].teamNameNumber = row
        }
        
        if teamArray[teamIndex].name != "" && teamArray[teamIndex].grade != "" {
            saveTeams()
        } else {
        }
        team.gamesPulled = false
        self.GradePicker.reloadAllComponents()
        self.TeamNamePicker.reloadAllComponents()
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // When gender is toggled
    @IBAction func GenderControlChanged(_ sender: UISegmentedControl) {
        if GenderControl.selectedSegmentIndex != teamGender {
            teamGender = GenderControl.selectedSegmentIndex
        }
        
        if GenderControl.selectedSegmentIndex == 1 {
            teamGrade = 4
            self.GradePicker.selectRow(0, inComponent: 0, animated: false)
            self.TeamNamePicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        if GenderControl.selectedSegmentIndex == 0 {
            teamGrade = 3
            self.GradePicker.selectRow(0, inComponent: 0, animated: false)
            self.TeamNamePicker.selectRow(0, inComponent: 0, animated: false)
        }
        teamArray[teamIndex].gender = teamGender
        team.gamesPulled = false
        GradePicker.reloadAllComponents()
        TeamNamePicker.reloadAllComponents()
    }
    
    // Move items in view to the corresponding team information
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if teamArray[teamIndex].coachName != "" {
            CoachNameEntry.text = teamArray[teamIndex].coachName
        }
        
        if teamArray[teamIndex].name != "" && teamArray[teamIndex].grade != "" {
            saveTeams()
        }
        
        if teamArray[teamIndex].name != "" {
            self.TeamNamePicker.selectRow(teamArray[teamIndex].teamNameNumber, inComponent: 0, animated: false)
        }

        if teamArray[teamIndex].grade != "" {
            self.GradePicker.selectRow(teamArray[teamIndex].teamGradeNumber, inComponent: 0, animated: false)
            if teamArray[teamIndex].gender == 0 {
                teamGrade = teamArray[teamIndex].teamGradeNumber + 2
            } else if teamArray[teamIndex].gender == 1 {
                teamGrade = 2*(teamArray[teamIndex].teamGradeNumber) + 2
            }
            self.GradePicker.reloadAllComponents()
            self.TeamNamePicker.reloadAllComponents()
        }
        
        if teamArray[teamIndex].gender == 1 {
            self.GenderControl.selectedSegmentIndex = 1
        }
    }
    
    // Check to see if all information is filled and if not, allow other views to recognize incomplete team
    override func viewWillDisappear(_ animated: Bool) {
        do {
            if teamArray[teamIndex].name == "" || teamArray[teamIndex].grade == "" || teamArray[teamIndex].name == "Default" || teamArray[teamIndex].grade == "Default" || teamArray[teamIndex].name == "remove" || teamArray[teamIndex].name == "Incomplete Team"{
                teamArray[teamIndex].name = "remove"
            }
        } catch {
            let alert = UIAlertController(title: "Error Code 1", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerViewController" {
            var PlayerListViewController = segue.destination as! PlayerListViewController
            PlayerListViewController.team = team
            PlayerListViewController.teamArray = teamArray
        } else if segue.identifier == "ScheduleViewController" {
            var ScheduleTableViewController = segue.destination as! ScheduleTableViewController
            ScheduleTableViewController.team = team
            ScheduleTableViewController.teamArray = teamArray
        }
    }
    
    func saveTeams() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 18", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
