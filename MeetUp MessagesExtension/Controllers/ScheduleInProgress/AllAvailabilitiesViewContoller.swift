//
//  InProgressViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class AllAvailabilitiesViewController: UIViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var availabilityBarContainer: UIView!
    weak var delegate: AnyObject?
    var yourAvailabilitiesViewController: YourAvailabilitiesViewController?
    
    let defaults = UserDefaults.standard
    var name: String = ""
    var id: String = ""
    var avaiabilityBar: AvailabilityBar = AvailabilityBar()
    
    static let storyboardIdentifier = "AllAvailabilitiesViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = defaults.string(forKey: "username") {
            self.usernameLabel.text = name
            self.name = name
        }
        
        if let id = defaults.string(forKey: "userID") {
            self.userIDLabel.text = id
            self.id = id
        }
        
        avaiabilityBar = AvailabilityBar(frame: availabilityBarContainer.frame)
        avaiabilityBar.frame.size.height = UIScreen.main.bounds.height - 350
        view.addSubview(avaiabilityBar)
        availabilityBarContainer.backgroundColor = UIColor.clear
    }
    
    @IBAction func OnEditAvailabilities(_ sender: Any) {
        (delegate as? AllAvailabilitiesViewControllerDelegate)?.transitionToYourAvailabilities(self)
        let secondVC = yourAvailabilitiesViewController!
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .coverVertical
        self.present(secondVC, animated:true, completion:nil)
    }
    
    @IBAction func onProfilePressed(_ sender: Any) {
        let secondVC = storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .coverVertical
        self.present(secondVC, animated:true, completion:nil)
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

protocol AllAvailabilitiesViewControllerDelegate: AnyObject {
    func transitionToYourAvailabilities(_ controller: AllAvailabilitiesViewController)
}

extension MessagesViewController: AllAvailabilitiesViewControllerDelegate {
    func transitionToYourAvailabilities(_ controller: AllAvailabilitiesViewController) {
        let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
        controller.yourAvailabilitiesViewController = yourAvailabilitiesController
    }
}
