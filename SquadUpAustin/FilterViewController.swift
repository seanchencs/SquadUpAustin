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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0...sortSegmentedControl.numberOfSegments-1 {
            if sortSegmentedControl.titleForSegment(at: i) == delegateVC!.sortBy {
                sortSegmentedControl.selectedSegmentIndex = i
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegateVC?.viewWillAppear(false)
    }
    
    @IBAction func sortChanged(_ sender: Any) {
        delegateVC?.sortBy = sortSegmentedControl.titleForSegment(at: sortSegmentedControl.selectedSegmentIndex)!
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
