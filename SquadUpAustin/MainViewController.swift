//
//  MainViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/16/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var fetchedGames = [Game]()
    
    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath) as! GameTableViewCell
        let row = indexPath.row
        let game = fetchedGames[row]
        cell.gameNameLabel.text = game.gameOwner
        cell.timeLabel.text = game.time
        cell.locationLabel.text = game.location
        cell.sportLabel.text = game.sport
        cell.playerCountLabel.text = String(game.players.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rsvp = UIContextualAction(style: .normal, title: "RSVP") { (action, view, completion) in
            if Auth.auth().currentUser != nil {
                self.rsvpGame(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &self.fetchedGames[indexPath.row])
                tableView.reloadData()
            }
            completion(true)
        }
        rsvp.backgroundColor = UIColor.systemGreen
     
        let cancel = UIContextualAction(style: .destructive, title: "Cancel") { (action, view, completion) in
            if Auth.auth().currentUser != nil {
                self.unRSVP(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &self.fetchedGames[indexPath.row])
                tableView.reloadData()
            }
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.deleteGame(game: self.fetchedGames[indexPath.row])
            completion(true)
        }
        
        //figure out what options to show
        var isOwner = false
        var RSVPed = false
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser?.displayName == self.fetchedGames[indexPath.row].gameOwner {
                isOwner = true
            }
            if self.fetchedGames[indexPath.row].players.firstIndex(of: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!) != nil {
                RSVPed = true
            }
        }
        
        let config = isOwner ? UISwipeActionsConfiguration(actions: [delete]) : (RSVPed ? UISwipeActionsConfiguration(actions: [cancel]) : UISwipeActionsConfiguration(actions: [rsvp]))
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    //MARK: Firestore
    func storeGame(game: inout Game) {
        var ref: DocumentReference? = nil
        ref = db.collection("games").addDocument(data: game.getDictionary()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        game.id = ref!.documentID
    }
    
    func deleteGame(game:Game) {
        db.collection("games").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.fetchedGames.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if document.documentID == game.id {
                        self.db.collection("games").document(document.documentID).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    } else {
                        let newGame = Game(id: document.documentID, sport: data["sport"] as! String, location: data["location"] as! String, time: data["time"] as! String, gameOwner: data["gameOwner"] as! String, players: (data["players"] as! String).components(separatedBy: ","), equipmentCheck: data["equipment"] as! Bool)
                        self.fetchedGames.append(newGame)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    /// RSVPs  user for game
    func rsvpGame(displayName: String, game: inout Game) {
        game.players.append(displayName)
        let gameRef = db.collection("games").document(game.id!)
        gameRef.setData(game.getDictionary())
    }
    
    /// UnRSVP user for game
    func unRSVP(displayName: String, game: inout Game) {
        let index = game.players.firstIndex(of: displayName) ?? -1
        print(game.players)
        if index != -1 {
            print(displayName)
            game.players.remove(at: index)
            let gameRef = db.collection("games").document(game.id!)
            gameRef.setData(game.getDictionary())
        }
    }
    
    //fetches all games from firestore and updates tableView
    func fetchGames() {
        db.collection("games").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.fetchedGames.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let newGame = Game(id: document.documentID, sport: data["sport"] as! String, location: data["location"] as! String, time: data["time"] as! String, gameOwner: data["gameOwner"] as! String, players: (data["players"] as! String).components(separatedBy: ","), equipmentCheck: data["equipment"] as! Bool)
                    self.fetchedGames.append(newGame)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Firebase fetch
        fetchGames()
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createGameSegue",
            let nextVC = segue.destination as? CreateGameViewController
            {
                nextVC.delegate = self
        } else if segue.identifier == "selectGameSegue",
            let nextVC = segue.destination as? SelectGameViewController
            {
                nextVC.delegate = self
                let i = tableView.indexPathForSelectedRow?.row
                nextVC.index = i!
        } else if segue.identifier == "ProfileIdentifier",
            let nextVC = segue.destination as? DisplayProfileViewController
            {
                nextVC.delegate = self
        }
    }
}

