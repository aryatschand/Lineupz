//
//  Player.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/6/18.
//  Copyright © 2018 Arya Tschand. All rights reserved.
//

import Foundation

class Player: Codable {
    var name : String = ""
    var offensivePosition : Int = 1
    var defensivePosition: Int = 1
    var rating: Int = 10
    var delete: Bool = false
    var availability: Int = 0
    var newPlayer: Bool = true
    var email: String = ""
    var phoneNumber: String = ""
    var displayNumber: String = ""
    var availabilityArray: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Player()
        copy.name = self.name
        copy.offensivePosition = self.offensivePosition
        copy.defensivePosition = self.defensivePosition
        copy.rating = self.rating
        copy.delete = self.delete
        copy.availability = self.availability
        copy.newPlayer = self.newPlayer
        copy.email = self.email
        copy.phoneNumber = self.phoneNumber
        copy.displayNumber = self.displayNumber
        copy.availabilityArray = self.availabilityArray
        return copy
    }
}
