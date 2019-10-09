//
//  Team.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/14/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import Foundation

class Team: Codable {
    var name : String = ""
    var gender: Int = 0
    var grade: String = ""
    var teamNameNumber: Int = 0
    var teamGradeNumber: Int = 0
    var playerList = [Player]()
    var gameList = [Game]()
    var gamesPulled: Bool = false
    var teamsPulled: Bool = false
    var numberOfGames: Int = 0
    var arrayList: [[String]] = []
    var delete: Bool = false
    var addedPlayerList: [Int] = []
    var deletedPlayerList: [Int] = []
    var coachName: String = ""
}
