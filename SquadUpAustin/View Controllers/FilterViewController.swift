//
//  FilterViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 11/2/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var delegateVC : MainViewController?
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var basketballSwitch: UISwitch!
    @IBOutlet weak var soccerSwitch: UISwitch!
    @IBOutlet weak var tennisSwitch: UISwitch!
    @IBOutlet weak var ultimateFrisbeeSwitch: UISwitch!
    @IBOutlet weak var volleyballSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set values
        for i in 0...sortSegmentedControl.numberOfSegments-1 {
            if sortSegmentedControl.titleForSegment(at: i) == delegateVC!.sortBy {
                sortSegmentedControl.selectedSegmentIndex = i
            }
        }
        
        basketballSwitch.isOn = !(delegateVC?.excludedSports.contains("Basketball") ?? false)
        soccerSwitch.isOn = !(delegateVC?.excludedSports.contains("Soccer") ?? false)
        tennisSwitch.isOn = !(delegateVC?.excludedSports.contains("Tennis") ?? false)
        ultimateFrisbeeSwitch.isOn = !(delegateVC?.excludedSports.contains("Ultimate Frisbee") ?? false)
        volleyballSwitch.isOn = !(delegateVC?.excludedSports.contains("Volleyball") ?? false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegateVC?.viewWillAppear(false)
    }
    
    @IBAction func sortChanged(_ sender: Any) {
        delegateVC?.sortBy = sortSegmentedControl.titleForSegment(at: sortSegmentedControl.selectedSegmentIndex)!
    }
    
    @IBAction func basketballChanged(_ sender: Any) {
        if basketballSwitch.isOn {
            delegateVC?.excludedSports = (delegateVC?.excludedSports.filter({ $0 != "Basketball" }))!
        } else {
            delegateVC?.excludedSports.append("Basketball")
        }
    }
    
    @IBAction func soccerChanged(_ sender: Any) {
        if soccerSwitch.isOn {
            delegateVC?.excludedSports = (delegateVC?.excludedSports.filter({ $0 != "Soccer" }))!
        } else {
            delegateVC?.excludedSports.append("Soccer")
        }
    }
    
    @IBAction func tennisChanged(_ sender: Any) {
        if tennisSwitch.isOn {
            delegateVC?.excludedSports = (delegateVC?.excludedSports.filter({ $0 != "Tennis" }))!
        } else {
            delegateVC?.excludedSports.append("Tennis")
        }
    }
    
    @IBAction func ultimateFrisbeeChanged(_ sender: Any) {
        if ultimateFrisbeeSwitch.isOn {
            delegateVC?.excludedSports = (delegateVC?.excludedSports.filter({ $0 != "Ultimate Frisbee" }))!
        } else {
            delegateVC?.excludedSports.append("Ultimate Frisbee")
        }
    }
    
    @IBAction func volleyballChanged(_ sender: Any) {
        if volleyballSwitch.isOn {
            delegateVC?.excludedSports = (delegateVC?.excludedSports.filter({ $0 != "Volleyball" }))!
        } else {
            delegateVC?.excludedSports.append("Volleyball")
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
