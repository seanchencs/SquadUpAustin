//
//  CreateGameViewController.swift
//  SquadUpAustin
//
//  Created by Reagan Lasswell on 10/21/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {
    
    var delegate: UIViewController!

    @IBOutlet weak var chooseADateField: UITextField!
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        datePicker.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed))
        toolbar.setItems([doneButton], animated: true)
        chooseADateField.inputAccessoryView = toolbar
        chooseADateField.inputView = datePicker
    }
    
    @objc func datePickerDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        chooseADateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}
