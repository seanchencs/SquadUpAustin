//
//  RegisterViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/20/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        //confirm passwords match
        if passwordField.text! == confirmPasswordField.text!{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {user, error in
                if error == nil {
                    //successful registration
                    
                    //Add user to database and default their profile settings
                    let collection = Firestore.firestore().collection("users")
                    
                    let user = User(
                        username: self.emailField.text!,
                        favoriteSport: "noFavoriteSport :(",
                        hometown: "noHometown :(",
                        major: "noMajor :(",
                        profilePicture: "noProfilePicture",
                        userUid: Auth.auth().currentUser!.uid)
                    collection.document(Auth.auth().currentUser!.uid).setData(user.dictionary)
                    
                    
                    //Send to main page.
                    self.performSegue(withIdentifier: "RegisterToMainSegue", sender: nil)
                } else {
                    //unsuccessful registration
                    let alert = UIAlertController(title: "Error", message: "Could not register user", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        segue.destination.modalPresentationStyle = .fullScreen
    }
    

}
