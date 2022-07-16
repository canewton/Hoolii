//
//  InProgressViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

protocol ScheduleInProgressViewControllerDelegate: AnyObject {
    func scheduleInProgressViewController(_ controller: ScheduleInProgressViewController)
}

class ScheduleInProgressViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    weak var delegate: ScheduleInProgressViewControllerDelegate?
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    static let storyboardIdentifier = "ScheduleInProgressViewController"
    
    override func viewDidLoad() {
        if let name = defaults.string(forKey: "username") {
            self.usernameLabel.text = name
        }
    }
    
    
    @IBAction func SendButton(_ sender: Any) {
        print("hi")
        print(delegate)
        delegate?.scheduleInProgressViewController(self)
    }
    
    @IBAction func onProfilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createProfileController = segue.destination as? CreateProfileViewController {
            createProfileController.callback = { message in
                self.usernameLabel.text = message
                self.defaults.set(message, forKey: "username")
            }
        }
    }
}
