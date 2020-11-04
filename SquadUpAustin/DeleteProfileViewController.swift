//
//  DeleteProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/22/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class DeleteProfileViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confirmPasswordTextField.placeholder = "Confirm with Password"
    }
    
    @IBAction func cancelDeleteButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
