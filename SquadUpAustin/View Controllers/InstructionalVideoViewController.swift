//
//  InstructionalVideoViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 11/23/20.
//  Copyright © 2020 Group 4. All rights reserved.
//
import youtube_ios_player_helper
import UIKit

class InstructionalVideoViewController: UIViewController {
    
    var delegate: UIViewController!
    var sport: String!
    
    @IBOutlet var player:YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        identifySport()
        // Do any additional setup after loading the view.
    }
    
    func identifySport() {
        if sport! == "Basketball" {
            player.load(withVideoId: "oyjYgmsM00Q")
        } else if sport! == "Tennis" {
            player.load(withVideoId: "jrhM3k84YJU")
        } else if sport! == "Volleyball" {
            player.load(withVideoId: "9YvP2-YbIFs")
        } else if sport! == "Soccer" {
            player.load(withVideoId: "qknP-E-vPQ4")
        } else if sport! == "Ultimate Frisbee" {
            player.load(withVideoId: "UnNUEvs2Ev0")
        }
    }


}
