//
//  LineupPlayerListTableViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 8/23/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import UIKit

class LineupPlayerListTableViewController: UITableViewController {
    var gameIndex: Int = 0
    var team: Team!
    var teamArray = [Team]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    var originalArray: [Int] = []
    var NameTwoD: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.gameList[gameIndex].playerList.count
    }
    
    // Show player availability status and color the row based on status
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let player = team.gameList[gameIndex].playerList[indexPath.row]
        if player.availability == 0 {
            cell.textLabel?.text = "\(player.name) - Available"
            cell.textLabel?.textColor = UIColor.green
        } else if player.availability == 1 {
            cell.textLabel?.text = "\(player.name) - Unavailable"
            cell.textLabel?.textColor = UIColor.red
        } else if player.availability == 2 {
            cell.textLabel?.text = "\(player.name) - 1st Half"
            cell.textLabel?.textColor = UIColor.orange
        } else if player.availability == 3 {
            cell.textLabel?.text = "\(player.name) - 2nd Half"
            cell.textLabel?.textColor = UIColor.orange
        }
        team.gameList[gameIndex].playerListLoaded = false
        return cell
    }
    
    // Toggle availability status each time the row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let player = team.gameList[gameIndex].playerList[indexPath.row]
        if player.availability == 0 {
            player.availability = 1
            cell.textLabel?.text = "\(player.name) - Unavailable"
            cell.textLabel?.textColor = UIColor.red
            team.playerList[indexPath.row].availabilityArray[gameIndex] = 1
        } else if player.availability == 1 {
            player.availability = 2
            cell.textLabel?.text = "\(player.name) - 1st Half"
            cell.textLabel?.textColor = UIColor.orange
            team.playerList[indexPath.row].availabilityArray[gameIndex] = 2
        } else if player.availability == 2 {
            player.availability = 3
            cell.textLabel?.text = "\(player.name) - 2nd Half"
            cell.textLabel?.textColor = UIColor.orange
            team.playerList[indexPath.row].availabilityArray[gameIndex] = 3
        } else if player.availability == 3 {
            player.availability = 0
            cell.textLabel?.text = "\(player.name) - Available"
            cell.textLabel?.textColor = UIColor.green
            team.playerList[indexPath.row].availabilityArray[gameIndex] = 0
            team.gameList[gameIndex].playerList[indexPath.row].availability = 0
        }
        saveGame()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Populate and original array with availabilities of players
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NameTwoD = []
        for var q in 0...5 {
            NameTwoD.append([])
        }
        
        for var x in 0...team.playerList.count-1
        {
            originalArray.append(team.playerList[x].availabilityArray[gameIndex])
        }
        saveGame()
        self.tableView.reloadData()
    }
    
    // When back is clicked, check if any availabilities were changed and change the segment arrays accordingly
    override func viewWillDisappear(_ animated: Bool) {
        for var x in 0...originalArray.count-1
        {
            if originalArray[x] != team.playerList[x].availabilityArray[gameIndex] && team.gameList[gameIndex].sortedRatingArray.count != 0 {
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
                
                if originalArray[x] == 0 {
                    if team.playerList[x].availabilityArray[gameIndex] == 1 {
                        var indexOne: Int = NameTwoD[0].index(of: team.playerList[x].name)!
                        var indexTwo: Int = NameTwoD[1].index(of: team.playerList[x].name)!
                        var indexThree: Int = NameTwoD[2].index(of: team.playerList[x].name)!
                        var indexFour: Int = NameTwoD[3].index(of: team.playerList[x].name)!
                        var indexFive: Int = NameTwoD[4].index(of: team.playerList[x].name)!
                        var indexSix: Int = NameTwoD[5].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentOneArray[indexOne].name = "OPEN"
                        team.gameList[gameIndex].SegmentTwoArray[indexTwo].name = "OPEN"
                        team.gameList[gameIndex].SegmentThreeArray[indexThree].name = "OPEN"
                        team.gameList[gameIndex].SegmentFourArray[indexFour].name = "OPEN"
                        team.gameList[gameIndex].SegmentFiveArray[indexFive].name = "OPEN"
                        team.gameList[gameIndex].SegmentSixArray[indexSix].name = "OPEN"
                    } else if team.playerList[x].availabilityArray[gameIndex] == 2 {
                        var indexFour: Int = NameTwoD[3].index(of: team.playerList[x].name)!
                        var indexFive: Int = NameTwoD[4].index(of: team.playerList[x].name)!
                        var indexSix: Int = NameTwoD[5].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentFourArray[indexFour].name = "OPEN"
                        team.gameList[gameIndex].SegmentFiveArray[indexFive].name = "OPEN"
                        team.gameList[gameIndex].SegmentSixArray[indexSix].name = "OPEN"
                    } else if team.playerList[x].availabilityArray[gameIndex] == 3 {
                        var indexOne: Int = NameTwoD[0].index(of: team.playerList[x].name)!
                        var indexTwo: Int = NameTwoD[1].index(of: team.playerList[x].name)!
                        var indexThree: Int = NameTwoD[2].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentOneArray[indexOne].name = "OPEN"
                        team.gameList[gameIndex].SegmentTwoArray[indexTwo].name = "OPEN"
                        team.gameList[gameIndex].SegmentThreeArray[indexThree].name = "OPEN"
                    }
                } else if originalArray[x] == 1 {
                    if team.playerList[x].availabilityArray[gameIndex] == 0 {
                        team.gameList[gameIndex].SegmentOneArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentTwoArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentThreeArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentFourArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentFiveArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentSixArray.append(team.playerList[x].copy() as! Player)
                    } else if team.playerList[x].availabilityArray[gameIndex] == 2 {
                        team.gameList[gameIndex].SegmentOneArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentTwoArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentThreeArray.append(team.playerList[x].copy() as! Player)
                    } else if team.playerList[x].availabilityArray[gameIndex] == 3 {
                        team.gameList[gameIndex].SegmentFourArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentFiveArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentSixArray.append(team.playerList[x].copy() as! Player)
                    }
                    team.gameList[gameIndex].sortedRatingArray.append(team.playerList[x].copy() as! Player)
                } else if originalArray[x] == 2 {
                    if team.playerList[x].availabilityArray[gameIndex] == 1 {
                        var indexOne: Int = NameTwoD[0].index(of: team.playerList[x].name)!
                        var indexTwo: Int = NameTwoD[1].index(of: team.playerList[x].name)!
                        var indexThree: Int = NameTwoD[2].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentOneArray[indexOne].name = "OPEN"
                        team.gameList[gameIndex].SegmentTwoArray[indexTwo].name = "OPEN"
                        team.gameList[gameIndex].SegmentThreeArray[indexThree].name = "OPEN"
                    } else if team.playerList[x].availabilityArray[gameIndex] == 0 {
                        team.gameList[gameIndex].SegmentFourArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentFiveArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentSixArray.append(team.playerList[x].copy() as! Player)
                    } else if team.playerList[x].availabilityArray[gameIndex] == 3 {
                        var indexOne: Int = NameTwoD[0].index(of: team.playerList[x].name)!
                        var indexTwo: Int = NameTwoD[1].index(of: team.playerList[x].name)!
                        var indexThree: Int = NameTwoD[2].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentOneArray[indexOne].name = "OPEN"
                        team.gameList[gameIndex].SegmentTwoArray[indexTwo].name = "OPEN"
                        team.gameList[gameIndex].SegmentThreeArray[indexThree].name = "OPEN"
                        team.gameList[gameIndex].SegmentFourArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentFiveArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentSixArray.append(team.playerList[x].copy() as! Player)
                    }
                } else if originalArray[x] == 3 {
                    if team.playerList[x].availabilityArray[gameIndex] == 1 {
                        var indexFour: Int = NameTwoD[3].index(of: team.playerList[x].name)!
                        var indexFive: Int = NameTwoD[4].index(of: team.playerList[x].name)!
                        var indexSix: Int = NameTwoD[5].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentFourArray[indexFour].name = "OPEN"
                        team.gameList[gameIndex].SegmentFiveArray[indexFive].name = "OPEN"
                        team.gameList[gameIndex].SegmentSixArray[indexSix].name = "OPEN"
                    } else if team.playerList[x].availabilityArray[gameIndex] == 0 {
                        team.gameList[gameIndex].SegmentOneArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentTwoArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentThreeArray.append(team.playerList[x].copy() as! Player)
                    } else if team.playerList[x].availabilityArray[gameIndex] == 2 {
                        var indexFour: Int = NameTwoD[3].index(of: team.playerList[x].name)!
                        var indexFive: Int = NameTwoD[4].index(of: team.playerList[x].name)!
                        var indexSix: Int = NameTwoD[5].index(of: team.playerList[x].name)!
                        team.gameList[gameIndex].SegmentFourArray[indexFour].name = "OPEN"
                        team.gameList[gameIndex].SegmentFiveArray[indexFive].name = "OPEN"
                        team.gameList[gameIndex].SegmentSixArray[indexSix].name = "OPEN"
                        team.gameList[gameIndex].SegmentOneArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentTwoArray.append(team.playerList[x].copy() as! Player)
                        team.gameList[gameIndex].SegmentThreeArray.append(team.playerList[x].copy() as! Player)
                    }
                }
            }
        }
    }
    
    func saveGame() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 23", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
    }
}
