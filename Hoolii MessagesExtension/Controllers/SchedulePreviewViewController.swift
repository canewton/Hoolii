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
    @IBOutlet weak var availabilityPreviewContainer: UIView!
    
    var collectiveSchedule: CollectiveSchedule!
    var availabilityPreview: ProfileAvailabilityPreview!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileButton.configure(viewController: self)
        configureAvailabilityPreview()
        
        profileButton.callback = expandView
    }
    
    @IBAction func onPressendExpandButton(_ sender: Any) {
        expandView()
    }
    
    func expandView() {
        (delegate as? SchedulePreviewControllerDelegate)?.schedulePreviewViewControllerDidSelectExpand(self)
    }
    
    func configureAvailabilityPreview() {
        availabilityPreview = ProfileAvailabilityPreview.instanceFromNib(schedules: collectiveSchedule.allSchedules, emptySchedule: false)!
        availabilityPreviewContainer.addSubview(availabilityPreviewContainer)
        availabilityPreviewContainer.translatesAutoresizingMaskIntoConstraints = false
        availabilityPreviewContainer.leftAnchor.constraint(equalTo: availabilityPreviewContainer.leftAnchor).isActive = true
        availabilityPreviewContainer.rightAnchor.constraint(equalTo: availabilityPreviewContainer.rightAnchor).isActive = true
        availabilityPreviewContainer.bottomAnchor.constraint(equalTo: availabilityPreviewContainer.bottomAnchor).isActive = true
        availabilityPreviewContainer.topAnchor.constraint(equalTo: availabilityPreviewContainer.topAnchor).isActive = true
    }
}

protocol SchedulePreviewControllerDelegate: AnyObject {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController)
}

extension MessagesViewController: SchedulePreviewControllerDelegate {
    // allow the compact preview controller to be expanded
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
