//
//  Game.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

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
    
    func getTitle() -> String {
        return "\(gameOwner)'s \(sport) Game"
    }
    
    func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: time)!
    }
    
    func getLocation() -> CLLocation {
        switch location {
        case "Gregory Gym":
            return CLLocation(latitude: 30.284240, longitude: -97.736832)
        case "Recreational Sports Center":
            return CLLocation(latitude: 30.281460, longitude: -97.732853)
        case "Wright-Whitaker Sports Complex":
            return CLLocation(latitude: 30.314945, longitude: -97.726627)
        default:
            print("Location not found")
            return CLLocation(latitude: 0, longitude: 0)
        }
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
