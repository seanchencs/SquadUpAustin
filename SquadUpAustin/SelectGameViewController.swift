//
//  SelectGameViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SelectGameViewController: UIViewController {
    
    var delegate: MainViewController!
    var selectedGame: Game!

    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var rsvpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up values based on selected game
        ownerLabel.text = "\(selectedGame.gameOwner)'s \(selectedGame.sport) Game"
        sportLabel.text = selectedGame.sport
        locationLabel.text = selectedGame.location
        timeLabel.text = selectedGame.time
        participantsLabel.text = selectedGame.players.joined(separator: ", ")
        
        //set up RSVP/Cancel/Delete Button
        var isOwner = false
        var RSVPed = false
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser?.displayName == self.selectedGame.gameOwner {
                isOwner = true
            }
            if self.selectedGame.players.firstIndex(of: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!) != nil {
                RSVPed = true
            }
        }
        checkRSVP(isCreator: isOwner, isRSVP: RSVPed)
    }
    
    @IBAction func rsvpButtonPressed(_ sender: Any) {
        if rsvpButton.titleLabel?.text == "RSVP" {
            let otherVC = delegate as! JoinGame
            otherVC.rsvp(g: selectedGame)
            
            //ADD UPDATE TO PARTICIPANTS
            
            checkRSVP(isCreator: false, isRSVP: true)
        } else if rsvpButton.titleLabel?.text == "Cancel RSVP" {
            let otherVC = delegate as! JoinGame
            otherVC.leaveGame(g: selectedGame)
            
            //ADD UPDATE TO PARTICIPANTS
            
            checkRSVP(isCreator: false, isRSVP: false)
        }
        
    }
    
    func checkRSVP(isCreator: Bool, isRSVP: Bool) {
        rsvpButton.setTitle(!isCreator ? (isRSVP ? "Cancel RSVP" : "RSVP"): "Delete", for: .normal)
        rsvpButton.setTitleColor(!isCreator ? (isRSVP ? UIColor.systemRed : UIColor.systemGreen): UIColor.systemRed, for: .normal)
    }

}
