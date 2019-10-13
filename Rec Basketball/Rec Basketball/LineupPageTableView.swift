//
//  LineupPageTableView.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 9/12/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class LineupPageTableView: UITableViewController, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var TitleLabel: UINavigationItem!
    
    var gameIndex: Int = 0
    var team: Team!
    var teamArray = [Team]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var namePlaced: Bool = false
    var selectionBool: Bool = false
    var switchPlayers: Bool = false
    var switchedPlayerRow: Int = 0
    var segmentSwitched: Bool = false
    var switchPlayerNumber: Int = 0
    var SegmentOneNameIndex: [String] = []
    var SegmentTwoNameIndex: [String] = []
    var SegmentThreeNameIndex: [String] = []
    var SegmentFourNameIndex: [String] = []
    var SegmentFiveNameIndex: [String] = []
    var SegmentSixNameIndex: [String] = []
    var switchPlayerName: String = ""
    var ArrayList: [[Int]] = []
    var numberOfEmpty: Int = 0
    var indexOfPlayer: Int = 0
    var NumberofPlayers: Int = 0
    var completeLineup: Bool = false
    var twoDName: [[String]] = []
    
    @IBOutlet weak var PeriodControlValue: UISegmentedControl!
    
    // When the period is changed, alert the other functions
    @IBAction func PeriodControlChanged(_ sender: UISegmentedControl) {
        sortPlayersByRatingNoFill()
        sortPlayersByRating()
        CheckPlayerPeriods()
        segmentSwitched = true
        tableView.reloadData()
    }
    
    // Auto generate lineup and stop when a valid lineup is created
    @IBAction func AutoGen(_ sender: Any) {
        if team.gameList[gameIndex].sortedRatingArray.count > 4 {
            completeLineup = false
            while completeLineup == false {
                autoLineup()
                CompleteCheck()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Check if the lineup needs to be reset and perform basic checks
    override func viewWillAppear(_ animated: Bool) {
        
        if team.gameList[gameIndex].introGiven == false {
            sortPlayersByRating()
        }
        sortPlayersByRatingNoFill()
        CompleteCheck()
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            if team.gameList[gameIndex].sortedRatingArray[x].delete == true {
                numberOfEmpty+=1
            }
        }
        UpdateNameArray()
        var unavailableArray: [String] = []
        for var x in 0...team.playerList.count-1 {
            if team.playerList[x].availability != 0 {
                unavailableArray.append(team.playerList[x].name)
            }
        }
        if team.gameList[gameIndex].sortedRatingArray.count != team.playerList.count || (team.playerList.count-unavailableArray.count) > team.gameList[gameIndex].sortedRatingArray.count-numberOfEmpty{
            sortPlayersByRating()
        }
        saveGames()
        loadTeams()
        UpdateNameArray()
        CheckPlayerPeriods()
        CompleteCheck()
        tableView.reloadData()
 
    }
    
    // Number of rows are based on the period
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PeriodControlValue.selectedSegmentIndex == 0 {
            return team.gameList[gameIndex].SegmentOneArray.count
        } else if PeriodControlValue.selectedSegmentIndex == 1 {
            return team.gameList[gameIndex].SegmentTwoArray.count
        } else if PeriodControlValue.selectedSegmentIndex == 2 {
            return team.gameList[gameIndex].SegmentThreeArray.count
        } else if PeriodControlValue.selectedSegmentIndex == 3 {
            return team.gameList[gameIndex].SegmentFourArray.count
        } else if PeriodControlValue.selectedSegmentIndex == 4 {
            return team.gameList[gameIndex].SegmentFiveArray.count
        } else if PeriodControlValue.selectedSegmentIndex == 5 {
            return team.gameList[gameIndex].SegmentSixArray.count
        }
        return 0
    }
    
    // Show player names, rating, and which periods they are playing. If a player is being switched, show the user. If one of the switched players is OPEN, replace the row and move the other players up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sortPlayersByRating()
        var nameArray: [String] = []
        var twoDsegment: [[Player]] = []
        
        if PeriodControlValue.selectedSegmentIndex == 0 && indexPath.row > 4 && team.gameList[gameIndex].SegmentOneArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentOneArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentOneArray.count-2 {
                    team.gameList[gameIndex].SegmentOneArray[x] = team.gameList[gameIndex].SegmentOneArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentOneArray.remove(at: team.gameList[gameIndex].SegmentOneArray.count-1)
            tableView.reloadData()
        }
        if PeriodControlValue.selectedSegmentIndex == 1 && indexPath.row > 4 && team.gameList[gameIndex].SegmentTwoArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentTwoArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentTwoArray.count-2 {
                    team.gameList[gameIndex].SegmentTwoArray[x] = team.gameList[gameIndex].SegmentTwoArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentTwoArray.remove(at: team.gameList[gameIndex].SegmentTwoArray.count-1)
            tableView.reloadData()
        }
        if PeriodControlValue.selectedSegmentIndex == 2 && indexPath.row > 4 && team.gameList[gameIndex].SegmentThreeArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentThreeArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentThreeArray.count-2 {
                    team.gameList[gameIndex].SegmentThreeArray[x] = team.gameList[gameIndex].SegmentThreeArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentThreeArray.remove(at: team.gameList[gameIndex].SegmentThreeArray.count-1)
            tableView.reloadData()
        }
        if PeriodControlValue.selectedSegmentIndex == 3 && indexPath.row > 4 && team.gameList[gameIndex].SegmentFourArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentFourArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentFourArray.count-2 {
                    team.gameList[gameIndex].SegmentFourArray[x] = team.gameList[gameIndex].SegmentFourArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentFourArray.remove(at: team.gameList[gameIndex].SegmentFourArray.count-1)
            tableView.reloadData()
        }
        if PeriodControlValue.selectedSegmentIndex == 4 && indexPath.row > 4 && team.gameList[gameIndex].SegmentFiveArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentFiveArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentFiveArray.count-2 {
                    team.gameList[gameIndex].SegmentFiveArray[x] = team.gameList[gameIndex].SegmentFiveArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentFiveArray.remove(at: team.gameList[gameIndex].SegmentFiveArray.count-1)
            tableView.reloadData()
        }
        if PeriodControlValue.selectedSegmentIndex == 5 && indexPath.row > 4 && team.gameList[gameIndex].SegmentSixArray[indexPath.row].name == "OPEN" {
            if indexPath.row < team.gameList[gameIndex].SegmentSixArray.count-1 {
                for var x in indexPath.row...team.gameList[gameIndex].SegmentSixArray.count-2 {
                    team.gameList[gameIndex].SegmentSixArray[x] = team.gameList[gameIndex].SegmentSixArray[x+1]
                }
            }
            team.gameList[gameIndex].SegmentSixArray.remove(at: team.gameList[gameIndex].SegmentSixArray.count-1)
            tableView.reloadData()
        }
        twoDsegment.append(team.gameList[gameIndex].SegmentOneArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentTwoArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentThreeArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentFourArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentFiveArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentSixArray)
        
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            nameArray.append(team.gameList[gameIndex].sortedRatingArray[x].name)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineupPlayerCell", for: indexPath)
        
        if switchPlayers == true && indexPath.row == switchedPlayerRow{
            cell.contentView.backgroundColor = UIColor.red
        } else {
            if indexPath.row <= 4 && twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name != "OPEN" {
                cell.contentView.backgroundColor = UIColor.cyan
            } else if indexPath.row <= 4 && twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name == "OPEN" {
                cell.contentView.backgroundColor = UIColor.orange
            } else {
                cell.contentView.backgroundColor = UIColor.lightGray
            }
        }
        
        if indexPath.row < twoDsegment[PeriodControlValue.selectedSegmentIndex].count && nameArray.contains(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) {
            indexOfPlayer = nameArray.index(of: twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name)!
        }
        
        // Set the cell labels and colors
        if indexPath.row < twoDsegment[PeriodControlValue.selectedSegmentIndex].count {
            var stringNames: [String] = []
            for var x in 0...team.gameList[gameIndex].playerList.count-1 {
                stringNames.append(team.gameList[gameIndex].playerList[x].name)
            }
            var expectedPeriods: Double = 0
            var openFound = false
            var numberWithOpen = twoDsegment[PeriodControlValue.selectedSegmentIndex].count
            for var x in 0...numberWithOpen-1 {
                if twoDsegment[PeriodControlValue.selectedSegmentIndex][x].name == "OPEN" {
                    numberWithOpen -= 1
                    openFound = true
                }
            }
            if openFound == true {
                NumberofPlayers = numberWithOpen
            }
            
            if stringNames.contains(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) == true {
                var playerIndex: Int = stringNames.index(of: twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name)!
                var Partials: Bool = false
                for var t in 0...5 {
                    for var x in 0...twoDsegment[t].count-1 {
                        if twoDsegment[t][x].availability == 2 || twoDsegment[t][x].availability == 3 {
                            Partials = true
                        }
                    }
                }
                
                // Calculate how many periods each player should be playing
                if NumberofPlayers == 5 {
                    expectedPeriods = 6
                } else if NumberofPlayers == 6 {
                    if team.gameList[gameIndex].playerList[playerIndex].availability == 0 && Partials == false {
                        expectedPeriods = 5
                    } else if team.gameList[gameIndex].playerList[playerIndex].availability == 0 && Partials == true {
                        expectedPeriods = 5.5
                    } else {
                        expectedPeriods = 3
                    }
                } else if NumberofPlayers == 7 {
                    if team.gameList[gameIndex].playerList[playerIndex].availability == 0 && Partials == false {
                        if team.gameList[gameIndex].playerList[playerIndex].rating < 35 {
                            expectedPeriods = 4.5
                        } else {
                            expectedPeriods = 4
                        }
                    } else if team.gameList[gameIndex].playerList[playerIndex].availability == 0 && Partials == true {
                        expectedPeriods = 4.5
                    } else {
                        expectedPeriods = 2.5
                    }
                } else if NumberofPlayers == 8 {
                    if team.gameList[gameIndex].playerList[playerIndex].availability == 0 {
                        expectedPeriods = 3.5
                    } else {
                        expectedPeriods = 2.5
                    }
                } else if NumberofPlayers == 9 {
                    if team.gameList[gameIndex].playerList[playerIndex].availability == 0 {
                        expectedPeriods = 3.5
                    } else {
                        expectedPeriods = 2.5
                    }
                } else if NumberofPlayers == 10 {
                    if team.gameList[gameIndex].playerList[playerIndex].availability == 0 {
                        expectedPeriods = 3.5
                    } else {
                        expectedPeriods = 2.5
                    }
                }
            }
            var addedStr: String = ""
            
            // Display to user whether each player needs to play more or less periods
            if Double(ArrayList[indexOfPlayer].count) - expectedPeriods >= 1.0 {
                addedStr = "-"
            } else if Double(ArrayList[indexOfPlayer].count) - expectedPeriods <= -1.0 {
                addedStr = "+"
            } else {
                addedStr = "✓"
            }
            
            // Create text label for each row in tableView
            if ArrayList[indexOfPlayer].count > 0  && twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name != "OPEN" {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "\(addedStr) PG - \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "\(addedStr) SG - \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else if indexPath.row == 2 {
                    cell.textLabel?.text = "\(addedStr) SF - \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else if indexPath.row == 3 {
                    cell.textLabel?.text = "\(addedStr) PF - \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else if indexPath.row == 4 {
                    cell.textLabel?.text = "\(addedStr) C - \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else if ArrayList[indexOfPlayer].count != 0 {
                    cell.textLabel?.text = "\(addedStr) \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name) -  \(ArrayList[indexOfPlayer])"
                } else {
                    cell.textLabel?.text = "\(addedStr) \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name)"
                }
                
            } else if indexPath.row < 5 && twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name == "OPEN" {
                cell.textLabel?.text = "OPEN"
            } else if indexPath.row < twoDsegment[PeriodControlValue.selectedSegmentIndex].count {
                cell.textLabel?.text = "\(addedStr) \(twoDsegment[PeriodControlValue.selectedSegmentIndex][indexPath.row].name)"
            }
        }
        return cell
    }
    
    // If players are switched, change their indexes in the saved arrays
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var switchPlayer: Int = 0
        switchPlayer = switchedPlayerRow
        
        // First player clicked
        if switchPlayers == false {
            switchPlayers = true
            switchedPlayerRow = indexPath.row
            PeriodControlValue.isEnabled = false
            
        // Second player clicked. If it is a different player, swap the indexes
        } else if switchPlayers == true && switchedPlayerRow != indexPath.row {
            PeriodControlValue.isEnabled = true
            CheckPlayerPeriods()
            
            // If neither player is open, perform a basic swap
            if PeriodControlValue.selectedSegmentIndex == 0 && team.gameList[gameIndex].SegmentOneArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentOneArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentOneArray.swapAt(indexPath.row, switchPlayer)
            } else if PeriodControlValue.selectedSegmentIndex == 1 && team.gameList[gameIndex].SegmentTwoArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentTwoArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentTwoArray.swapAt(indexPath.row, switchPlayer)
            } else if PeriodControlValue.selectedSegmentIndex == 2 && team.gameList[gameIndex].SegmentThreeArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentThreeArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentThreeArray.swapAt(indexPath.row, switchPlayer)
            } else if PeriodControlValue.selectedSegmentIndex == 3 && team.gameList[gameIndex].SegmentFourArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentFourArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentFourArray.swapAt(indexPath.row, switchPlayer)
            } else if PeriodControlValue.selectedSegmentIndex == 4 && team.gameList[gameIndex].SegmentFiveArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentFiveArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentFiveArray.swapAt(indexPath.row, switchPlayer)
            } else if PeriodControlValue.selectedSegmentIndex == 5 && team.gameList[gameIndex].SegmentSixArray[indexPath.row].name != "OPEN" && team.gameList[gameIndex].SegmentSixArray[switchPlayer].name != "OPEN" {
                team.gameList[gameIndex].SegmentSixArray.swapAt(indexPath.row, switchPlayer)
            }

            // If one of the players are OPEN, remove the OPEN and move each replace each position with the next player
            if PeriodControlValue.selectedSegmentIndex == 0 && team.gameList[gameIndex].SegmentOneArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentOneArray[indexPath.row] = team.gameList[gameIndex].SegmentOneArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentOneArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentOneArray.count-2 {
                        team.gameList[gameIndex].SegmentOneArray[x] = team.gameList[gameIndex].SegmentOneArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentOneArray.remove(at: team.gameList[gameIndex].SegmentOneArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 1 &&
                team.gameList[gameIndex].SegmentTwoArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentTwoArray[indexPath.row] = team.gameList[gameIndex].SegmentTwoArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentTwoArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentTwoArray.count-2 {
                        team.gameList[gameIndex].SegmentTwoArray[x] = team.gameList[gameIndex].SegmentTwoArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentTwoArray.remove(at: team.gameList[gameIndex].SegmentTwoArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 2 && team.gameList[gameIndex].SegmentThreeArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentThreeArray[indexPath.row] = team.gameList[gameIndex].SegmentThreeArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentThreeArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentThreeArray.count-2 {
                        team.gameList[gameIndex].SegmentThreeArray[x] = team.gameList[gameIndex].SegmentThreeArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentThreeArray.remove(at: team.gameList[gameIndex].SegmentThreeArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 3 && team.gameList[gameIndex].SegmentFourArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentFourArray[indexPath.row] = team.gameList[gameIndex].SegmentFourArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentFourArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentFourArray.count-2 {
                        team.gameList[gameIndex].SegmentFourArray[x] = team.gameList[gameIndex].SegmentFourArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentFourArray.remove(at: team.gameList[gameIndex].SegmentFourArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 4 && team.gameList[gameIndex].SegmentFiveArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentFiveArray[indexPath.row] = team.gameList[gameIndex].SegmentFiveArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentFiveArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentFiveArray.count-2 {
                        team.gameList[gameIndex].SegmentFiveArray[x] = team.gameList[gameIndex].SegmentFiveArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentFiveArray.remove(at: team.gameList[gameIndex].SegmentFiveArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 5 && team.gameList[gameIndex].SegmentSixArray[indexPath.row].name == "OPEN" {
                team.gameList[gameIndex].SegmentSixArray[indexPath.row] = team.gameList[gameIndex].SegmentSixArray[switchPlayer].copy() as! Player
                if switchPlayer < team.gameList[gameIndex].SegmentSixArray.count-1 {
                    for var x in switchPlayer...team.gameList[gameIndex].SegmentSixArray.count-2 {
                        team.gameList[gameIndex].SegmentSixArray[x] = team.gameList[gameIndex].SegmentSixArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentSixArray.remove(at: team.gameList[gameIndex].SegmentSixArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 0 && team.gameList[gameIndex].SegmentOneArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentOneArray[switchPlayer] = team.gameList[gameIndex].SegmentOneArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentOneArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentOneArray.count-2 {
                        team.gameList[gameIndex].SegmentOneArray[x] = team.gameList[gameIndex].SegmentOneArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentOneArray.remove(at: team.gameList[gameIndex].SegmentOneArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 1 && team.gameList[gameIndex].SegmentTwoArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentTwoArray[switchPlayer] = team.gameList[gameIndex].SegmentTwoArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentTwoArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentTwoArray.count-2 {
                        team.gameList[gameIndex].SegmentTwoArray[x] = team.gameList[gameIndex].SegmentTwoArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentTwoArray.remove(at: team.gameList[gameIndex].SegmentTwoArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 2 && team.gameList[gameIndex].SegmentThreeArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentThreeArray[switchPlayer] = team.gameList[gameIndex].SegmentThreeArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentThreeArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentThreeArray.count-2 {
                        team.gameList[gameIndex].SegmentThreeArray[x] = team.gameList[gameIndex].SegmentThreeArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentThreeArray.remove(at: team.gameList[gameIndex].SegmentThreeArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 3 && team.gameList[gameIndex].SegmentFourArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentFourArray[switchPlayer] = team.gameList[gameIndex].SegmentFourArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentFourArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentFourArray.count-2 {
                        team.gameList[gameIndex].SegmentFourArray[x] = team.gameList[gameIndex].SegmentFourArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentFourArray.remove(at: team.gameList[gameIndex].SegmentFourArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 4 && team.gameList[gameIndex].SegmentFiveArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentFiveArray[switchPlayer] = team.gameList[gameIndex].SegmentFiveArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentFiveArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentFiveArray.count-2 {
                        team.gameList[gameIndex].SegmentFiveArray[x] = team.gameList[gameIndex].SegmentFiveArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentFiveArray.remove(at: team.gameList[gameIndex].SegmentFiveArray.count-1)
            } else if PeriodControlValue.selectedSegmentIndex == 5 && team.gameList[gameIndex].SegmentSixArray[switchPlayer].name == "OPEN" {
                team.gameList[gameIndex].SegmentSixArray[switchPlayer] = team.gameList[gameIndex].SegmentSixArray[indexPath.row].copy() as! Player
                if indexPath.row < team.gameList[gameIndex].SegmentSixArray.count-1 {
                    for var x in indexPath.row...team.gameList[gameIndex].SegmentSixArray.count-2 {
                        team.gameList[gameIndex].SegmentSixArray[x] = team.gameList[gameIndex].SegmentSixArray[x+1]
                    }
                }
                team.gameList[gameIndex].SegmentSixArray.remove(at: team.gameList[gameIndex].SegmentSixArray.count-1)
            }
            UpdateNameArray()
            CheckPlayerPeriods()
            CompleteCheck()
            tableView.reloadData()
            saveGames()
            switchPlayers = false
            switchedPlayerRow = 0
            
        // Second player clicked. If it is the same player, reset the swap
        } else if switchPlayers == true && switchedPlayerRow == indexPath.row {
            switchPlayers = false
            switchedPlayerRow = 0
            PeriodControlValue.isEnabled = true
        }
        saveGames()
    }
    
    // Allow the other pages to easily recognize if the lineup is complete
    override func viewWillDisappear(_ animated: Bool) {
        if TitleLabel.title != "Complete" {
            team.gameList[gameIndex].lineupIncomplete = true
        } else {
            team.gameList[gameIndex].lineupIncomplete = false
        }
        saveGames()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func saveGames() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 24", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        tableView.reloadData()
    }
    
    // Populate local name arrays based on saved data
    func UpdateNameArray() {
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
        tableView.reloadData()
    }
    
    func loadTeams() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                teamArray = try decoder.decode([Team].self, from: data)
            } catch {
                let alert = UIAlertController(title: "Error Code 25", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    // Populate sorted array but do not change segment arrays 
    func sortPlayersByRatingNoFill() {
        team.gameList[gameIndex].introGiven = true
        team.gameList[gameIndex].attendancePlayerList = []
        team.gameList[gameIndex].sortedRatingArray = []
        
        for var x in 0...team.gameList[gameIndex].playerList.count-1 {
            if team.gameList[gameIndex].playerList[x].availability != 1 {
                team.gameList[gameIndex].attendancePlayerList.append(team.gameList[gameIndex].playerList[x].copy() as! Player)
            }
        }
        for var x in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
            if team.gameList[gameIndex].SegmentOneArray[x].name == "OPEN" {
                team.gameList[gameIndex].attendancePlayerList.append(team.gameList[gameIndex].SegmentOneArray[x].copy() as! Player)
            }
        }
        for var x in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
            if team.gameList[gameIndex].SegmentFourArray[x].name == "OPEN" {
                team.gameList[gameIndex].attendancePlayerList.append(team.gameList[gameIndex].SegmentFourArray[x].copy() as! Player)
            }
        }
        for var y in 0...team.gameList[gameIndex].attendancePlayerList.count-1 {
            if y == 0 {
                team.gameList[gameIndex].sortedRatingArray.append(team.gameList[gameIndex].attendancePlayerList[y])
            } else if y > 0 {
                repeat {
                    for var z in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
                        if namePlaced == true {
                            break
                        }
                        if team.gameList[gameIndex].attendancePlayerList[y].rating > team.gameList[gameIndex].sortedRatingArray[z].rating {
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z)
                            namePlaced = true
                        } else if team.gameList[gameIndex].attendancePlayerList[y].rating == team.gameList[gameIndex].sortedRatingArray[z].rating{
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                            namePlaced = true
                        } else if z == team.gameList[gameIndex].sortedRatingArray.count-1 {
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                            namePlaced = true
                        }
                    }
                } while namePlaced == false
                namePlaced = false
            }
            team.gameList[gameIndex].sortedRatingArray[y].delete = false
        }
    }
    
    // Sort the players into a new array based on their ratings
    func sortPlayersByRating() {
        var openPlayer = Player()
        openPlayer.name = "OPEN"
        if team.gameList[gameIndex].introGiven == false {
            team.gameList[gameIndex].introGiven = true
            team.gameList[gameIndex].attendancePlayerList = []
            team.gameList[gameIndex].sortedRatingArray = []
            for var x in 0...team.gameList[gameIndex].playerList.count-1{
                if team.gameList[gameIndex].playerList[x].availability != 1 {
                    var temporary = Player()
                    team.gameList[gameIndex].attendancePlayerList.append(team.gameList[gameIndex].playerList[x].copy() as! Player)
                }
            }
            for var y in 0...team.gameList[gameIndex].attendancePlayerList.count-1 {
                if y == 0 {
                    team.gameList[gameIndex].sortedRatingArray.append(team.gameList[gameIndex].attendancePlayerList[y])
                } else if y > 0 {
                    repeat {
                        for var z in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
                            if namePlaced == true {
                                break
                            }
                            if team.gameList[gameIndex].attendancePlayerList[y].rating > team.gameList[gameIndex].sortedRatingArray[z].rating {
                                team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z)
                                namePlaced = true
                            } else if team.gameList[gameIndex].attendancePlayerList[y].rating == team.gameList[gameIndex].sortedRatingArray[z].rating{
                                team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                                namePlaced = true
                            } else if z == team.gameList[gameIndex].sortedRatingArray.count-1 {
                                team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                                namePlaced = true
                            }
                        }
                    } while namePlaced == false
                    namePlaced = false
                }
                team.gameList[gameIndex].sortedRatingArray[y].delete = false
            }
            var sortedArrayWithOpen: [Player] = []
            sortedArrayWithOpen.append(openPlayer.copy() as! Player)
            sortedArrayWithOpen.append(openPlayer.copy() as! Player)
            sortedArrayWithOpen.append(openPlayer.copy() as! Player)
            sortedArrayWithOpen.append(openPlayer.copy() as! Player)
            sortedArrayWithOpen.append(openPlayer.copy() as! Player)
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
                sortedArrayWithOpen.append(team.gameList[gameIndex].sortedRatingArray[x].copy() as! Player)
            }
            var temp2d: [[Player]] = []
            
            for var w in 0...5 {
                temp2d.append([])
                for var r in 0...sortedArrayWithOpen.count-1 {
                    temp2d[w].append(sortedArrayWithOpen[r].copy() as! Player)
                }
            }
            team.gameList[gameIndex].playerListLoaded = true
            team.gameList[gameIndex].switchArray = team.gameList[gameIndex].sortedRatingArray
            team.gameList[gameIndex].SegmentOneArray = temp2d[0]
            removeNonPeriod(period: 1)
            team.gameList[gameIndex].SegmentTwoArray = temp2d[1]
            removeNonPeriod(period: 2)
            team.gameList[gameIndex].SegmentThreeArray = temp2d[2]
            removeNonPeriod(period: 3)
            team.gameList[gameIndex].SegmentFourArray = temp2d[3]
            removeNonPeriod(period: 4)
            team.gameList[gameIndex].SegmentFiveArray = temp2d[4]
            removeNonPeriod(period: 5)
            team.gameList[gameIndex].SegmentSixArray = temp2d[5]
            removeNonPeriod(period: 6)
            
            // Populate local name arrays
            for var x in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
                SegmentOneNameIndex.append(team.gameList[gameIndex].SegmentOneArray[x].name)
            }
            for var x in 0...team.gameList[gameIndex].SegmentTwoArray.count-1 {
                SegmentTwoNameIndex.append(team.gameList[gameIndex].SegmentTwoArray[x].name)
            }
            for var x in 0...team.gameList[gameIndex].SegmentThreeArray.count-1 {
                SegmentThreeNameIndex.append(team.gameList[gameIndex].SegmentThreeArray[x].name)
            }
            for var x in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
                SegmentFourNameIndex.append(team.gameList[gameIndex].SegmentFourArray[x].name)
            }
            for var x in 0...team.gameList[gameIndex].SegmentFiveArray.count-1 {
                SegmentFiveNameIndex.append(team.gameList[gameIndex].SegmentFiveArray[x].name)
            }
            for var x in 0...team.gameList[gameIndex].SegmentSixArray.count-1 {
                SegmentSixNameIndex.append(team.gameList[gameIndex].SegmentSixArray[x].name)
            }
            UpdateNameArray()
            CheckPlayerPeriods()
        }
    }
    
    // To reset lineup for auto generation (Same as regular sortPlayersByRating but does not add OPEN to attendancePlayerList)
    func sortPlayersByRatingNoOpen() {
        team.gameList[gameIndex].introGiven = true
        team.gameList[gameIndex].attendancePlayerList = []
        team.gameList[gameIndex].sortedRatingArray = []
        for var x in 0...team.gameList[gameIndex].playerList.count-1 {
            if team.gameList[gameIndex].playerList[x].availability != 1 && team.gameList[gameIndex].playerList[x].name != "OPEN" {
                var temporary = Player()
                team.gameList[gameIndex].attendancePlayerList.append(team.gameList[gameIndex].playerList[x].copy() as! Player)
            }
        }
        for var y in 0...team.gameList[gameIndex].attendancePlayerList.count-1 {
            if y == 0 {
                team.gameList[gameIndex].sortedRatingArray.append(team.gameList[gameIndex].attendancePlayerList[y])
            } else if y > 0 {
                repeat {
                    for var z in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
                        if namePlaced == true {
                            break
                        }
                        if team.gameList[gameIndex].attendancePlayerList[y].rating > team.gameList[gameIndex].sortedRatingArray[z].rating {
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z)
                            namePlaced = true
                        } else if team.gameList[gameIndex].attendancePlayerList[y].rating == team.gameList[gameIndex].sortedRatingArray[z].rating{
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                            namePlaced = true
                        } else if z == team.gameList[gameIndex].sortedRatingArray.count-1 {
                            team.gameList[gameIndex].sortedRatingArray.insert(team.gameList[gameIndex].attendancePlayerList[y], at: z+1)
                            namePlaced = true
                        }
                    }
                } while namePlaced == false
                namePlaced = false
            }
            team.gameList[gameIndex].sortedRatingArray[y].delete = false
        }
        var temp2d: [[Player]] = []
        
        for var w in 0...5 {
            temp2d.append([])
            for var r in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
                temp2d[w].append(team.gameList[gameIndex].sortedRatingArray[r].copy() as! Player)
            }
        }
        team.gameList[gameIndex].playerListLoaded = true
        team.gameList[gameIndex].switchArray = team.gameList[gameIndex].sortedRatingArray
        team.gameList[gameIndex].SegmentOneArray = temp2d[0]
        removeNonPeriod(period: 1)
        team.gameList[gameIndex].SegmentTwoArray = temp2d[1]
        removeNonPeriod(period: 2)
        team.gameList[gameIndex].SegmentThreeArray = temp2d[2]
        removeNonPeriod(period: 3)
        team.gameList[gameIndex].SegmentFourArray = temp2d[3]
        removeNonPeriod(period: 4)
        team.gameList[gameIndex].SegmentFiveArray = temp2d[4]
        removeNonPeriod(period: 5)
        team.gameList[gameIndex].SegmentSixArray = temp2d[5]
        removeNonPeriod(period: 6)
        
        // Populate local name arrays
        for var x in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
            SegmentOneNameIndex.append(team.gameList[gameIndex].SegmentOneArray[x].name)
        }
        for var x in 0...team.gameList[gameIndex].SegmentTwoArray.count-1 {
            SegmentTwoNameIndex.append(team.gameList[gameIndex].SegmentTwoArray[x].name)
        }
        for var x in 0...team.gameList[gameIndex].SegmentThreeArray.count-1 {
            SegmentThreeNameIndex.append(team.gameList[gameIndex].SegmentThreeArray[x].name)
        }
        for var x in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
            SegmentFourNameIndex.append(team.gameList[gameIndex].SegmentFourArray[x].name)
        }
        for var x in 0...team.gameList[gameIndex].SegmentFiveArray.count-1 {
            SegmentFiveNameIndex.append(team.gameList[gameIndex].SegmentFiveArray[x].name)
        }
        for var x in 0...team.gameList[gameIndex].SegmentSixArray.count-1 {
            SegmentSixNameIndex.append(team.gameList[gameIndex].SegmentSixArray[x].name)
        }
        UpdateNameArray()
        CheckPlayerPeriods()
    }
    
    // Check each period if a player is attending only one half. If they are, remove them from the other half
    func removeNonPeriod(period: Int) {
        var subtract = 0
        if period == 1 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentOneArray.count {
                    if team.gameList[gameIndex].SegmentOneArray[x-subtract].availabilityArray[gameIndex] == 3 {
                        if x < team.gameList[gameIndex].SegmentOneArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentOneArray.count-2 {
                                team.gameList[gameIndex].SegmentOneArray[y] = team.gameList[gameIndex].SegmentOneArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentOneArray.remove(at: team.gameList[gameIndex].SegmentOneArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
            subtract = 0
        } else if period == 2 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentTwoArray.count {
                    if team.gameList[gameIndex].SegmentTwoArray[x-subtract].availabilityArray[gameIndex] == 3 {
                        if x < team.gameList[gameIndex].SegmentTwoArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentTwoArray.count-2 {
                                team.gameList[gameIndex].SegmentTwoArray[y] = team.gameList[gameIndex].SegmentTwoArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentTwoArray.remove(at: team.gameList[gameIndex].SegmentTwoArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
            subtract = 0
        } else if period == 3 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentThreeArray.count {
                    if team.gameList[gameIndex].SegmentThreeArray[x-subtract].availabilityArray[gameIndex] == 3 {
                        if x < team.gameList[gameIndex].SegmentThreeArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentThreeArray.count-2 {
                                team.gameList[gameIndex].SegmentThreeArray[y] = team.gameList[gameIndex].SegmentThreeArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentThreeArray.remove(at: team.gameList[gameIndex].SegmentThreeArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
            subtract = 0
        } else if period == 4 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentFourArray.count {
                    if team.gameList[gameIndex].SegmentFourArray[x-subtract].availabilityArray[gameIndex] == 2 {
                        if x < team.gameList[gameIndex].SegmentFourArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentFourArray.count-2 {
                                team.gameList[gameIndex].SegmentFourArray[y] = team.gameList[gameIndex].SegmentFourArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentFourArray.remove(at: team.gameList[gameIndex].SegmentFourArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
            subtract = 0
        } else if period == 5 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentFiveArray.count {
                    if team.gameList[gameIndex].SegmentFiveArray[x-subtract].availabilityArray[gameIndex] == 2 {
                        if x < team.gameList[gameIndex].SegmentFiveArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentFiveArray.count-2 {
                                team.gameList[gameIndex].SegmentFiveArray[y] = team.gameList[gameIndex].SegmentFiveArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentFiveArray.remove(at: team.gameList[gameIndex].SegmentFiveArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
            subtract = 0
        } else if period == 6 {
            for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1{
                if x < team.gameList[gameIndex].SegmentSixArray.count {
                    if team.gameList[gameIndex].SegmentSixArray[x-subtract].availabilityArray[gameIndex] == 2 {
                        if x < team.gameList[gameIndex].SegmentSixArray.count-1 {
                            for var y in x-subtract...team.gameList[gameIndex].SegmentSixArray.count-2 {
                                team.gameList[gameIndex].SegmentSixArray[y] = team.gameList[gameIndex].SegmentSixArray[y+1]
                            }
                        }
                        team.gameList[gameIndex].SegmentSixArray.remove(at: team.gameList[gameIndex].SegmentSixArray.count-1)
                        subtract = subtract + 1
                    }
                }
            }
        }
        subtract = 0
    }
    
    // Check to see if the player periods comply with Marlboro Rec rules
    func CompleteCheck() {
        updateTwoDName()
        var noOpens: Bool = true
        
        for var x in 0...5 {
            for var y in 0...twoDName[x].count-1 {
                if twoDName[x][y] == "OPEN" {
                    noOpens = false
                }
            }
        }
        
        // Number of playing and partial playing players
        var numberplay = NumberofPlayers
        if team.gameList[gameIndex].SegmentOneArray.count < 5 || team.gameList[gameIndex].SegmentFourArray.count < 5 {
            numberplay = 0
        }
        var numberpartial = 0
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            if team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 2 || team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 3 {
                numberpartial = numberpartial + 1
            }
        }
        
        if noOpens == true {
            
            // Count how many periods each player is playing
            var NumberPeriods: [Int] = []
            var ThreeSegments: [Int] = []
            var FourSegments: [Int] = []
            var FiveSegmentsHigh: [Int] = []
            var FiveSegmentsLow: [Int] = []
            var SixSegments: [Int] = []
            var fullPartial: [Int] = []
            var fullThreePartial: [Int] = []
            var emptyPartial: [Int] = []
            if numberplay>0 {
                for var x in 0...numberplay-1 {
                    NumberPeriods.append(ArrayList[x].count)
                    if NumberPeriods[x] == 3 && (team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 2 || team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 3){
                        fullThreePartial.append(1)
                    }
                    if (NumberPeriods[x] == 2 || NumberPeriods[x] == 3) && (team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 2 || team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 3) {
                        fullPartial.append(1)
                    } else if NumberPeriods[x] == 3 && team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 0 {
                        ThreeSegments.append(1)
                    } else if NumberPeriods[x] == 4 && team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 0 {
                        FourSegments.append(1)
                    } else if NumberPeriods[x] == 5 && team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 0 && team.gameList[gameIndex].sortedRatingArray[x].rating >= 35 {
                        FiveSegmentsHigh.append(1)
                    } else if NumberPeriods[x] == 5 && team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 0 && team.gameList[gameIndex].sortedRatingArray[x].rating < 35 {
                        FiveSegmentsLow.append(1)
                    } else if NumberPeriods[x] == 6 && team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 0{
                        SixSegments.append(1)
                    } else if (NumberPeriods[x] == 1 || NumberPeriods[x] == 0) && (team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 2 || team.gameList[gameIndex].sortedRatingArray[x].availabilityArray[gameIndex] == 3) {
                        emptyPartial.append(1)
                    }
                }
            }
            
            // Based on number of players, check to see if the lineup is complete
            if numberplay == 5 && SixSegments.count == 5 {
                TitleLabel.title = "Complete"
                completeLineup = true
            } else if numberplay == 6 {
                if FiveSegmentsHigh.count + FiveSegmentsLow.count + SixSegments.count + fullThreePartial.count >= 6 {
                    TitleLabel.title = "Complete"
                    completeLineup = true
                } else {
                    TitleLabel.title = "Incomplete"
                    completeLineup = false
                }
            } else if numberplay == 7 {
                if FourSegments.count + FiveSegmentsLow.count >= 7 {
                    TitleLabel.title = "Complete"
                    completeLineup = true
                } else if fullPartial.count >= 1 && FourSegments.count + FiveSegmentsLow.count + FiveSegmentsHigh.count + fullPartial.count >= 7 {
                    TitleLabel.title = "Complete"
                    completeLineup = true
                } else {
                    TitleLabel.title = "Incomplete"
                    completeLineup = false
                }
            } else if numberplay == 8 {
                if fullPartial.count > 1 {
                    if FourSegments.count + FiveSegmentsLow.count + FiveSegmentsHigh.count + fullPartial.count >= 8 {
                        TitleLabel.title = "Complete"
                        completeLineup = true
                    } else {
                        TitleLabel.title = "Incomplete"
                        completeLineup = false
                    }
                } else {
                    if ThreeSegments.count + FourSegments.count + fullPartial.count >= 8 {
                        TitleLabel.title = "Complete"
                        completeLineup = true
                    } else {
                        TitleLabel.title = "Incomplete"
                        completeLineup = false
                    }
                }
            } else if numberplay == 9 {
                if ThreeSegments.count + FourSegments.count + fullPartial.count >= 9 {
                    TitleLabel.title = "Complete"
                    completeLineup = true
                } else {
                    TitleLabel.title = "Incomplete"
                    completeLineup = false
                }
            } else if numberplay == 10 {
                if ThreeSegments.count + FourSegments.count + fullPartial.count >= 10 {
                    TitleLabel.title = "Complete"
                    completeLineup = true
                } else {
                    TitleLabel.title = "Incomplete"
                    completeLineup = false
                }
            }
        } else {
            TitleLabel.title = "Incomplete"
            completeLineup = false
        }
        
        if team.gameList[gameIndex].sortedRatingArray.count <= 4 || numberplay == 0 {
            TitleLabel.title = "Not Enough Players"
            completeLineup = false
        }
        saveGames()
    }
    
    // Update the values of the array to match the lineup
    func updateTwoDName() {
        twoDName = []
        twoDName.append([])
        twoDName.append([])
        twoDName.append([])
        twoDName.append([])
        twoDName.append([])
        twoDName.append([])

        for var r in 0...team.gameList[gameIndex].SegmentOneArray.count-1 {
            twoDName[0].append(team.gameList[gameIndex].SegmentOneArray[r].name)
        }
        for var r in 0...team.gameList[gameIndex].SegmentTwoArray.count-1 {
            twoDName[1].append(team.gameList[gameIndex].SegmentTwoArray[r].name)
        }
        for var r in 0...team.gameList[gameIndex].SegmentThreeArray.count-1 {
            twoDName[2].append(team.gameList[gameIndex].SegmentThreeArray[r].name)
        }
        for var r in 0...team.gameList[gameIndex].SegmentFourArray.count-1 {
            twoDName[3].append(team.gameList[gameIndex].SegmentFourArray[r].name)
        }
        for var r in 0...team.gameList[gameIndex].SegmentFiveArray.count-1 {
            twoDName[4].append(team.gameList[gameIndex].SegmentFiveArray[r].name)
        }
        for var r in 0...team.gameList[gameIndex].SegmentSixArray.count-1 {
            twoDName[5].append(team.gameList[gameIndex].SegmentSixArray[r].name)
        }
    }
    
    // Auto generate lineup that is compliant with Marlboro Rec rules
    func autoLineup() {
        updateTwoDName()
        sortPlayersByRatingNoOpen()
        var expectedPeriods: Double = 0
        var Partials: Bool = false
        var twoDsegment: [[Player]] = []
        twoDsegment.append(team.gameList[gameIndex].SegmentOneArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentTwoArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentThreeArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentFourArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentFiveArray)
        twoDsegment.append(team.gameList[gameIndex].SegmentSixArray)
        
        // Arrays represent the total number of starting positions (5 per period * 6 periods = 30 positions), knocked off from array when each position is filled
        var remainingPeriods: [Int] = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6]
        var remainingPositions: [Int] = [0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4]
        var playingPeriods: [[Int]] = []
        
        for var x in 0...team.gameList[gameIndex].attendancePlayerList.count-1 {
            playingPeriods.append([])
        }
        
        for var t in 0...5 {
            for var x in 0...twoDsegment[t].count-1 {
                if twoDsegment[t][x].availability == 2 || twoDsegment[t][x].availability == 3 {
                    Partials = true
                }
            }
        }

        // Find number of periods each player should be playing
        for var x in 0...NumberofPlayers-1 {
            if NumberofPlayers == 5 {
                expectedPeriods = 6
            } else if NumberofPlayers == 6 {
                if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 && Partials == false {
                    expectedPeriods = 5
                } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 && Partials == true {
                    expectedPeriods = 5.5
                } else {
                    expectedPeriods = 3
                }
            } else if NumberofPlayers == 7 {
                if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 && Partials == false {
                    if team.gameList[gameIndex].sortedRatingArray[x].rating < 35 {
                        expectedPeriods = 4.5
                    } else {
                        expectedPeriods = 4
                    }
                } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 && Partials == true {
                    expectedPeriods = 4.5
                } else {
                    expectedPeriods = 2.5
                }
            } else if NumberofPlayers == 8 {
                if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 {
                    expectedPeriods = 3.5
                } else {
                    expectedPeriods = 2.5
                }
            } else if NumberofPlayers == 9 {
                if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 {
                    expectedPeriods = 3.5
                } else {
                    expectedPeriods = 2.5
                }
            } else if NumberofPlayers == 10 {
                if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 {
                    expectedPeriods = 3.5
                } else {
                    expectedPeriods = 2.5
                }
            }
            updateTwoDName()
            var skips: Int = 0
            var u = 0
            
            // Find minimum number of periods each player must be playing
            var minperiods = Int(expectedPeriods/1)
            
            // Run through minimum number of periods and fill segment arrays
            while u < minperiods {
                updateTwoDName()
                
                // Select random period and position for player
                let number = Int.random(in: 0...remainingPeriods.count-1)
                
                // If the player is not already playing in that period, swap the designated player with the player already in the designated position
                if playingPeriods[x].contains(remainingPeriods[number]) == false {
                    if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 {
                        updateTwoDName()
                        var indexOne: Int = twoDName[0].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexTwo: Int = twoDName[1].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexThree: Int = twoDName[2].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexFour: Int = twoDName[3].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexFive: Int = twoDName[4].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexSix: Int = twoDName[5].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        playingPeriods[x].append(remainingPeriods[number])
                        if remainingPeriods[number] == 1 {
                            team.gameList[gameIndex].SegmentOneArray.swapAt(remainingPositions[number], indexOne)
                            updateTwoDName()
                        } else if remainingPeriods[number] == 2 {
                            team.gameList[gameIndex].SegmentTwoArray.swapAt(remainingPositions[number], indexTwo)
                            updateTwoDName()
                        } else if remainingPeriods[number] == 3 {
                            team.gameList[gameIndex].SegmentThreeArray.swapAt(remainingPositions[number], indexThree)
                            updateTwoDName()
                        } else if remainingPeriods[number] == 4 {
                            team.gameList[gameIndex].SegmentFourArray.swapAt(remainingPositions[number], indexFour)
                            updateTwoDName()
                        } else if remainingPeriods[number] == 5 {
                            team.gameList[gameIndex].SegmentFiveArray.swapAt(remainingPositions[number], indexFive)
                            updateTwoDName()
                        } else if remainingPeriods[number] == 6 {
                            team.gameList[gameIndex].SegmentSixArray.swapAt(remainingPositions[number], indexSix)
                            updateTwoDName()
                        }
                        remainingPeriods.remove(at: number)
                        remainingPositions.remove(at: number)
                    } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 2 {
                        var indexOne: Int = twoDName[0].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexTwo: Int = twoDName[1].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexThree: Int = twoDName[2].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        if remainingPeriods[number] == 1 {
                            team.gameList[gameIndex].SegmentOneArray.swapAt(remainingPositions[number], indexOne)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else if remainingPeriods[number] == 2 {
                            team.gameList[gameIndex].SegmentTwoArray.swapAt(remainingPositions[number], indexTwo)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else if remainingPeriods[number] == 3 {
                            team.gameList[gameIndex].SegmentThreeArray.swapAt(remainingPositions[number], indexThree)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else {
                            if skips < 10 {
                                u-=1
                                skips += 1
                            }
                        }
                    } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 3 {
                        var indexFour: Int = twoDName[3].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexFive: Int = twoDName[4].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        var indexSix: Int = twoDName[5].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                        if remainingPeriods[number] == 4 {
                            team.gameList[gameIndex].SegmentFourArray.swapAt(remainingPositions[number], indexFour)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else if remainingPeriods[number] == 5 {
                            team.gameList[gameIndex].SegmentFiveArray.swapAt(remainingPositions[number], indexFive)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else if remainingPeriods[number] == 6 {
                            team.gameList[gameIndex].SegmentSixArray.swapAt(remainingPositions[number], indexSix)
                            updateTwoDName()
                            playingPeriods[x].append(remainingPeriods[number])
                            remainingPeriods.remove(at: number)
                            remainingPositions.remove(at: number)
                        } else {
                            if skips < 10 {
                                u-=1
                                skips += 1
                            }
                        }
                    }
                } else {
                    if skips < 10 {
                        u-=1
                        skips += 1
                    }
                }
                u += 1
            }
        }
        tableView.reloadData()
        
        // Fill remaining periods by prioritizing the highest rated players
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            updateTwoDName()
            if (NumberofPlayers != 7 || Partials == true || team.gameList[gameIndex].sortedRatingArray[x].rating < 35) && remainingPeriods.count > 0 {
                for var y in 0...remainingPeriods.count-1 {
                    if playingPeriods[x].contains(remainingPeriods[y]) == false {
                        if team.gameList[gameIndex].sortedRatingArray[x].availability == 0 {
                            updateTwoDName()
                            var indexOne: Int = twoDName[0].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexTwo: Int = twoDName[1].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexThree: Int = twoDName[2].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexFour: Int = twoDName[3].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexFive: Int = twoDName[4].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexSix: Int = twoDName[5].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            if remainingPeriods[y] == 1 {
                                team.gameList[gameIndex].SegmentOneArray.swapAt(remainingPositions[y], indexOne)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 2 {
                                team.gameList[gameIndex].SegmentTwoArray.swapAt(remainingPositions[y], indexTwo)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 3 {
                                team.gameList[gameIndex].SegmentThreeArray.swapAt(remainingPositions[y], indexThree)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 4 {
                                team.gameList[gameIndex].SegmentFourArray.swapAt(remainingPositions[y], indexFour)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 5 {
                                team.gameList[gameIndex].SegmentFiveArray.swapAt(remainingPositions[y], indexFive)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 6 {
                                team.gameList[gameIndex].SegmentSixArray.swapAt(remainingPositions[y], indexSix)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            }
                        } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 2 {
                            updateTwoDName()
                            var indexOne: Int = twoDName[0].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexTwo: Int = twoDName[1].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexThree: Int = twoDName[2].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            if remainingPeriods[y] == 1 {
                                team.gameList[gameIndex].SegmentOneArray.swapAt(remainingPositions[y], indexOne)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 2 {
                                team.gameList[gameIndex].SegmentTwoArray.swapAt(remainingPositions[y], indexTwo)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 3 {
                                team.gameList[gameIndex].SegmentThreeArray.swapAt(remainingPositions[y], indexThree)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            }
                        } else if team.gameList[gameIndex].sortedRatingArray[x].availability == 3 {
                            updateTwoDName()
                            var indexFour: Int = twoDName[3].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexFive: Int = twoDName[4].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            var indexSix: Int = twoDName[5].index(of: team.gameList[gameIndex].sortedRatingArray[x].name)!
                            if remainingPeriods[y] == 4 {
                                team.gameList[gameIndex].SegmentFourArray.swapAt(remainingPositions[y], indexFour)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 5 {
                                team.gameList[gameIndex].SegmentFiveArray.swapAt(remainingPositions[y], indexFive)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            } else if remainingPeriods[y] == 6 {
                                team.gameList[gameIndex].SegmentSixArray.swapAt(remainingPositions[y], indexSix)
                                updateTwoDName()
                                playingPeriods[x].append(remainingPeriods[y])
                                remainingPeriods.remove(at: y)
                                remainingPositions.remove(at: y)
                                break
                            }
                        }
                    }
                }
            }
        }
        sortPlayersByRatingNoFill()
        sortPlayersByRating()
        CheckPlayerPeriods()
        tableView.reloadData()
        saveGames()
        CompleteCheck()
    }
    
    // Check which periods each player is playing to display to user and use in CompleteCheck function
    func CheckPlayerPeriods(){
        UpdateNameArray()
        ArrayList = []
        NumberofPlayers = 0
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            ArrayList.append([])
        }
        for var x in 0...team.gameList[gameIndex].sortedRatingArray.count-1 {
            if team.gameList[gameIndex].sortedRatingArray[x].name != "Empty" || team.gameList[gameIndex].sortedRatingArray[x].name != "OPEN"{
                var tempname = team.gameList[gameIndex].sortedRatingArray[x].name
                var index1 = 5
                var index2 = 5
                var index3 = 5
                var index4 = 5
                var index5 = 5
                var index6 = 5
                if SegmentOneNameIndex.contains(tempname) == true {
                    index1 = SegmentOneNameIndex.index(of: tempname)!
                }
                if SegmentTwoNameIndex.contains(tempname) == true {
                    index2 = SegmentTwoNameIndex.index(of: tempname)!
                }
                if SegmentThreeNameIndex.contains(tempname) == true {
                    index3 = SegmentThreeNameIndex.index(of: tempname)!
                }
                if SegmentFourNameIndex.contains(tempname) == true {
                    index4 = SegmentFourNameIndex.index(of: tempname)!
                }
                if SegmentFiveNameIndex.contains(tempname) == true {
                    index5 = SegmentFiveNameIndex.index(of: tempname)!
                }
                if SegmentSixNameIndex.contains(tempname) == true {
                    index6 = SegmentSixNameIndex.index(of: tempname)!
                }
                if index1 <= 4 {
                    ArrayList[x].append(1)
                }
                if index2 <= 4 {
                    ArrayList[x].append(2)
                }
                if index3 <= 4 {
                    ArrayList[x].append(3)
                }
                if index4 <= 4 {
                    ArrayList[x].append(4)
                }
                if index5 <= 4 {
                    ArrayList[x].append(5)
                }
                if index6 <= 4 {
                    ArrayList[x].append(6)
                }
                NumberofPlayers += 1
            }
        tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LineupToRules" {
            var LineupRulesInfoViewController = segue.destination as! LineupRulesInfoViewController
            LineupRulesInfoViewController.gameIndex = gameIndex
            LineupRulesInfoViewController.team = team
            LineupRulesInfoViewController.teamArray = teamArray
            LineupRulesInfoViewController.number = NumberofPlayers
        }
    }
}
