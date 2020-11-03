//
//  DisplayProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DisplayProfileViewController: UIViewController {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var favoriteSportLabel: UILabel!
    
    
    var delegate: UIViewController!
    let settingsIdentifier = "EditSettingsIdentifier"
    
    let currentUser = Auth.auth().currentUser!
    let collectionOfUsers = Firestore.firestore().collection("users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleProfilePicture()
        setupSettingsButton()
        populateProfileSettings()
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
        let curUser = collectionOfUsers.document(currentUser.uid)

        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let userData = document.data()!
                
                //populate the user information.
                print("hometown: \(userData["hometown"] ?? "error")")
                
//                self.usernameLabel.text = (userData["username"] as! String)
                self.usernameLabel.text = self.currentUser.displayName
                self.majorLabel.text = (userData["major"] as! String)
                self.hometownLabel.text = (userData["hometown"] as! String)
                self.favoriteSportLabel.text = (userData["favoriteSport"] as! String)
            } else {
                print("User does not exist")
            }
        }
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        
    }
}


