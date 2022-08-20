//
//  ScheduleFinishedViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class ScheduleFinishedViewController: AppViewController, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "ScheduleFinishedViewController"
    
    weak var delegate: AnyObject?
    
}

protocol ScheduleFinishedViewControllerDelegate: AnyObject {
}

extension MessagesViewController: ScheduleFinishedViewControllerDelegate {
}
