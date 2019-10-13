//
//  GameInfoViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/23/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//
/*
import UIKit
import SwiftSoup

class GameInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var VenuePicker: UIPickerView!
    @IBOutlet weak var OpponentPicker: UIPickerView!
    
    var gameIndex: Int = 0
    var test: Int = 0
    var gameDate: Date! = Date()
    var displayDate: String = ""
    var displayTime: String = ""
    var fullDate: String = ""
    var formattedDate = DateFormatter()
    var formattedTime = DateFormatter()
    var fullFormattedDate = DateFormatter()
    var DateFormatterGet = DateFormatter()
    var loadedDateFormat = DateFormatter()
    var team: Team!
    var teamArray = [Team]()
    var htmlcontents: String = ""
    var DateArr: [String] = []
    var DayArr: [String] = []
    var TimeArr: [String] = []
    var VenueArr: [String] = []
    var Team1Arr: [String] = []
    var AtArr: [String] = []
    var Team2Arr: [String] = []
    var selectedGame: Bool = false
    var loadedDateString: String = ""
    var nameNumber: Int = 0
    var venueNumber: Int = 0
    var teamGrade: Int = 0
    var newFormattedDateString: Date! = Date()
    var currentDate: Date! = Date()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var arraylist: [[String]] = []
    let NBATeamArray: [String] = ["Default","Lakers", "Warriors", "Cavs", "Celtics", "Rockets", "Spurs", "Raptors", "Knicks", "Bulls", "Heat", "Thunder", "76ers", "Mavericks", "Suns", "Pelicans", "Hawks", "Bucks", "Clippers", "Timberwolves", "Pistons", "Blazers", "Wizards", "Pacers", "Nets", "Jazz", "Kings", "Magic", "Nuggets", "Grizzlies", "Hornets"]
    let WNBATeamArray: [String] = ["Default", "Dream", "Sky", "Sun", "Fever", "Liberty", "Mystics", "Wings", "Aces", "Sparks", "Lynx", "Mercury", "Storm"]
    let CBBTeamArray: [String] = ["Default", "Michigan State", "Ohio State", "Louisville", "Kentucky", "UConn", "Duke", "Seton Hall", "Rutgers", "North Carolina", "Villanova"]
    let TotalVenueArray: [String] = ["Default","Asher", "Robertsville", "Rec Center", "Middle 520", "Memorial", "Dugan"]
    
    // Set date time format
    override func viewDidLoad() {
        super.viewDidLoad()
        arraylist = team.arrayList
        if team.gender == 0 {
            teamGrade = team.teamGradeNumber+3
        } else if team.gender == 1 {
            teamGrade = 2*(team.teamGradeNumber)+2
        }
        datePicker.minuteInterval = 10
        formattedDate.dateFormat = "M/dd/yy"
        formattedTime.dateFormat = "h:mm a"
        formattedTime.amSymbol = "AM"
        formattedTime.pmSymbol = "PM"
        fullFormattedDate.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        fullFormattedDate.timeZone = TimeZone(identifier: "GMT")
        DateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        DateFormatterGet.timeZone = TimeZone(identifier: "GMT")
        loadedDateFormat.dateFormat = "MM/dd/yy hh:mma"
        loadedDateFormat.amSymbol = "AM"
        loadedDateFormat.pmSymbol = "PM"
    }
    
    // For venue and opponent pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == VenuePicker {
            return 1
        } else if pickerView == OpponentPicker {
            return 1
        } else {
            return 0
        }
    }
    
    // Find number of venues and opponent teams for the picker views
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == OpponentPicker {
            if teamGrade != 0 {
                if team.gender == 0 && teamGrade < 12 {
                    return arraylist[teamGrade-3].count
                } else if team.gender == 1 {
                    return arraylist[((teamGrade-2)/2)+10].count
                } else if team.gender == 0 && teamGrade == 12 {
                    return arraylist[10].count
                } else {
                    return 0
                }
            } else {
                teamGrade = 3
                return arraylist[0].count
            }
        }
        
        if pickerView == VenuePicker{
            return TotalVenueArray.count
        } else {
            return 0
        }
    }
    
    // Populate the picker views with all the opponent teams and venues
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == OpponentPicker {
            if teamGrade != 0 {
                if team.gender == 0 && teamGrade < 12 {
                    return arraylist[teamGrade-3][row]
                } else if team.gender == 0 && teamGrade == 12 {
                    return arraylist[10][row]
                } else if team.gender == 1 {
                    return arraylist[((teamGrade-2)/2)+10][row]
                } else{
                    return ""
                }
            } else {
                teamGrade = 3
                return arraylist[0][row]
            }
        }
        
        if pickerView == VenuePicker {
            return TotalVenueArray[row]
        } else {
            return ""
        }
    }
    
    // If venue or opponent is changed, alert the user that they are changing a loaded game's information and change the game status
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if team.gameList[gameIndex].GameEdit == "Loaded" {
            let alert = UIAlertController(title: "Edit Game", message: "Are you sure you want to edit this game (loaded directly from marlborobasketball.com)", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "No", style: .cancel) { (action) in
                self.OpponentPicker.selectRow(self.nameNumber, inComponent: 0, animated: false)
                self.VenuePicker.selectRow(self.venueNumber, inComponent: 0, animated: false)
            }
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                if pickerView == self.OpponentPicker {
                    if self.team.gender == 1 {
                        self.team.gameList[self.gameIndex].Opponent = self.arraylist[((self.teamGrade-2)/2)+10][row]
                    } else if self.team.gender == 0 && self.team.grade == "12th Grade" {
                        self.team.gameList[self.gameIndex].Opponent = self.arraylist[10][row]
                    } else if self.team.gender == 0 && self.team.grade != "12th Grade"{
                        self.team.gameList[self.gameIndex].Opponent = self.arraylist[self.teamGrade-3][row]
                    }
                }
               
                if pickerView == self.VenuePicker {
                    self.team.gameList[self.gameIndex].Venue = self.TotalVenueArray[row]
                }
                self.team.gameList[self.gameIndex].GameEdit = "Edited"
                self.saveGames()
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            if pickerView == OpponentPicker {
                if team.gender == 1 {
                    team.gameList[gameIndex].Opponent = arraylist[((teamGrade-2)/2)+10][row]
                } else if team.gender == 0 && team.grade == "12th Grade" {
                    team.gameList[gameIndex].Opponent = arraylist[10][row]
                } else if team.gender == 0 && team.grade != "12th Grade"{
                    team.gameList[gameIndex].Opponent = arraylist[teamGrade-3][row]
                }
            }
            if pickerView == VenuePicker {
                team.gameList[gameIndex].Venue = TotalVenueArray[row]
            }
            saveGames()
        }
    }

    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Load the information to the game info page
    override func viewWillAppear(_ animated: Bool) {
        if selectedGame == true {
            loadedDateString = "\(team.gameList[gameIndex].Date) \(team.gameList[gameIndex].Time)"
            newFormattedDateString = loadedDateFormat.date(from: loadedDateString)
            self.datePicker.setDate(newFormattedDateString, animated: false)
            team.gameList[gameIndex].FormattedDate = newFormattedDateString
            if team.gender == 1 {
                nameNumber = arraylist[((teamGrade-2)/2)+10].index(of: team.gameList[gameIndex].Opponent)!
            } else if team.gender == 0 && team.grade == "12th Grade" {
                nameNumber = arraylist[10].index(of: team.gameList[gameIndex].Opponent)!
            } else if team.gender == 0 && team.grade != "12th Grade" {
                nameNumber = arraylist[teamGrade-3].index(of: team.gameList[gameIndex].Opponent)!
            }
            venueNumber = TotalVenueArray.index(of: team.gameList[gameIndex].Venue)!
            self.OpponentPicker.selectRow(nameNumber, inComponent: 0, animated: false)
            self.VenuePicker.selectRow(venueNumber, inComponent: 0, animated: false)
        }
        let game = team.gameList[gameIndex]
        gameDate = game.FormattedDate
        
        if gameDate != nil {
            self.datePicker.setDate(game.FormattedDate, animated: false)
        }
        saveGames()
    }

    // When the date or time is changed, alert user and change game status. Also, check for past dates and alert user
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        if team.gameList[gameIndex].GameEdit == "Loaded" {
            let alert = UIAlertController(title: "Edit Game", message: "Are you sure you want to edit this game (loaded directly from marlborobasketball.com)", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "No", style: .cancel) { (action) in
                self.datePicker.setDate(self.newFormattedDateString, animated: false)
                self.team.gameList[self.gameIndex].FormattedDate = self.newFormattedDateString
            }
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                let game = self.team.gameList[self.gameIndex]
                self.gameDate = self.fullFormattedDate.date(from: self.fullFormattedDate.string(from: self.datePicker.date))!
                let dateString: String = self.gameDate.description
                let FormattedDateForDisplay: Date? = self.DateFormatterGet.date(from: dateString)
                self.displayDate = self.formattedDate.string(from: FormattedDateForDisplay!)
                self.displayTime = self.formattedTime.string(from: FormattedDateForDisplay!)
                if self.gameDate < self.currentDate {
                    self.team.gameList[self.gameIndex].inThePast = true
                    let alert = UIAlertController(title: "Past Date", message: "Warning: The date you selected is in the past", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    }
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.team.gameList[self.gameIndex].inThePast = false
                }
                self.team.gameList[self.gameIndex].FormattedDate = self.gameDate
                self.team.gameList[self.gameIndex].Date = self.displayDate
                self.team.gameList[self.gameIndex].Time = self.displayTime
                self.team.gameList[self.gameIndex].GameEdit = "Edited"
                self.saveGames()
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            let game = team.gameList[gameIndex]
            gameDate = fullFormattedDate.date(from: fullFormattedDate.string(from: datePicker.date))!
            let dateString: String = gameDate.description
            let FormattedDateForDisplay: Date? = DateFormatterGet.date(from: dateString)
            if gameDate < currentDate {
                team.gameList[gameIndex].inThePast = true
                let alert = UIAlertController(title: "Past Date", message: "Warning: The date you selected is in the past", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            } else {
                team.gameList[gameIndex].inThePast = false
            }
            displayDate = formattedDate.string(from: FormattedDateForDisplay!)
            displayTime = formattedTime.string(from: FormattedDateForDisplay!)
            team.gameList[gameIndex].FormattedDate = gameDate
            team.gameList[gameIndex].Date = displayDate
            team.gameList[gameIndex].Time = displayTime
            saveGames()
        }
    }
    
    // Check for incomplete games and allow other pages to recognize incomplete game
    override func viewWillDisappear(_ animated: Bool) {
        selectedGame = false
        let game = team.gameList[gameIndex]
        if game.Opponent == "" || game.Opponent == "Default" || game.Venue == "" || game.Venue == "Default" || game.Time == "" {
            game.Opponent = "remove"
        }
    }
    
    func saveGames() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 22", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
*/
