//
//  ForgotPasswordViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 11/4/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var enterEmailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        enterEmailTextField.placeholder = "youremail@example.com"
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        if (!enterEmailTextField.text!.isEmpty) {
            let auth = Auth.auth();
            var emailAddress = enterEmailTextField.text!

            auth.sendPasswordReset(withEmail: emailAddress) { error in
                if let err = error {
                    //error could not send email
                    //make sure they enter a password when trying to delete account.
                    let controller = UIAlertController(title: "Bad Email",
                                                       message: "Please enter a valid email to an account.",
                                                       preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(title: "OK",
                                                       style: .default,
                                                       handler: nil))
                    self.present(controller, animated: true, completion: nil)
                }
                else {
                    //sent email
                    let controller = UIAlertController(title: "Email sent",
                                                       message: "Please wait a few moments for the email to reach you.",
                                                       preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(title: "OK",
                                                       style: .default,
                                                       handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    
                }
            }
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
