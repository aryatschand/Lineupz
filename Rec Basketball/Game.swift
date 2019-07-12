//
//  Game.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/18/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import Foundation

class Game: Codable {
    var Date: String = ""
    var Day: String = ""
    var Time: String = ""
    var Venue: String = ""
    var Opponent: String = ""
    var FormattedDate: Date!
    var GameEdit: String = ""
    var inThePast: Bool = false
    var delete: Bool = false
    var playerList = [Player]()
    var attendancePlayerList = [Player]()
    var playerLoaded: Bool = false
    var sortedRatingArray = [Player]()
    var switchArray = [Player]()
    var playerListLoaded: Bool = false
    var SegmentOneArray = [Player]()
    var SegmentTwoArray = [Player]()
    var SegmentThreeArray = [Player]()
    var SegmentFourArray = [Player]()
    var SegmentFiveArray = [Player]()
    var SegmentSixArray = [Player]()
    var introGiven: Bool = false
    var lineupIncomplete: Bool = true
}
