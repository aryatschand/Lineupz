//
//  ViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/6/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit

class PlayerListViewController: UITableViewController {

    var teamArray = [Team]()
    var team: Team!
    var currentNewPlayer: Int = 0
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.playerList.count
    }
    
    // Populate rows and delete a player if the information is incomplete
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let player = team.playerList[indexPath.row]
        do {
            if player.name == "remove"{
                let alert = UIAlertController(title: "Player Incomplete", message: "Recently Added/Edited Player Deleted due to Incomplete Information", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                })
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                try team.playerList.remove(at: indexPath.row)
                currentNewPlayer = currentNewPlayer - 1
                savePlayers()
            } else {
                cell.textLabel?.text = player.name
            }
        } catch {
            let alert = UIAlertController(title: "Error Code 10", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Watch for incomplete players when view is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            currentNewPlayer = tableView.numberOfRows(inSection: 0)
            savePlayers()
            if currentNewPlayer != 0 && team.playerList[currentNewPlayer-1].name == "remove" {
                try team.playerList.remove(at: currentNewPlayer-1)
                currentNewPlayer = currentNewPlayer - 1
                savePlayers()
            } else if currentNewPlayer != 0 && team.playerList[currentNewPlayer-1].name == ""{
                try team.playerList.remove(at: currentNewPlayer-1)
                currentNewPlayer = currentNewPlayer - 1
            }
            self.tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: "Error Code 3", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Manually delete players by swiping
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        do {
            if (editingStyle == .delete) {
                let alert = UIAlertController(title: "Delete Player", message: "Are You Sure You Want to Delete Player?", preferredStyle: .alert)
                let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                self.team.playerList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                for var a in 1...self.team.numberOfGames{
                    self.team.gameList[a-1].playerList.remove(at: indexPath.row)
                }
                for var x in 0...self.team.gameList.count {
                    self.team.gameList[x].introGiven = false
                }
                self.currentNewPlayer = self.currentNewPlayer - 1
                self.savePlayers()
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                })
                alert.addAction(delete)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(title: "Error Code 4", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // Segue to player info view when add button is pressed
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Player", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let action = UIAlertAction(title: "Add Player", style: .default) { (action) in
            let newPlayer = Player()
            self.team.playerList.append(newPlayer)
            self.savePlayers()
            self.performSegue(withIdentifier: "PlayerInfoViewControllerNew", sender: self)
            if self.team.gameList.count > 0 {
                for var x in 0...self.team.gameList.count - 1 {
                    self.team.gameList[x].introGiven = false
                }
            }
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func savePlayers() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 19", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerInfoViewControllerSelect" {
            let PlayerInfoViewController = segue.destination as! PlayerInfoViewController
            var selectedIndexPath = tableView.indexPathForSelectedRow
            PlayerInfoViewController.team = team
            PlayerInfoViewController.playerIndex = selectedIndexPath!.row
            PlayerInfoViewController.teamArray = teamArray
            savePlayers()
        } else if segue.identifier == "PlayerInfoViewControllerNew" {
            let PlayerInfoViewController = segue.destination as! PlayerInfoViewController
            PlayerInfoViewController.playerIndex = currentNewPlayer
            PlayerInfoViewController.team = team
            PlayerInfoViewController.teamArray = teamArray
            savePlayers()
        }
    }
}
