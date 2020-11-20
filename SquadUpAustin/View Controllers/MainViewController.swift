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

/// add or remove current user from a game
protocol JoinGame {
    func rsvp(g: Game) -> Game
    func leaveGame(g: Game) -> Game
}

class MainViewController: UIViewController, JoinGame, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    let db = Firestore.firestore()
    var fetchedGames = [Game]() // All fetched games
    var filteredGames = [Game]() // Filtered subset of fetchedGames
    
    //Filter Options - modified by FilterViewController
    var sortBy = "Time"
    var excludedSports = [String]()
    
    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath) as! GameTableViewCell
        let row = indexPath.row
        let game = filteredGames[row]
        cell.gameNameLabel.text = "\(game.gameOwner)'s \(game.sport) Game"
        cell.timeLabel.text = game.time
        cell.locationLabel.text = game.location
        cell.playerCountLabel.text = String(game.players.count)
        cell.sportImage.image = UIImage(named: game.sport)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rsvp = UIContextualAction(style: .normal, title: "RSVP") { (action, view, completion) in
            if Auth.auth().currentUser != nil {
                self.rsvpGame(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &self.filteredGames[indexPath.row])
                tableView.reloadData()
            }
            completion(true)
        }
        rsvp.backgroundColor = UIColor.systemGreen
     
        let cancel = UIContextualAction(style: .destructive, title: "Cancel") { (action, view, completion) in
            if Auth.auth().currentUser != nil {
                self.unRSVP(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &self.filteredGames[indexPath.row])
                tableView.reloadData()
            }
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.deleteGame(game: self.filteredGames[indexPath.row])
            self.fetchGames()
            completion(true)
        }
        
        //figure out what options to show
        var isOwner = false
        var RSVPed = false
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser?.displayName == self.filteredGames[indexPath.row].gameOwner {
                isOwner = true
            }
            if self.filteredGames[indexPath.row].players.firstIndex(of: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!) != nil {
                RSVPed = true
            }
        }
        
        let config = isOwner ? UISwipeActionsConfiguration(actions: [delete]) : (RSVPed ? UISwipeActionsConfiguration(actions: [cancel]) : UISwipeActionsConfiguration(actions: [rsvp]))
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    @objc private func refreshTable(_ sender: Any) {
        fetchGames()
    }
    
    //MARK: Firestore
    /// Store a given game in Firestore
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
        db.collection("games").document(ref!.documentID).collection("chat").addDocument(data: ["from": "System", "message": "Test"])
    }
    
    /// Delete a given game from Firestore
    func deleteGame(game:Game) {
        db.collection("games").document(game.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    /// RSVPs given user for given game
    func rsvpGame(displayName: String, game: inout Game) {
        game.players.append(displayName)
        let gameRef = db.collection("games").document(game.id!)
        gameRef.setData(game.getDictionary())
    }
    
    /// UnRSVP given user for  given game
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
    
    // Clean refresh and refilter of games from Firestore
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
                self.filterGames()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //MARK: Filter and Sort
    /// Apply filter and sort to filteredGames
    func filterGames() {
        filteredGames = fetchedGames
        //filter
        filteredGames = filteredGames.filter({ !excludedSports.contains($0.sport) })
        //sort
        switch sortBy {
        case "Time":
            filteredGames.sort(by: { $0.getDate() < $1.getDate()})
        case "Sport":
            filteredGames.sort(by: { $0.sport > $1.sport})
        case "Participants":
            filteredGames.sort(by: { $0.players.count > $1.players.count})
        case "Location":
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let userLocation = appDelegate.locationManager!.location!
            filteredGames.sort(by: {userLocation.distance(from: $0.getLocation()) > userLocation.distance(from: $1.getLocation())} )
        default:
            break
        }
    }
    
    //MARK: Join Game Protocol
    func rsvp(g: Game) -> Game {
        var givenGame = g
        if Auth.auth().currentUser != nil {
            self.rsvpGame(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &givenGame)
            tableView.reloadData()
        }
        return givenGame
    }
    
    func leaveGame(g: Game) -> Game{
        var givenGame = g
        if Auth.auth().currentUser != nil {
            self.unRSVP(displayName: ((Auth.auth().currentUser?.displayName) ?? Auth.auth().currentUser?.email?.components(separatedBy: "@")[0])!, game: &givenGame)
            tableView.reloadData()
        }
        return givenGame
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //pull refresh
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.systemOrange
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Games...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemOrange])
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
                var selectedGame = filteredGames[tableView.indexPathForSelectedRow!.row]
                //updateGame(game: &selectedGame)
                nextVC.selectedGame = selectedGame
        } else if segue.identifier == "ProfileIdentifier",
            let nextVC = segue.destination as? DisplayProfileViewController
            {
                nextVC.delegate = self
        } else if segue.identifier == "filterSegue", let nextVC = segue.destination as? FilterViewController {
            nextVC.delegateVC = self
        }
    }
}

