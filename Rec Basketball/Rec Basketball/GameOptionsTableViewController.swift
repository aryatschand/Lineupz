//
//  GameOptionsTableViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 8/23/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class GameOptionsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // Set up messaging feature
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Set up emailing feature
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    var EnoughPlayers: Bool = false
    var gameIndex: Int = 0
    var team: Team!
    var teamArray = [Team]()
    var emailArray: [String] = []
    var phoneNumberArray: [String] = []
    var selectedGame: Bool = true
    var remindString: String = ""
    var emailRemindString: String = ""
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    let titleArray: [String] = ["Lineup Name + Details", "Player List (Who's Coming)", "Lineup", "Send Lineup via Email", "Add Pool Player", "Remove Pool Player","Reset Lineup"]
    var NameTwoD: [[String]] = []
    var SegmentOneNameIndex: [String] = []
    var SegmentTwoNameIndex: [String] = []
    var SegmentThreeNameIndex: [String] = []
    var SegmentFourNameIndex: [String] = []
    var SegmentFiveNameIndex: [String] = []
    var SegmentSixNameIndex: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    // Set rows in table and make lineup row red if lineup is incomplete
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTitleCell", for: indexPath)
        if team.gameList[gameIndex].lineupIncomplete == true && indexPath.row == 2 {
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.text = titleArray[indexPath.row] + " - Incomplete"
        } else if team.gameList[gameIndex].lineupIncomplete == false && indexPath.row == 2 {
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = titleArray[indexPath.row] + " - Complete"
        } else {
            cell.textLabel?.text = titleArray[indexPath.row]
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    // If a row is clicked, perform segue or action
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if EnoughPlayers == false && (indexPath.row == 1 || indexPath.row == 2) {
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "Details", sender: self)
            } else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "OptionsToPlayerList", sender: self)
            } else if indexPath.row == 2 {
                var playersNoOpen: Int = 0
                var canSegue: Bool = true
                if team.gameList[gameIndex].SegmentOneArray.count != 0 {
                    for var x in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
                        if team.gameList[gameIndex].SegmentOneArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    for var x in 0...team.gameList[gameIndex].SegmentTwoArray.count-1 {
                        if team.gameList[gameIndex].SegmentTwoArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    for var x in 0...team.gameList[gameIndex].SegmentThreeArray.count-1 {
                        if team.gameList[gameIndex].SegmentThreeArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    for var x in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
                        if team.gameList[gameIndex].SegmentFourArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    for var x in 0...team.gameList[gameIndex].SegmentFiveArray.count-1 {
                        if team.gameList[gameIndex].SegmentFiveArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    for var x in 0...team.gameList[gameIndex].SegmentSixArray.count-1 {
                        if team.gameList[gameIndex].SegmentSixArray[x].name != "OPEN" {
                            playersNoOpen += 1
                        }
                    }
                    if playersNoOpen < 5 {
                        canSegue = false
                    }
                    playersNoOpen = 0
                    if canSegue == true {
                        self.performSegue(withIdentifier: "OptionsToLineup", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Not Enough Players", message: "There are not enough players attending 1+ periods.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        })
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: "OptionsToLineup", sender: self)
                }
            } else if indexPath.row == 3 && team.gameList[gameIndex].sortedRatingArray.count != 0 {
                SegmentOneNameIndex = []
                SegmentTwoNameIndex = []
                SegmentThreeNameIndex = []
                SegmentFourNameIndex = []
                SegmentFiveNameIndex = []
                SegmentSixNameIndex = []
                for var x in 0...team.gameList[gameIndex].SegmentOneArray.count-1{
                    SegmentOneNameIndex.append(team.gameList[gameIndex].SegmentOneArray[x].name)
                }
                for var x in 0...team.gameList[gameIndex].SegmentTwoArray.count-1{
                    SegmentTwoNameIndex.append(team.gameList[gameIndex].SegmentTwoArray[x].name)
                }
                for var x in 0...team.gameList[gameIndex].SegmentThreeArray.count-1{
                    SegmentThreeNameIndex.append(team.gameList[gameIndex].SegmentThreeArray[x].name)
                }
                for var x in 0...team.gameList[gameIndex].SegmentFourArray.count-1{
                    SegmentFourNameIndex.append(team.gameList[gameIndex].SegmentFourArray[x].name)
                }
                for var x in 0...team.gameList[gameIndex].SegmentFiveArray.count-1{
                    SegmentFiveNameIndex.append(team.gameList[gameIndex].SegmentFiveArray[x].name)
                }
                for var x in 0...team.gameList[gameIndex].SegmentSixArray.count-1{
                    SegmentSixNameIndex.append(team.gameList[gameIndex].SegmentSixArray[x].name)
                }
                
                let fileName = "ContactInformation.csv"
                let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                var csvText = "Position,1st Period,2nd Period,3rd Period,4th Period,5th Period, 6th Period\n"
                let count = team.gameList[gameIndex].sortedRatingArray.count
                let player = team.gameList[gameIndex]
                
                if count > 0 {
                    for var x in 0...count-1 {
                        if x == 0 {
                            let newLine = "PG,\(player.SegmentOneArray[0].name),\(player.SegmentTwoArray[0].name),\(player.SegmentThreeArray[0].name),\(player.SegmentFourArray[0].name),\(player.SegmentFiveArray[0].name),\(player.SegmentSixArray[0].name)\n"
                            csvText.append(newLine)
                        } else if x == 1 {
                            let newLine = "SG,\(player.SegmentOneArray[1].name),\(player.SegmentTwoArray[1].name),\(player.SegmentThreeArray[1].name),\(player.SegmentFourArray[1].name),\(player.SegmentFiveArray[1].name),\(player.SegmentSixArray[1].name)\n"
                            csvText.append(newLine)
                        } else if x == 2 {
                            let newLine = "SF,\(player.SegmentOneArray[2].name),\(player.SegmentTwoArray[2].name),\(player.SegmentThreeArray[2].name),\(player.SegmentFourArray[2].name),\(player.SegmentFiveArray[2].name),\(player.SegmentSixArray[2].name)\n"
                            csvText.append(newLine)
                        } else if x == 3 {
                            let newLine = "PF,\(player.SegmentOneArray[3].name),\(player.SegmentTwoArray[3].name),\(player.SegmentThreeArray[3].name),\(player.SegmentFourArray[3].name),\(player.SegmentFiveArray[3].name),\(player.SegmentSixArray[3].name)\n"
                            csvText.append(newLine)
                        } else if x == 4 {
                            let newLine = "C,\(player.SegmentOneArray[4].name),\(player.SegmentTwoArray[4].name),\(player.SegmentThreeArray[4].name),\(player.SegmentFourArray[4].name),\(player.SegmentFiveArray[4].name),\(player.SegmentSixArray[4].name)\n"
                            csvText.append(newLine)
                        } else {
                            if x < player.SegmentOneArray.count && x < player.SegmentFourArray.count {
                                let newLine = "Bench,\(player.SegmentOneArray[x].name),\(player.SegmentTwoArray[x].name),\(player.SegmentThreeArray[x].name),\(player.SegmentFourArray[x].name),\(player.SegmentFiveArray[x].name),\(player.SegmentSixArray[x].name)\n"
                                csvText.append(newLine)
                            } else if x < player.SegmentOneArray.count {
                                let newLine = "Bench,\(player.SegmentOneArray[x].name),\(player.SegmentTwoArray[x].name),\(player.SegmentThreeArray[x].name),,,,\n"
                                csvText.append(newLine)
                            } else if x < player.SegmentOneArray.count {
                                let newLine = "Bench,,,,\(player.SegmentFourArray[x].name),\(player.SegmentFiveArray[x].name),\(player.SegmentSixArray[x].name)\n"
                                csvText.append(newLine)
                            }
                        }
                    }
                }
                
                var emailRemindString : String = ""
                emailRemindString += "Period 1 - "
                for var x in 0...3 {
                    emailRemindString += SegmentOneNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentOneNameIndex[4]
                emailRemindString += " (C)"
                emailRemindString += "\n\nPeriod 2 - "
                for var x in 0...3 {
                    emailRemindString += SegmentTwoNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentTwoNameIndex[4]
                emailRemindString += " (C)"
                emailRemindString += "\n\nPeriod 3 - "
                for var x in 0...3 {
                    emailRemindString += SegmentThreeNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentThreeNameIndex[4]
                emailRemindString += " (C)"
                emailRemindString += "\n\nPeriod 4 - "
                for var x in 0...3 {
                    emailRemindString += SegmentFourNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentFourNameIndex[4]
                emailRemindString += " (C)"
                emailRemindString += "\n\nPeriod 5 - "
                for var x in 0...3 {
                    emailRemindString += SegmentFiveNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentFiveNameIndex[4]
                emailRemindString += " (C)"
                emailRemindString += "\n\nPeriod 6 - "
                for var x in 0...3 {
                    emailRemindString += SegmentSixNameIndex[x]
                    if x == 0 {
                        emailRemindString += " (PG)"
                    } else if x == 1 {
                        emailRemindString += " (SG)"
                    } else if x == 2 {
                        emailRemindString += " (SF)"
                    } else if x == 3 {
                        emailRemindString += " (PF)"
                    }
                    emailRemindString += ", "
                }
                emailRemindString += SegmentSixNameIndex[4]
                emailRemindString += " (C)"
                
                // Compose and popup email
                do {
                    try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setSubject("Lineup")
                    composeVC.setMessageBody("\(emailRemindString)\n\nLineup table attached", isHTML: false)
                    composeVC.addAttachmentData(try NSData(contentsOf: path!) as Data, mimeType: "text/csv", fileName: "ContactInformation.csv")
                    present(composeVC, animated: true, completion: nil)
                } catch {
                }
            } else if indexPath.row == 4 && team.gameList[gameIndex].introGiven == true {
                var poolPlayer = Player()
                poolPlayer.name = "POOL PLAYER"
                poolPlayer.rating = 10
                
                // Add pool player to each period
                team.gameList[gameIndex].playerList.append(poolPlayer)
                team.gameList[gameIndex].SegmentOneArray.append(poolPlayer.copy() as! Player)
                team.gameList[gameIndex].SegmentTwoArray.append(poolPlayer.copy() as! Player)
                team.gameList[gameIndex].SegmentThreeArray.append(poolPlayer.copy() as! Player)
                team.gameList[gameIndex].SegmentFourArray.append(poolPlayer.copy() as! Player)
                team.gameList[gameIndex].SegmentFiveArray.append(poolPlayer.copy() as! Player)
                team.gameList[gameIndex].SegmentSixArray.append(poolPlayer.copy() as! Player)
            } else if indexPath.row == 5 && team.gameList[gameIndex].introGiven == true && NameTwoD[0].contains("POOL PLAYER") {
                // Switch each pool player to OPEN so it can be replaced
                var indexOne: Int = NameTwoD[0].index(of: "POOL PLAYER")!
                var indexTwo: Int = NameTwoD[1].index(of: "POOL PLAYER")!
                var indexThree: Int = NameTwoD[2].index(of: "POOL PLAYER")!
                var indexFour: Int = NameTwoD[3].index(of: "POOL PLAYER")!
                var indexFive: Int = NameTwoD[4].index(of: "POOL PLAYER")!
                var indexSix: Int = NameTwoD[5].index(of: "POOL PLAYER")!
                team.gameList[gameIndex].SegmentOneArray[indexOne].name = "OPEN"
                team.gameList[gameIndex].SegmentTwoArray[indexTwo].name = "OPEN"
                team.gameList[gameIndex].SegmentThreeArray[indexThree].name = "OPEN"
                team.gameList[gameIndex].SegmentFourArray[indexFour].name = "OPEN"
                team.gameList[gameIndex].SegmentFiveArray[indexFive].name = "OPEN"
                team.gameList[gameIndex].SegmentSixArray[indexSix].name = "OPEN"
            } else if indexPath.row == 6 {
                team.gameList[gameIndex].introGiven = false
            }
        }
    }
    
    // If the lineup is incomplete or not enough players are playing, alert the user. Also, set the remind strings for when needed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if team.gameList[gameIndex].name == "" {
            let alert = UIAlertController(title: "Empty Name", message: "Please enter a name for the lineup.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.performSegue(withIdentifier: "Details", sender: self)
            })
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        if team.playerList.count <= 4{
            let alert = UIAlertController(title: "Not Enough Players", message: "Less than 5 players were entered into the team. Please add 5 or more players to make a full team", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            })
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            EnoughPlayers = false
        } else {
             EnoughPlayers = true
        }
        
        team.gameList[gameIndex].playerList = team.playerList
        
        if team.playerList.count != 0 {
            for x in 0...team.playerList.count-1 {
               team.gameList[gameIndex].playerList[x].availability = team.playerList[x].availabilityArray[gameIndex]
            }
        }
 /*
        if team.coachName != "" {
            remindString = "This is a reminder from Coach \(team.coachName) that our game against the \(team.gameList[gameIndex].Opponent) is on \(team.gameList[gameIndex].Date) at \(team.gameList[gameIndex].Time) in \(team.gameList[gameIndex].Venue)."
            emailRemindString = "\(team.name)," + "\n" + "This is a reminder that our game against the \(team.gameList[gameIndex].Opponent) is on \(team.gameList[gameIndex].Date) at \(team.gameList[gameIndex].Time) in \(team.gameList[gameIndex].Venue). Let me know if you can come!" + "\n" + "Coach \(team.coachName)"
        } else if team.coachName == "" {
            remindString = "This is a reminder that our game against the \(team.gameList[gameIndex].Opponent) is on \(team.gameList[gameIndex].Date) at \(team.gameList[gameIndex].Time) in \(team.gameList[gameIndex].Venue)."
            emailRemindString = "\(team.name)," + "\n" + "This is a reminder that our game against the \(team.gameList[gameIndex].Opponent) is on \(team.gameList[gameIndex].Date) at \(team.gameList[gameIndex].Time) in \(team.gameList[gameIndex].Venue). Let me know if you can come!"
        }
 */
        
        if team.gameList[gameIndex].introGiven == true {
            NameTwoD = []
            for var q in 0...5 {
                NameTwoD.append([])
            }
            for var y in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
                NameTwoD[0].append(team.gameList[gameIndex].SegmentOneArray[y].name)
            }
            for var y in 0...team.gameList[gameIndex].SegmentTwoArray.count-1 {
                NameTwoD[1].append(team.gameList[gameIndex].SegmentTwoArray[y].name)
            }
            for var y in 0...team.gameList[gameIndex].SegmentThreeArray.count-1 {
                NameTwoD[2].append(team.gameList[gameIndex].SegmentThreeArray[y].name)
            }
            for var y in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
                NameTwoD[3].append(team.gameList[gameIndex].SegmentFourArray[y].name)
            }
            for var y in 0...team.gameList[gameIndex].SegmentFiveArray.count-1 {
                NameTwoD[4].append(team.gameList[gameIndex].SegmentFiveArray[y].name)
            }
            for var y in 0...team.gameList[gameIndex].SegmentSixArray.count-1 {
                NameTwoD[5].append(team.gameList[gameIndex].SegmentSixArray[y].name)
            }
        }
        saveGame()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func saveGame() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 21", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OptionsToGameInfo" {
            /*var GameInfoViewController = segue.destination as! GameInfoViewController
            GameInfoViewController.gameIndex = gameIndex
            GameInfoViewController.team = team
            GameInfoViewController.teamArray = teamArray
            GameInfoViewController.selectedGame = selectedGame */
        } else if segue.identifier == "OptionsToPlayerList" {
            var LineupPlayerListTableViewController = segue.destination as! LineupPlayerListTableViewController
            LineupPlayerListTableViewController.gameIndex = gameIndex
            LineupPlayerListTableViewController.team = team
            LineupPlayerListTableViewController.teamArray = teamArray
        } else if segue.identifier == "OptionsToLineup" {
            var LineupPageTableView = segue.destination as! LineupPageTableView
            LineupPageTableView.team = team
            LineupPageTableView.gameIndex = gameIndex
            LineupPageTableView.teamArray = teamArray
        } else if segue.identifier == "Details" {
            var LineupDetailsViewController = segue.destination as! LineupDetailsViewController
            LineupDetailsViewController.team = team
            LineupDetailsViewController.gameIndex = gameIndex
            LineupDetailsViewController.teamArray = teamArray
        }
    }
}
