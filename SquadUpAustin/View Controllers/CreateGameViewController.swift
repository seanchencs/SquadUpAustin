//
//  CreateGameViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateGameViewController: UIViewController {
    
    var createdGame = Game(id: "null", sport: "null", location: "null", time: "null", gameOwner: "null", players: [], equipmentCheck: true)
    var alertSport: String!
    
    var delegate: UIViewController!
    @IBOutlet weak var chooseATimeButton: UIButton!
    @IBOutlet weak var chooseALocationButton: UIButton!
    @IBOutlet weak var chooseASportButton: UIButton!
    @IBOutlet weak var equipmentProvided: UISegmentedControl!
    
    @IBAction func instructionalVideoPressed(_ sender: Any) {
        let controller = UIAlertController(title: "Sport",
                                           message: "Choose a sport:",
                                           preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Basketball",
                                           style:.default,
                                           handler: showVideo(alert:)))
        controller.addAction(UIAlertAction(title: "Soccer",
                                           style:.default,
                                           handler: showVideo(alert:)))
        controller.addAction(UIAlertAction(title: "Tennis",
                                           style:.default,
                                           handler: showVideo(alert:)))
        controller.addAction(UIAlertAction(title: "Ultimate Frisbee",
                                           style:.default,
                                           handler: showVideo(alert:)))
        controller.addAction(UIAlertAction(title: "Volleyball",
                                           style:.default,
                                           handler: showVideo(alert:)))
        controller.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(controller, animated: true, completion: nil)
        
    }
    
    func showVideo(alert:UIAlertAction!) {
        alertSport = alert.title
        performSegue(withIdentifier: "videoSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fill in current user
        if Auth.auth().currentUser != nil {
            createdGame.gameOwner = (Auth.auth().currentUser?.displayName) ?? "null"
            createdGame.players.append(Auth.auth().currentUser?.displayName ?? "null")
        }
    }

    @IBAction func chooseLocationPressed(_ sender: Any) {
        let controller = UIAlertController(title: "Location",
                                           message: "Choose a location:",
                                           preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Gregory Gym",
                                           style:.default,
                                           handler: addLocation(alert:)))
        controller.addAction(UIAlertAction(title: "Recreational Sports Center",
                                           style:.default,
                                           handler: addLocation(alert:)))
        controller.addAction(UIAlertAction(title: "Wright-Whitaker Sports Complex",
                                           style:.default,
                                           handler: addLocation(alert:)))
        present(controller, animated: true, completion: nil)
    }
    
    func addLocation(alert:UIAlertAction!) {
        createdGame.location = alert.title!
        chooseALocationButton.setTitle(createdGame.location, for: .normal)
    }
    
    @IBAction func chooseASportPressed(_ sender: Any) {
        let controller = UIAlertController(title: "Sport",
                                           message: "Choose a sport:",
                                           preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Basketball",
                                           style:.default,
                                           handler: addSport(alert:)))
        controller.addAction(UIAlertAction(title: "Soccer",
                                           style:.default,
                                           handler: addSport(alert:)))
        controller.addAction(UIAlertAction(title: "Tennis",
                                           style:.default,
                                           handler: addSport(alert:)))
        controller.addAction(UIAlertAction(title: "Ultimate Frisbee",
                                           style:.default,
                                           handler: addSport(alert:)))
        controller.addAction(UIAlertAction(title: "Volleyball",
                                           style:.default,
                                           handler: addSport(alert:)))
        present(controller, animated: true, completion: nil)

    }
    
    func addSport(alert:UIAlertAction!) {
        createdGame.sport = alert.title!
        chooseASportButton.setTitle(createdGame.sport, for: .normal)
    }
    
    @IBAction func equipmentProvidedChanged(_ sender: Any) {
        if equipmentProvided.selectedSegmentIndex == 0{
            createdGame.equipmentCheck = true
        } else {
            createdGame.equipmentCheck = false
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        if checkEmpty(){
            let delegateVC = delegate as! MainViewController
            delegateVC.storeGame(game: &createdGame) //Firebase store
            //delegateVC.fetchedGames.append(createdGame)
            delegateVC.tableView.reloadData()
            delegateVC.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkEmpty() -> Bool{
        if (createdGame.time == "null" ||
                createdGame.location == "null" ||
                createdGame.sport == "null") {
            let controller = UIAlertController(title: "You missed something!",
            message: "Please fill out all fields",
            preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseDateSegue",
           let destinationVC = segue.destination as? ChooseDateViewController {
            destinationVC.delegateVC = self
        } else if segue.identifier == "videoSegue",
                  let destinationVC = segue.destination as? InstructionalVideoViewController
        {
            destinationVC.delegate = self
            destinationVC.sport = alertSport
        }
    }
}
