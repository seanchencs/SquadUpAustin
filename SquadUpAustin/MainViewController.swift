//
//  ViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/16/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var fetchedGames: [NSManagedObject]!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //fetchedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Test" //createMessage(game: fetchedGames[row])
        return cell
    }
    
    func createMessage(game: NSManagedObject) -> String {
        let message = "test"
        return message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        } else if segue.identifier == "ProfileIdentifier",
            let nextVC = segue.destination as? DisplayProfileViewController
            {
                nextVC.delegate = self
        }
    }
}

