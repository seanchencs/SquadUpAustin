//
//  RegisterViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/20/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth

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
