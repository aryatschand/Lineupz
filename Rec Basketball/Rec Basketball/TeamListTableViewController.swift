//
//  TeamListTableViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/14/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit

class TeamListTableViewController: UITableViewController {
    var idNumber: Int = 0
    var htmlcontents: String = ""
    /*
    var Array1: [String] = ["Default", "Bulls", "Bucks"]
    var Array2: [String] = ["Default", "Bulls", "Bucks"]
    var Array3: [String] = ["Default", "Bulls", "Bucks"]
    var Array4: [String] = ["Default", "Bulls", "Bucks"]
    var Array5: [String] = ["Default", "Bulls", "Bucks"]
    var Array6: [String] = ["Default", "Bulls", "Bucks"]
    var Array7: [String] = ["Default", "Bulls", "Bucks"]
    var Array8: [String] = ["Default", "Bulls", "Bucks"]
    var Array15: [String] = ["Default", "Bulls", "Bucks"]
    var Array9: [String] = ["Default", "Bulls", "Bucks"]
    var Array11: [String] = ["Default", "Bulls", "Bucks"]
    var Array12: [String] = ["Default", "Bulls", "Bucks"]
    var Array13: [String] = ["Default", "Bulls", "Bucks"]
    var Array14: [String] = ["Default", "Bulls", "Bucks"]
    var arraylist: [[String]] = []
    let emptyarray: [String] = []
    let idArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 15, 9, 11, 12, 13, 14]
 */
    var teamArray = [Team]()
    var team: Team!
    var currentNewTeam: Int = 0
    var genderName: String = ""
    let teamArrayKey = "teamListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    
    // Call function to load teams from saved file
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTeams()
        LoadTeamNames()
        /*
        if teamArray.count > 0 {
            for var x in 0...teamArray.count-1 {
                teamArray[x].arrayList = arraylist
            }
        }
 */
    }

    // Set number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamArray.count
    }
    
    // Set team information as labels for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamsCell", for: indexPath)
        let team = teamArray[indexPath.row]
        
        if team.gender == 0 {
            genderName = "Boys"
        } else if team.gender == 1 {
            genderName = "Girls"
        }
        /*
        if team.name == "" {
            self.teamArray.remove(at: indexPath.row)
            self.currentNewTeam = self.currentNewTeam - 1
            self.saveTeams()
        }
 */
        
        if team.name == "remove" {
            let alert = UIAlertController(title: "Incomplete Team(s)", message: "1 or more teams has incomplete information. Press Delete to delete team or Edit to keep team", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Delete", style: .cancel) { (action) in
                self.teamArray.remove(at: indexPath.row)
                self.currentNewTeam = self.currentNewTeam - 1
                self.saveTeams()
            }
            do {
                let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                team.delete = false
                team.name = "Incomplete Team"
                cell.textLabel?.text = team.name
                tableView.reloadData()
                }
                alert.addAction(action)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            } catch {
                let alert = UIAlertController(title: "Error Code 0", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        } else {
            if team.name != "Incomplete Team" {
                cell.textLabel?.text = "\(team.name)"
            }
            else if team.name == "Incomplete Team" {
                cell.textLabel?.text = team.name
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Enable the swipe to delete team
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Delete Team", message: "Are You Sure You Want to Delete Team?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                self.teamArray.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.currentNewTeam = self.currentNewTeam - 1
                self.saveTeams()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            })
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func LoadTeamNames() {
         /*
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
 */

    }
    
    // Save teams and reload data every time view reappears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentNewTeam = tableView.numberOfRows(inSection: 0)
        saveTeams()
        self.tableView.reloadData()
        if teamArray.count == 0 {
            let alert = UIAlertController(title: "Hey Coach!", message: "Welcome to Lineupz! Let's start by making a new team.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Let's Do It", style: .default) { (action) in
                let newTeam = Team()
                self.teamArray.append(newTeam)
                //self.teamArray[self.teamArray.count-1].arrayList = self.arraylist
                self.saveTeams()
                self.performSegue(withIdentifier: "TeamInfoViewControllerAdd", sender: self)
            }
            let cancel = UIAlertAction(title: "Not Yet", style: .cancel) { (action) in
                
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Give alert and add a new team when the button is pressed
    @IBAction func addButtonPressed(_ sender: Any) {        
        let alert = UIAlertController(title: "Add New Team", message: "Make sure to complete all infomation on the next page before exiting app.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let action = UIAlertAction(title: "Add Team", style: .default) { (action) in
            let newTeam = Team()
            self.teamArray.append(newTeam)
            //self.teamArray[self.teamArray.count-1].arrayList = self.arraylist
            self.saveTeams()
            self.performSegue(withIdentifier: "TeamInfoViewControllerAdd", sender: self)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // Standard save team function to save information to file for long term storage
    func saveTeams() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 16", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
    
    // Standard load team function to retrieve information from saved file
    func loadTeams() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                teamArray = try decoder.decode([Team].self, from: data)
            } catch {
                let alert = UIAlertController(title: "Error Code 27", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    // Move to other views based on segue tag
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamInfoViewControllerAdd" {
            var TeamInfoViewController = segue.destination as! TeamInfoViewController
            TeamInfoViewController.team = teamArray[currentNewTeam]
            TeamInfoViewController.teamIndex = currentNewTeam
            TeamInfoViewController.teamArray = teamArray
            saveTeams()
        }
        if segue.identifier == "TeamInfoViewControllerEdit" {
            var TeamInfoViewController = segue.destination as! TeamInfoViewController
            TeamInfoViewController.team = teamArray[currentNewTeam]
            TeamInfoViewController.teamIndex = currentNewTeam
            TeamInfoViewController.teamArray = teamArray
            saveTeams()
        }
        if segue.identifier == "TeamOptionsTableViewController" {
            var TeamOptionsTableViewController = segue.destination as! TeamOptionsTableViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            TeamOptionsTableViewController.team = teamArray[selectedIndexPath!.row]
            TeamOptionsTableViewController.teamArray = teamArray
            TeamOptionsTableViewController.teamIndex = selectedIndexPath!.row
            saveTeams()
        }
    }
}
