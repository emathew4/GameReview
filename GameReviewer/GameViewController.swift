//
//  GameViewController.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var game: Game?
    var originalFavoriteState: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.delegate = self
        summaryTextView.delegate = self
        
        if let game = game {
            navigationItem.title = game.name
            nameTextField.text = game.name
            photoImageView.image = game.photo
            ratingControl.rating = game.rating
            summaryTextView.text = game.summary
            
            let isFavorite = game.favorite
            if isFavorite {
                favoriteSwitch.setOn(true, animated: false)
            } else {
                favoriteSwitch.setOn(false, animated: false)
            }
            originalFavoriteState = game.favorite
            
        }
        
        //create TextView border
        summaryTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        summaryTextView.layer.borderWidth = 0.5
        summaryTextView.layer.cornerRadius = 5
        
        //create TextView placeholder text
        if summaryTextView.text.isEmpty {
            summaryTextView.text = "Enter summary here"
            summaryTextView.textColor = UIColor.lightGray
        }
        
        updateSaveButtonState()

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard View Adjustments

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if summaryTextView.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isEnabled = false
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if summaryTextView.text.isEmpty {
            summaryTextView.text = "Enter summary here"
            summaryTextView.textColor = UIColor.lightGray
        }
        updateSaveButtonState()
        summaryTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddGameMode = presentingViewController is UINavigationController
        game?.favorite = originalFavoriteState!
        
        
        if isPresentingInAddGameMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let summary = summaryTextView.text ?? ""
        let favorite = favoriteSwitch.isOn
        
        game = Game(name: name, photo: photo, rating: rating, summary: summary, favorite: favorite)
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func favoriteChanged(_ sender: UISwitch) {
        if favoriteSwitch.isOn {
            game?.favorite = true
        } else {
            game?.favorite = false
        }
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        let nameText = nameTextField.text ?? ""
        let summaryTextNotEdited = summaryTextView.text == "Enter summary here"
        
        saveButton.isEnabled = !nameText.isEmpty && !summaryTextNotEdited
    }

}

