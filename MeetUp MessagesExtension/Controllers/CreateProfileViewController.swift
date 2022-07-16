//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    
    var callback: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
    }
    
    @IBAction func onCreateProfilePressed(_ sender: Any) {
        callback?(usernameField.text!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Properties
    static let storyboardIdentifier = "CreateProfileViewController"
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
    }
}

extension CreateProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
