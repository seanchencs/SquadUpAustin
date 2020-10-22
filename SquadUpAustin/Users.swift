//
//  Users.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase

struct User {

    var username: String
    var favoriteSport: String
    var hometown: String
    var major: String
    var profilePicture: String
    var userUid: String
  

    var dictionary: [String: Any] {
        return [
            "username": username,
            "favoriteSport": favoriteSport,
            "hometown": hometown,
            "major": major,
            "profilePicture": profilePicture,
            "userUid": userUid,
        ]
    }
}
