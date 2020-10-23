//
//  SelectGameViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class SelectGameViewController: UIViewController {
    
    var delegate: MainViewController!
    var index = Int()

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let selectedGame = delegate.fetchedGames[index]
        sportLabel.text = selectedGame.sport
        locationLabel.text = selectedGame.location
        timeLabel.text = selectedGame.time
        participantsLabel.text = ""
        for participant in selectedGame.players {
            participantsLabel.text?.append(participant)
        }
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
