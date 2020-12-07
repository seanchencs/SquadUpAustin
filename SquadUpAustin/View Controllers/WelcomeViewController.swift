//
//  WelcomeViewController.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 10/20/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class WelcomeViewController: UIViewController {
    
    let collectionOfUsers = Firestore.firestore().collection("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let docRef = collectionOfUsers.document(Auth.auth().currentUser!.uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: nil)
                } else {
                    print("Document does not exist")
                }
            }

        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alreadyLoggedInSegue" {
            segue.destination.modalPresentationStyle = .fullScreen
        }
    }
    

}
