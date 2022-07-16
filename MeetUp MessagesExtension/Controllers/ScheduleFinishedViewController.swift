//
//  ScheduleFinishedViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class ScheduleFinishedViewController: UIViewController {
    
    // MARK: Properties
    static let storyboardIdentifier = "ScheduleFinishedViewController"
    
    weak var delegate: ScheduleFinishedViewControllerDelegate?
    
}

protocol ScheduleFinishedViewControllerDelegate: AnyObject {
    func scheduleFininishedViewControllerDidSelectExpand(_ controller: ScheduleFinishedViewController)
}
