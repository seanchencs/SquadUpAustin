//
//  MainViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/16/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedGames = [Game]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedGames.count //fetchedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = createMessage(game: fetchedGames[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fetchedGames.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func createMessage(game: Game) -> String {
        return "\(game.sport) @ \(game.location) at \(game.time)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
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

