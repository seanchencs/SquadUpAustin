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
import MessageKit
import EventKit
import EventKitUI

class SelectGameViewController: UIViewController, EKEventEditViewDelegate {
    
    let db = Firestore.firestore()
    var delegate: MainViewController!
    var selectedGame: Game!

    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var addToCalendarButton: UIButton!
    
    @IBOutlet weak var chatField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up values based on selected game
        ownerLabel.text = "\(selectedGame.gameOwner)'s \(selectedGame.sport) Game"
        sportLabel.text = selectedGame.sport
        locationLabel.text = selectedGame.location
        timeLabel.text = selectedGame.time
        participantsLabel.text = selectedGame.players.joined(separator: ", ")
        equipmentLabel.text = selectedGame.equipmentCheck ? "Equipment will be provided" : "Equipment will not be provided"
        
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
    
    func sendMessage(message: String) {
        let date = Date()
        db.collection("games").document(selectedGame.id!).collection("chat").addDocument(data: ["id": Auth.auth().currentUser!.uid, "displayName": Auth.auth().currentUser!.displayName!, "body": message, "date": date])
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        sendMessage(message: self.chatField.text!)
        self.chatField.text = ""
    }
    
    
    @IBAction func rsvpButtonPressed(_ sender: Any) {
        if rsvpButton.titleLabel?.text == "RSVP" {
            let otherVC = delegate!
            let temp = otherVC.rsvp(g: selectedGame)
            participantsLabel.text = temp.players.joined(separator: ", ")
            checkRSVP(isCreator: false, isRSVP: true)
        } else if rsvpButton.titleLabel?.text == "Cancel RSVP" {
            let otherVC = delegate!
            let temp = otherVC.leaveGame(g: selectedGame)
            participantsLabel.text = temp.players.joined(separator: ", ")
            checkRSVP(isCreator: false, isRSVP: false)
        } else if rsvpButton.titleLabel?.text == "Delete" {
            let otherVC = delegate!
            otherVC.deleteGame(g: selectedGame)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    ///update the status of buttons based on rsvp and owner conditions
    func checkRSVP(isCreator: Bool, isRSVP: Bool) {
        rsvpButton.setTitle(!isCreator ? (isRSVP ? "Cancel RSVP" : "RSVP"): "Delete", for: .normal)
        rsvpButton.setTitleColor(!isCreator ? (isRSVP ? UIColor.systemRed : UIColor.systemGreen): UIColor.systemRed, for: .normal)
        addToCalendarButton.isHidden = !isRSVP
    }
    
    @IBAction func addToCalendarPressed(_ sender: Any) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
                if (error != nil) || !granted {
                    return
                }
            }
        case .authorized:
            break
        default:
            return
        }
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = selectedGame.getTitle()
        event.startDate = selectedGame.getDate()
        event.location = selectedGame.location
        eventVC.event = event
        present(eventVC, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "participantSegue",
            let nextVC = segue.destination as? ParticipantsViewController
            {
                nextVC.delegate = self
                nextVC.game = selectedGame
            }
        else if segue.identifier == "chatSegue",
                let nextVC = segue.destination as? ChatViewController
        {
            nextVC.selectedGame = self.selectedGame
        }
    }
}
