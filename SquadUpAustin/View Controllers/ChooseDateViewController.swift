//
//  ChooseDateViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 11/4/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class ChooseDateViewController: UIViewController {
    
    var delegateVC: CreateGameViewController?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        delegateVC!.createdGame.time = formatter.string(from: datePicker.date)
        delegateVC!.chooseATimeButton.setTitle(delegateVC!.createdGame.time, for: .normal)
        dismiss(animated: true, completion: nil)
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
