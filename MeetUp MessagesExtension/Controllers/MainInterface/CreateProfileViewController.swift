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
    
    var callback: ((String) -> Void)?
    let defaults = UserDefaults.standard
    
    static let storyboardIdentifier = "CreateProfileViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        backButton.configure(viewController: self)
        StoredValues.setIfEmpty(key: StoredValuesConstants.userID, value: makeID(length: 20))
    }
    
    @IBAction func onCreateProfilePressed(_ sender: Any) {
        callback?(usernameField.text!)
        
        self.dismiss(animated: true, completion: nil)
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
}

extension CreateProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
