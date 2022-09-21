//
//  CreateMeetingPreviewViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/15/22.
//

import UIKit

class CreateMeetingPreviewViewController: AppViewController, ViewControllerWithIdentifier {
    
    
    static let storyboardIdentifier = "CreateMeetingPreviewViewController"
    weak var delegate: AnyObject?
    
    @IBAction func onPressendExpandButton(_ sender: Any) {
        expandView()
    }
    
    func expandView() {
        (delegate as? CreateMeetingPreviewViewControllerDelegate)?.createMeetingPreviewViewControllerDidSelectExpand(self)
    }
}

protocol CreateMeetingPreviewViewControllerDelegate: AnyObject {
    func createMeetingPreviewViewControllerDidSelectExpand(_ controller: CreateMeetingPreviewViewController)
}

extension MessagesViewController: CreateMeetingPreviewViewControllerDelegate {
    func createMeetingPreviewViewControllerDidSelectExpand(_ controller: CreateMeetingPreviewViewController) {
        requestPresentationStyle(.expanded)
    }
}
