//
//  ViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        gameNameLabel.text = textField.text
    }
    
    //MARK: Actions
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        gameNameLabel.text = "Default Text"
    }
}

