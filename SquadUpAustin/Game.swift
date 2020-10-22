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
    var gameID: String

    var dictionary: [String: Any] {
        return [
            "sport": sport,
            "location": location,
            "time": time,
            "gameID": gameID
        ]
    }
}
