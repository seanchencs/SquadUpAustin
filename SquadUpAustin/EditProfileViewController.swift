//
//  EditProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editProfileImage: UIImageView!
    
    @IBOutlet weak var editUsernameTextField: UITextField!
    @IBOutlet weak var editMajorTextField: UITextField!
    @IBOutlet weak var editHometownTextField: UITextField!
    @IBOutlet weak var editFavSportTextField: UITextField!
    @IBOutlet weak var editPasswordTextField: UITextField!
    
    let currentUser = Auth.auth().currentUser!
    let collectionOfUsers = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleProfilePicture()
        textFieldSetup()
    }
    
    //Setup the circular profile picture.
    func circleProfilePicture() {
        editProfileImage?.layer.cornerRadius = (editProfileImage?.frame.size.width ?? 0.0) / 2
        editProfileImage?.clipsToBounds = true
        editProfileImage?.layer.borderWidth = 4.0
        editProfileImage?.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func deleteAccount(_ sender: Any) {
    }
    
    @IBAction func editProfileCancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldSetup() {
        
        let curUser = collectionOfUsers.document(currentUser.uid)
        
        curUser.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let userData = document.data()!
                
                self.editUsernameTextField.placeholder = self.currentUser.displayName
                self.editMajorTextField.placeholder = (userData["major"] as! String)
                self.editHometownTextField.placeholder = (userData["hometown"] as! String)
                self.editFavSportTextField.placeholder = (userData["favoriteSport"] as! String)
                self.editPasswordTextField.placeholder = "enter new password"
            } else {
                print("User does not exist")
            }
        }
    }
    
    @IBAction func editProfileSaveButton(_ sender: Any) {
        var newUsername: String
        var newFavoriteSport: String
        var newHometown: String
        var newMajor: String
        
        var newPassword: String
        
        newUsername = (!(editUsernameTextField.text!.isEmpty) ? editUsernameTextField.text : editUsernameTextField.placeholder)!
        
        newFavoriteSport = (!(editFavSportTextField.text!.isEmpty) ? editFavSportTextField.text : editFavSportTextField.placeholder)!
        
        newHometown = (!(editHometownTextField.text!.isEmpty) ? editHometownTextField.text : editHometownTextField.placeholder)!
        
        newMajor = (!(editMajorTextField.text!.isEmpty) ? editMajorTextField.text : editMajorTextField.placeholder)!
        
        let curUser = collectionOfUsers.document(currentUser.uid)
            curUser.updateData([
            "favoriteSport": newFavoriteSport,
            "hometown": newHometown,
            "major": newMajor
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.textFieldSetup()
            }
        }
    }
    
}
