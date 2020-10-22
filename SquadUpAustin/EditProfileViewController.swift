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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleProfilePicture()
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
}
