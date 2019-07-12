//
//  TeamListTableViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/14/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit
import SwiftSoup

class TeamListTableViewController: UITableViewController {

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
        
        if team.name == "remove"{
            let alert = UIAlertController(title: "Incomplete Team(s)", message: "1 or more teams has incomplete information. Press Cancel to delete team or Edit to keep team", preferredStyle: .alert)
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
                cell.textLabel?.text = "\(team.name) - \(genderName) \(team.grade)"
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
    
    // Save teams and reload data every time view reappears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentNewTeam = tableView.numberOfRows(inSection: 0)
        saveTeams()
        self.tableView.reloadData()
    }
    
    // Give alert and add a new team when the button is pressed
    @IBAction func addButtonPressed(_ sender: Any) {        
        let alert = UIAlertController(title: "Add New Team", message: "This will take a few seconds to load the team names", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let action = UIAlertAction(title: "Add Team", style: .default) { (action) in
            let newTeam = Team()
            self.teamArray.append(newTeam)
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
