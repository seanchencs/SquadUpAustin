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
        // Do any additional setup after loading the view.
        ownerLabel.text = "\(selectedGame.gameOwner)'s \(selectedGame.sport) Game"
        sportLabel.text = selectedGame.sport
        locationLabel.text = selectedGame.location
        timeLabel.text = selectedGame.time
        participantsLabel.text = selectedGame.players.joined(separator: ", ")
        
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
        rsvpButton.setTitle(!isOwner ? (RSVPed ? "Cancel RSVP" : "RSVP"): "Delete", for: .normal)
        rsvpButton.setTitleColor(!isOwner ? (RSVPed ? UIColor.systemRed : UIColor.systemGreen): UIColor.systemRed, for: .normal)
    }
    
    @IBAction func rsvpButtonPressed(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
