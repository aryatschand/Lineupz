//
//  TeamOptionsTableViewController.swift
//  
//
//  Created by Arya Tschand on 8/6/18.
//

import UIKit

class TeamOptionsTableViewController: UITableViewController {

    var teamArray = [Team]()
    var team: Team!
    var teamIndex: Int = 0
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    let titleArray: [String] = ["Team Info (Gender, Grade, Name)", "Players (And Player Info)", "Schedule + Lineups"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableTitleCell", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    // When one of the rows are clicked, perform the segue to the corresponding view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "TeamViewController", sender: self)
        } else if indexPath.row == 1 && team.name != "Incomplete Team" {
            self.performSegue(withIdentifier: "PlayerViewController", sender: self)
        } else if indexPath.row == 2 && team.name != "Incomplete Team" {
            self.performSegue(withIdentifier: "ScheduleViewController", sender: self)
        }
    }
    
    // Check for incomplete teams and give the user an option to edit or delete it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if team.name == "remove" {
            let alert = UIAlertController(title: "Incomplete Team", message: "Recently created/edited has incomplete information. Please complete information in Team Info Page.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        savePlayers()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func savePlayers() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 17", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerViewController" {
            var PlayerListViewController = segue.destination as! PlayerListViewController
            PlayerListViewController.team = team
            PlayerListViewController.teamArray = teamArray
        } else if segue.identifier == "ScheduleViewController" {
            var ScheduleTableViewController = segue.destination as! ScheduleTableViewController
            ScheduleTableViewController.teamIndexBackup = teamIndex
            ScheduleTableViewController.team = team
            ScheduleTableViewController.teamArray = teamArray
        } else if segue.identifier == "TeamViewController" {
            var TeamInfoViewController = segue.destination as! TeamInfoViewController
            TeamInfoViewController.team = team
            TeamInfoViewController.teamIndex = teamIndex
            TeamInfoViewController.teamArray = teamArray
            if team.name == "Incomplete Team" || team.name == "" || team.name == "remove" {
                TeamInfoViewController.canEdit = true
            } else {
                TeamInfoViewController.canEdit = false
            }
        }
    }
}
