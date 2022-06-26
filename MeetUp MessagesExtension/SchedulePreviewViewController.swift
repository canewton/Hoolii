//
//  SchedulePreviewViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class SchedulePreviewViewController: UIViewController {
    
    // MARK: Properties
    static let storyboardIdentifier = "SchedulePreviewViewController"
    
    weak var delegate: SchedulePreviewControllerDelegate?
    
    @IBAction func ExpandButton(_ sender: Any) {
        delegate?.schedulePreviewViewControllerDidSelectExpand(self)
    }
}

protocol SchedulePreviewControllerDelegate: AnyObject {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController)
}
