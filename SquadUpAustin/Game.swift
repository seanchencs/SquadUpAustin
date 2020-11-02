//
//  Game.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase

struct Game: Equatable{

    var id: String?
    var sport: String
    var location: String
    var time: String
    var gameOwner: String
    var players: [String]
    var equipmentCheck: Bool
    
    func getDictionary() -> [String: Any]{
        let output = [
            "sport": sport,
            "location": location,
            "time": time,
            "gameOwner": gameOwner,
            "players": players.joined(separator: ","),
            "equipment": equipmentCheck
        ] as [String : Any]
        return output
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return (lhs.sport == rhs.sport &&
                    lhs.location == rhs.location &&
                    lhs.time == rhs.time &&
                    lhs.gameOwner == rhs.gameOwner &&
                    lhs.players == rhs.players &&
                    lhs.equipmentCheck == rhs.equipmentCheck)
    }
}
