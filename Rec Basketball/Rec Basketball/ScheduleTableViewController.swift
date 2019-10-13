//
//  ScheduleTableViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/18/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    var teamArray = [Team]()
    var team: Team!
    var brokenTeamArray: [String] = []
    var brokenTeam: String = ""
    var displayDate: String = ""
    var opponentTeam: Int = 0
    var currentDate: Date! = Date()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var htmlcontents: String = ""
    var DateArr: [String] = []
    var DayArr: [String] = []
    var TimeArr: [String] = []
    var VenueArr: [String] = []
    var Team1Arr: [String] = []
    var AtArr: [String] = []
    var Team2Arr: [String] = []
    var OpponentArr: [String] = []
    var GameNumberArray: [Int] = []
    var idNumber: Int = 0
    var currentGameArr: [Int] = []
    var teamIndexBackup: Int = 0
    var currentNewGame: Int = 0
    var doneloading: Bool = false
    var loadedDateString: String = ""
    var newFormattedDateString: Date! = Date()
    var loadedDateFormat = DateFormatter()
    var dateFormatter = DateFormatter()
    var clear = false

    // Set date formats
    override func viewDidLoad() {
        super.viewDidLoad()
        loadedDateFormat.dateFormat = "MM/dd/yy hh:mma"
        loadedDateFormat.amSymbol = "AM"
        loadedDateFormat.pmSymbol = "PM"
        dateFormatter.dateFormat = "MM/dd/yy"
    }

    // Load all the schedule data and save it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        brokenTeamArray = team.name.components(separatedBy: " ")
        trialLoad()
        if team.numberOfGames >= 1 && doneloading == true {
            for x in 1...team.numberOfGames-1 {
                let newGame = Game()
                self.team.gameList.append(newGame)
                team.gameList[x-1].Date = DateArr[x-1]
                team.gameList[x-1].Day = DayArr[x-1]
                team.gameList[x-1].Time = TimeArr[x-1]
                team.gameList[x-1].Venue = VenueArr[x-1]
                team.gameList[x-1].Opponent = OpponentArr[x-1]
                
                //Assume all players will attend every game
                
                
                
            }
        }
        
 */
        currentNewGame = tableView.numberOfRows(inSection: 0)
        saveTeamsNoReload()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Allow user to delete a game by swiping
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete Lineup", message: "Are You Sure You Want to Delete the Lineup?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                self.currentNewGame = self.currentNewGame - 1
                self.team.numberOfGames = self.team.numberOfGames-1
                self.team.gameList.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                for var x in 0...self.team.playerList.count-1 {
                    self.team.playerList[x].availabilityArray.remove(at: indexPath.item)
                }
                self.saveTeams()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            })
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.gameList.count
    }
    
    // Delete incomplete games and set labels with game information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameScheduleCell", for: indexPath)
        cell.textLabel?.text = team.gameList[indexPath.row].name
        /*
        do {
            if team.gameList[indexPath.row].Opponent == "remove"{
                try team.gameList.remove(at: indexPath.row)
                team.numberOfGames = team.numberOfGames - 1
                currentNewGame = currentNewGame - 1
                try saveTeams()
            } else {
                cell.textLabel?.text = "\(team.gameList[indexPath.row].Opponent) - \(team.gameList[indexPath.row].Date) at \(team.gameList[indexPath.row].Time) (\(team.gameList[indexPath.row].GameEdit))"
                if team.gameList[indexPath.row].FormattedDate < currentDate {
                    team.gameList[indexPath.row].inThePast = true
                } else {
                    team.gameList[indexPath.row].inThePast = false
                }
            
                if team.gameList[indexPath.row].inThePast == true {
                    cell.textLabel?.textColor = UIColor.red
                } else {
                    cell.textLabel?.textColor = UIColor.black
                }
            }
        } catch {
            let alert = UIAlertController(title: "Error Code 15", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        saveTeamsNoReload()
        */
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBOutlet weak var TitleLabel: UINavigationItem!
    
    // Allow user to add games
    @IBAction func addButton(_ sender: UIBarButtonItem) {

        // 4. Present the alert.
        
        let alert = UIAlertController(title: "Add New Lineup", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Lineup name (optional)"
        }
        let action = UIAlertAction(title: "Add Lineup", style: .default) { (action) in
            let textField = alert.textFields![0]
            let newGame = Game()
            self.team.gameList.append(newGame)
            if textField.text != "" {
                self.team.gameList[self.team.gameList.count-1].name = textField.text!
            } else {
                self.team.gameList[self.team.gameList.count-1].name = "Lineup \(self.self.team.gameList.count)"
            }
            self.saveTeams()
            self.performSegue(withIdentifier: "NewLineup", sender: self)
            self.team.numberOfGames = self.team.numberOfGames + 1
            self.currentNewGame = self.team.numberOfGames
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTeams() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 14", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
    
    // Same as save teams, but without reloading the table view
    func saveTeamsNoReload() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 14", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
     /*
    // Load and parse HTML schedule contents
    func trialLoad() {
        if team.gamesPulled == false{
            team.numberOfGames = 0
            
            // Find team IDs for the marlborobasketball.com url
            if team.gender == 0 {
                if team.teamGradeNumber <= 8 {
                    idNumber = team.teamGradeNumber
                } else if team.teamGradeNumber == 9 {
                    idNumber = 15
                } else if team.teamGradeNumber == 10 {
                    idNumber = 9
                }
            } else if team.gender == 1 {
                idNumber = team.teamGradeNumber + 10
            }
            
            if let url = URL(string: "https://www.marlborobasketball.com/schedule.php?div_id=\(idNumber)") {
                do {
                    htmlcontents = try String(contentsOf: url)
                } catch {
                    let alert = UIAlertController(title: "Error Code 26", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
            
            // Because the large table on the website is returned as a single string, it must be parsed into usable arrays
            do {
                let doc = try SwiftSoup.parse(htmlcontents)
                do{
                    let element = try doc.select("table").array()
                    do {
                        var text = try element[1].text()
                        let wordToRemove = "Date Day Time Venue Teams "
                        if let range = text.range(of: wordToRemove) {
                            text.removeSubrange(range)
                        }
                        
                        // Populate unsorted array
                        let fullSched = text
                        var fullSchedArr = fullSched.components(separatedBy: " ")
                        var countval: Int = fullSchedArr.count
                        var x: Int = 0
                        while x < countval {
                            
                            // Look for venues with 2 words
                            if fullSchedArr[x] == "Middle" {
                                fullSchedArr.remove(at: x+1)
                                countval = countval - 1
                            }
                            
                            if fullSchedArr[x] == "Rec" {
                                fullSchedArr.remove(at: x+1)
                                countval = countval - 1
                            }
                            
                            // Look for team names with 2 words
                            if x > 3 {
                                if x < fullSchedArr.count-2 && fullSchedArr[x+2] == "at" {
                                    if dateFormatter.date(from: fullSchedArr[x-4]) != nil{
                                        if "\(fullSchedArr[x]) \(fullSchedArr[x+1])" != team.name{
                                            fullSchedArr[x] = "\(fullSchedArr[x])*\(fullSchedArr[x+1])"
                                            fullSchedArr.remove(at: x+1)
                                            countval = countval - 1
                                        }
                                    }
                                }
                                
                                if x < fullSchedArr.count-2 && dateFormatter.date(from: fullSchedArr[x+2]) != nil {
                                    if fullSchedArr[x-1] == "at" {
                                        if "\(fullSchedArr[x]) \(fullSchedArr[x+1])" != team.name{
                                            fullSchedArr[x] = "\(fullSchedArr[x])*\(fullSchedArr[x+1])"
                                            fullSchedArr.remove(at: x+1)
                                            countval = countval - 1
                                            
                                        }
                                    }
                                }
                            }
                            
                            //Combine team name
                            if brokenTeamArray.count == 2 && fullSchedArr[x] == brokenTeamArray[0]{
                                brokenTeam = "\(brokenTeamArray[0])\(brokenTeamArray[1])"
                                fullSchedArr[x] = brokenTeam
                                fullSchedArr.remove(at: x+1)
                                countval = countval - 1
                            }
                            
                            if brokenTeamArray.count == 1 {
                                brokenTeam = team.name
                            }
                            x = x+1
                        }
                        
                        // Go through each element in unsorted array and sort it into corresponding category
                        for x in 1...30 {
                            if fullSchedArr.count > 7 {
                                // If first team listed is my team, load second team as opponent
                                if (fullSchedArr[4] == brokenTeam) {
                                    DateArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    DayArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    TimeArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    VenueArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    Team1Arr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    AtArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    OpponentArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    team.numberOfGames = team.numberOfGames+1
                                    
                                // If second team listed is my team, load first team as opponent
                                } else if (fullSchedArr[6] == brokenTeam) {
                                    DateArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    DayArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    TimeArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    VenueArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    OpponentArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    AtArr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    Team2Arr.append(fullSchedArr[0])
                                    fullSchedArr.remove(at: 0)
                                    team.numberOfGames = team.numberOfGames+1
                                    
                                // Throw away games which my team is not a part of
                                } else {
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                    fullSchedArr.remove(at: 0)
                                }
                            }
                        }
                        doneloading = true
                        
                        // Readd spaces
                        for x in 0...20 {
                            if x<VenueArr.count && x<OpponentArr.count {
                                if VenueArr[x] == "Middle" {
                                    VenueArr[x] = "Middle 520"
                                }
                                
                                if VenueArr[x] == "Rec" {
                                    VenueArr[x] = "Rec Center"
                                }
                                let charset = CharacterSet(charactersIn: "*")
                                
                                if (OpponentArr[x].rangeOfCharacter(from: charset) != nil) {
                                    let SeparateOpponent = OpponentArr[x].components(separatedBy: "*")
                                    OpponentArr[x] = "\(SeparateOpponent[0]) \(SeparateOpponent[1])"
                                }
                            }
                        }
                        
                        // Save game data
                        if team.numberOfGames >= 1 && doneloading == true {
                            for x in 1...team.numberOfGames {
                                let newGame = Game()
                                self.team.gameList.append(newGame)
                                team.gameList[x-1].Date = DateArr[x-1]
                                team.gameList[x-1].Day = DayArr[x-1]
                                team.gameList[x-1].Time = TimeArr[x-1]
                                team.gameList[x-1].Venue = VenueArr[x-1]
                                team.gameList[x-1].Opponent = OpponentArr[x-1]
                                team.gameList[x-1].GameEdit = "Loaded"
                                if team.playerList.count>0 {
                                    for var a in 0...team.playerList.count-1 {
                                        team.playerList[a].availability = 0
                                    }
                                }
                                team.gameList[x-1].attendancePlayerList = []
                                team.gameList[x-1].introGiven = false
                                team.gameList[x-1].lineupIncomplete = true
                                team.gameList[x-1].SegmentOneArray = []
                                team.gameList[x-1].SegmentTwoArray = []
                                team.gameList[x-1].SegmentThreeArray = []
                                team.gameList[x-1].SegmentFourArray = []
                                team.gameList[x-1].SegmentFiveArray = []
                                team.gameList[x-1].SegmentSixArray = []
                                team.gameList[x-1].sortedRatingArray = []
                                team.gameList[x-1].switchArray = []
                                if team.gameList[x-1].playerLoaded == false{
                                    team.gameList[x-1].playerList = team.playerList
                                    team.gameList[x-1].playerLoaded = true
                                }
                                loadedDateString = "\(team.gameList[x-1].Date) \(team.gameList[x-1].Time)"
                                newFormattedDateString = loadedDateFormat.date(from: loadedDateString)
                                team.gameList[x-1].FormattedDate = newFormattedDateString
                            }
                            currentNewGame = team.numberOfGames
                        }
                        
                        // If team has no data on the website
                        if OpponentArr.isEmpty {
                            let alert = UIAlertController(title: "Team Not Found", message: "Please Check to make sure Team Gender, Grade, and Name is correct", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.performSegue(withIdentifier: "ScheduleToTeamInfo", sender: self)
                            }))
                            self.present(alert, animated: true)
                        }
                        team.gamesPulled = true
                        saveTeams()

                    } catch {
                        let alert = UIAlertController(title: "Error Code 11", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                } catch {
                    let alert = UIAlertController(title: "Error Code 12", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } catch {
                let alert = UIAlertController(title: "Error Code 13", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    // When the reload button is pressed, reload and reparse HTML contents from website
    @IBAction func RelooadPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reload Data?", message: "Reload games from marlborobasketball.com (all manual edits, added games, and lineups will be erased)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if (self.team.playerList.count>1) {
                for var x in 0...self.team.playerList.count-1 {
                    if self.team.playerList[x].availabilityArray.count != 0{
                        for var y in 0...self.team.playerList[x].availabilityArray.count-1{
                            self.team.playerList[x].availabilityArray[y] = 0
                        }
                    }
                }
            }
            self.team.numberOfGames = 0
            self.team.gamesPulled = false
            self.trialLoad()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true)
    }
 */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameInfoSelect" {
            let GameOptionsTableViewController = segue.destination as! GameOptionsTableViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            GameOptionsTableViewController.gameIndex = selectedIndexPath!.row
            GameOptionsTableViewController.team = team
            GameOptionsTableViewController.teamArray = teamArray
            GameOptionsTableViewController.selectedGame = true
        } else if segue.identifier == "ScheduleToTeamInfo" {
            let TeamInfoViewController = segue.destination as! TeamInfoViewController
            TeamInfoViewController.teamIndex = teamIndexBackup
            TeamInfoViewController.teamArray = teamArray
        } else if segue.identifier == "GameInfoNew" {
            /*
            let GameInfoViewController = segue.destination as! GameInfoViewController
            GameInfoViewController.gameIndex = currentNewGame
            GameInfoViewController.team = team
            GameInfoViewController.teamArray = teamArray
            GameInfoViewController.selectedGame = false
            team.gameList[currentNewGame].GameEdit = "Added"
            team.gameList[currentNewGame].playerList = team.playerList
            
            // Add player availability for added games
            if team.playerList.count != 0 {
                for var x in 0...team.playerList.count-1 {
                    team.playerList[x].availabilityArray.append(0)
                }
            }
            saveTeams()
 */
        }  else if segue.identifier == "NewLineup" {
            let GameOptionsTableViewController = segue.destination as! GameOptionsTableViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            GameOptionsTableViewController.team = team
            GameOptionsTableViewController.teamArray = teamArray
            GameOptionsTableViewController.gameIndex = currentNewGame
            team.gameList[currentNewGame].GameEdit = "Added"
            team.gameList[currentNewGame].playerList = team.playerList
            
            // Add player availability for added games
            if team.playerList.count != 0 {
                for var x in 0...team.playerList.count-1 {
                    team.playerList[x].availabilityArray.append(0)
                }
            }
            saveTeams()
        }
    }
}
