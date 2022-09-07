//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: AppViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var profileIcon: UIView!
    @IBOutlet weak var profileInitials: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    let defaults = UserDefaults.standard
    
    static let storyboardIdentifier = "CreateProfileViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoredValues.setIfEmpty(key: StoredValuesConstants.firstName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.lastName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.userID, value: makeID(length: 20))
        
        usernameField.delegate = self
        backButton.configure(viewController: self)
        
        firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.text = StoredValues.get(key: StoredValuesConstants.firstName)
        lastNameTextField.text = StoredValues.get(key: StoredValuesConstants.lastName)
        
        configureProfileIcon()
        configureEditButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
    }
    
    func makeID(length: Int) -> String {
        var result = ""
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        for _ in 1...length {
            let character = characters[characters.index(
                characters.startIndex, offsetBy: Int.random(in: 0...(characters.count - 1))
            )]
            result = result + String(character)
        }
        return result
    }
    
    @objc func firstNameTextFieldDidChange(_ textField: UITextField) {
        StoredValues.set(key: StoredValuesConstants.firstName, value: textField.text!.trimmingCharacters(in: .whitespaces))
    }
    
    @objc func lastNameTextFieldDidChange(_ textField: UITextField) {
        StoredValues.set(key: StoredValuesConstants.lastName, value: textField.text!.trimmingCharacters(in: .whitespaces))
    }
    
    func configureProfileIcon() {
        profileIcon.layer.cornerRadius = 55
    }
    
    func configureEditButton() {
        let editIcon: UIImage = ScaledIcon(name: "edit", width: 14, height: 14).image
        editButton.setImage(editIcon, for: .normal)
    }
}

extension CreateProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
