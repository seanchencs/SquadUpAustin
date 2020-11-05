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
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
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
        
        usernameLabel.text = currentUser.displayName
        
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
        
        var newPassword: String!
        
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
                //print("Error updating document: \(err)")
                //send a alert to ensure user they succesfully updated their information.
                let controller = UIAlertController(title: "Profile Not Updated!",
                                                   message: "Your information has Not been succesfully updated.",
                                                   preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "OK",
                                                   style: .default,
                                                   handler: nil))
                self.present(controller, animated: true, completion: nil)
            } else {
                //print("Document successfully updated")
                
                //update placeholder text to new inputs
                self.editUsernameTextField.placeholder = newUsername
                self.editMajorTextField.placeholder = newMajor
                self.editHometownTextField.placeholder = newHometown
                self.editFavSportTextField.placeholder = newFavoriteSport
                
                //update display Name
                let changeRequest = self.currentUser.createProfileChangeRequest()
                changeRequest.displayName = newUsername
                changeRequest.commitChanges(completion: nil)
                
                //update user name label
                self.usernameLabel.text = newUsername
                
                //update users password
                if(!(self.editPasswordTextField.text!.isEmpty)) {
                    newPassword = self.editPasswordTextField.text!
                    
                    //make user confirm old password to update it.
                    let controller = UIAlertController(title: "Update Password",
                                                       message: "Confirm current password to update it.",
                                                       preferredStyle: .alert)

                    controller.addAction(UIAlertAction(title: "Cancel",
                                                       style: .cancel,
                                                       handler: nil))

                    controller.addTextField(configurationHandler: {
                        (textField:UITextField!) in textField.placeholder = "Old Password"
                    })

                    controller.addAction(UIAlertAction(title: "Update",
                                                       style: .default,
                                                       handler: { [self]
                                                        (paramAction:UIAlertAction!) in
                                                        if let textFieldArray = controller.textFields {
                                                            let textFields = textFieldArray as [UITextField]
                                                            let enteredText = textFields[0].text
                                                            // do something to show it worked

                                                            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: enteredText!)
                                                            currentUser.reauthenticate(with: credential) { (result, error) in
                                                               if let err = error {
                                                                  //..read error message
                                                                //send a alert to ensure user they succesfully updated their information.
                                                                let controller = UIAlertController(title: "Password Not Updated",
                                                                                                   message: "Everything but your password was updated becuase password was incorrect.",
                                                                                                   preferredStyle: .alert)

                                                                controller.addAction(UIAlertAction(title: "OK",
                                                                                                   style: .default,
                                                                                                   handler: nil))
                                                                self.present(controller, animated: true, completion: nil)
                                                               } else {
                                                                    //.. go on
                                                                    currentUser.updatePassword(to: newPassword) { (error) in
                                                                        if let err = error {
                                                                            print("error updating password")
                                                                            let controller = UIAlertController(title: "Password update fail",
                                                                                                               message: "Oops something happened when trying to save your new password.",
                                                                                                               preferredStyle: .alert)

                                                                            controller.addAction(UIAlertAction(title: "OK",
                                                                                                               style: .default,
                                                                                                               handler: nil))
                                                                            self.present(controller, animated: true, completion: nil)
                                                                        }
                                                                        else {
                                                                            let controller = UIAlertController(title: "Password or Information Updated!",
                                                                                                               message: "Succesfully updated both your password or info.",
                                                                                                               preferredStyle: .alert)

                                                                            controller.addAction(UIAlertAction(title: "OK",
                                                                                                               style: .default,
                                                                                                               handler: nil))
                                                                            self.present(controller, animated: true, completion: nil)
                                                                        }

                                                                }
                                                               }
                                                            }
                                                            
                                                        }
                                                       }))
                                                            
                     self.present(controller, animated: true, completion: nil)
                }
                else {
                    //send a alert to ensure user they succesfully updated their information but not their password.
                    let controller = UIAlertController(title: "Profile Updated!",
                                                       message: "Your information has been succesfully updated.",
                                                       preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(title: "OK",
                                                       style: .default,
                                                       handler: nil))
                    
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }

    }
    
    // code to enable tapping on the background to remove software keyboard
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
    
}
