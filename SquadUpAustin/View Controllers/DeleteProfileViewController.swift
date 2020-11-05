//
//  DeleteProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DeleteProfileViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let currentUser = Auth.auth().currentUser!
    let collectionOfUsers = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confirmPasswordTextField.placeholder = "Confirm with Password"
    }
    
    @IBAction func cancelDeleteButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        if(!confirmPasswordTextField.text!.isEmpty) {
            let passwordToConfirm = confirmPasswordTextField.text!
            
            //reauthenticate to delete an account.
            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: passwordToConfirm)
            currentUser.reauthenticate(with: credential) { (result, error) in
               if let err = error {
                  //..read error message
                //send a alert to ensure user they succesfully updated their information.
                let controller = UIAlertController(title: "Could not delete account",
                                                   message: "Sorry your password is incorrect.",
                                                   preferredStyle: .alert)

                controller.addAction(UIAlertAction(title: "OK",
                                                   style: .default,
                                                   handler: nil))
                self.present(controller, animated: true, completion: nil)
               } else {
                    //Have to delete the account from our user database on firestore.
                    self.collectionOfUsers.document(self.currentUser.uid).delete() { err in
                        if let err = err {
                            // An error happened.
                            let controller = UIAlertController(title: "Could not delete account",
                                                               message: "Sorry there was an error on our end. Try again!",
                                                               preferredStyle: .alert)

                            controller.addAction(UIAlertAction(title: "OK",
                                                               style: .default,
                                                               handler: nil))
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            //.. now go on and delete the acccount from firebase
                            self.currentUser.delete { error in
                              if let error = error {
                                // An error happened.
                                let controller = UIAlertController(title: "Could not delete account",
                                                                   message: "Sorry there was an error on our end. Try again!",
                                                                   preferredStyle: .alert)

                                controller.addAction(UIAlertAction(title: "OK",
                                                                   style: .default,
                                                                   handler: nil))
                                self.present(controller, animated: true, completion: nil)
                              } else {
                                // Account deleted.
                                self.performSegue(withIdentifier: "DeleteAccountSegueIdentifier", sender: nil)
                              }
                            }
                        }
                    }
               }
            }
        }
        else {
            //make sure they enter a password when trying to delete account.
            let controller = UIAlertController(title: "Password not entered",
                                               message: "Please enter current password to delete account.",
                                               preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                                               style: .default,
                                               handler: nil))
            self.present(controller, animated: true, completion: nil)
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
    
    // code to enable tapping on the background to remove software keyboard
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        

}
