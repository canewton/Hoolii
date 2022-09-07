//
//  SchedulePreviewViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class SchedulePreviewViewController: AppViewController, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "SchedulePreviewViewController"
    weak var delegate: AnyObject?
    @IBOutlet weak var profileButton: ProfileButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileButton.configure(viewController: self)
        
        profileButton.callback = expandView
    }
    
    @IBAction func onPressendExpandButton(_ sender: Any) {
        expandView()
    }
    
    func expandView() {
        (delegate as? SchedulePreviewControllerDelegate)?.schedulePreviewViewControllerDidSelectExpand(self)
    }
}

protocol SchedulePreviewControllerDelegate: AnyObject {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController)
}

extension MessagesViewController: SchedulePreviewControllerDelegate {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController) {
        requestPresentationStyle(.expanded)
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let safeData = data {
            let dataString: String = String(data: safeData, encoding: .utf8)!
            print(dataString)
        }
    }
}
