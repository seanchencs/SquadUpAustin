//
//  Game.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase

struct Game {

    var sport: String
    var location: String
    var time: String
    var gameOwner: String
    var date: String
    var players: [String]
    var numplayers: Int
    var equipmentCheck: Bool

    var dictionary: NSMutableDictionary {
        return [
            "sport": sport,
            "location": location,
            "time": time,
            "userID1": gameOwner,
            "date": date,
            2: numplayers,
            ["user1", "user2"]: players,
            false: equipmentCheck
        ]
    }
}
