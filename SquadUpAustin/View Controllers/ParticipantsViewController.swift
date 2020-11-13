//
//  ParticipantsViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 11/13/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: UIViewController!
    var game: Game!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantIdentifier", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = game.players[row]
        
        return cell
    }
    
}
