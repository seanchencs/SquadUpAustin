//
//  DisplayProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import Firebase

class DisplayProfileViewController: UIViewController {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    let settingsIdentifier = "EditSettingsIdentifier"
    
    let currentUser = Auth.auth().currentUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleProfilePicture()
        setupSettingsButton()
        
    }
    
    //Setup the circular profile picture.
    func circleProfilePicture() {
        ProfileImage?.layer.cornerRadius = (ProfileImage?.frame.size.width ?? 0.0) / 2
        ProfileImage?.clipsToBounds = true
        ProfileImage?.layer.borderWidth = 4.0
        ProfileImage?.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupSettingsButton(){
        settingsButton.setImage(UIImage(named: "SettingIcon"), for: .normal)
        settingsButton.setTitle("", for: .normal)
        settingsButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func populateProfileSettings() {
        
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        
    }
}


