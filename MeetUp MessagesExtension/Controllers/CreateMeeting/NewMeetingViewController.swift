//
//  NewMeetingViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

class NewMeetingViewController: UIViewController, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "NewMeetingViewController"
    
    @IBAction func OnSetTimeframe(_ sender: Any) {
        
(delegate as? NewMeetingViewControllerDelegate)?.transitonToAllAvailabilities(self)
        
        let secondVC = allAvailabilitiesViewController!
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .coverVertical
        self.present(secondVC, animated:true, completion:nil)
    }
    
    weak var delegate: AnyObject?
    var allAvailabilitiesViewController: AllAvailabilitiesViewController?
    
}

protocol NewMeetingViewControllerDelegate: AnyObject {
    func transitonToAllAvailabilities(_ controller: NewMeetingViewController)
}

extension MessagesViewController: NewMeetingViewControllerDelegate {
    func transitonToAllAvailabilities(_ controller: NewMeetingViewController) {
        let allAvailabilitiesController: AllAvailabilitiesViewController = instantiateController()
        controller.allAvailabilitiesViewController = allAvailabilitiesController
    }
}
