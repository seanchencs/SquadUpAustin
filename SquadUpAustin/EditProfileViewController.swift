//
//  EditProfileViewController.swift
//  SquadUpAustin
//
//  Created by Manuel Ponce on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editProfileImage: UIImageView!
    
    @IBOutlet weak var editUsernameTextField: UITextField!
    @IBOutlet weak var editMajorTextField: UITextField!
    @IBOutlet weak var editHometownTextField: UITextField!
    @IBOutlet weak var editFavSportTextField: UITextField!
    @IBOutlet weak var editPasswordTextField: UITextField!
    
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
        editUsernameTextField.placeholder = "current username"
        editMajorTextField.placeholder = "current major"
        editHometownTextField.placeholder = "current hometown"
        editFavSportTextField.placeholder = "current sport"
        editPasswordTextField.placeholder = "enter new password"
    }
}
