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
    
    weak var delegate: ScheduleInProgressViewControllerDelegate?
    
    // MARK: Properties
    static let storyboardIdentifier = "ScheduleInProgressViewController"
    
    
    @IBAction func SendButton(_ sender: Any) {
        print("hi")
        print(delegate)
        delegate?.scheduleInProgressViewController(self)
    }
}
