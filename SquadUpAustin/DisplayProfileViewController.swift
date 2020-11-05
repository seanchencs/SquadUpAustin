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
import FirebaseUI
import Photos
import FirebaseStorage

class DisplayProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
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
        SDImageCache.shared.clearDisk(onCompletion: nil)
        circleProfilePicture()
        setupSettingsButton()
        populateProfileSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateProfileSettings()
    }
    
    //Setup the circular profile picture.
    func circleProfilePicture() {
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 4.0
        profileImage?.layer.borderColor = UIColor.black.cgColor
        
        //populate with image from storage
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoRef = storageRef.child(currentUser.uid)

        profileImage.sd_setImage(with: photoRef)
        
        SDImageCache.shared.clearDisk(onCompletion: nil)
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
    
    @IBAction func LogoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            let controller = UIAlertController(title: "Could not log you out!",
                                               message: "There was an error loggin you out.",
                                               preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                                               style: .default,
                                               handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}


