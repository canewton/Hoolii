//
//  InProgressViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

protocol ScheduleInProgressViewControllerDelegate: AnyObject {
    func addDataToMessage(schedule: ScheduleSendable)
}

class ScheduleInProgressViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    weak var delegate: ScheduleInProgressViewControllerDelegate?
    let defaults = UserDefaults.standard
    
    var name: String = ""
    var id: String = ""
    
    // MARK: Properties
    static let storyboardIdentifier = "ScheduleInProgressViewController"
    
    override func viewDidLoad() {
        if let name = defaults.string(forKey: "username") {
            self.usernameLabel.text = name
            self.name = name
        }
        
        if let id = defaults.string(forKey: "userID") {
            self.userIDLabel.text = id
            self.id = id
        }
    }
    
    
    @IBAction func SendButton(_ sender: Any) {
        delegate?.addDataToMessage(schedule: ScheduleSendable(datesFree: [Day(dateString: "07-16-2022", timesFree: [TimeRange(from: 13, to: 18)])], user: User(id: self.id, name: self.name)))
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
