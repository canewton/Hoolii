//
//  CreateMeetingPreviewViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/15/22.
//

import UIKit

// when the user is going to create a meeting, the collapsed view is this screen
class CreateMeetingPreviewViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var createMeetingCalendarContainer: UIView!
    @IBOutlet weak var profileButton: ProfileButton!
    
    static let storyboardIdentifier = "CreateMeetingPreviewViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileButton.configure(viewController: self)
        configureMeetingCalendar()
        
        profileButton.callback = expandView
    }
    
    @IBAction func onPressendExpandButton(_ sender: Any) {
        expandView()
    }
    
    func expandView() {
        (delegate as? CreateMeetingPreviewViewControllerDelegate)?.createMeetingPreviewViewControllerDidSelectExpand(controller: self)
    }
    
    func configureMeetingCalendar() {
        let meetingCalendar: CreateMeetingCalendar = instantiateController()
        createMeetingCalendarContainer.addSubview(meetingCalendar.view)
        self.addChild(meetingCalendar)
        meetingCalendar.view.translatesAutoresizingMaskIntoConstraints = false
        meetingCalendar.view.leftAnchor.constraint(equalTo: createMeetingCalendarContainer.leftAnchor).isActive = true
        meetingCalendar.view.rightAnchor.constraint(equalTo: createMeetingCalendarContainer.rightAnchor).isActive = true
        meetingCalendar.view.bottomAnchor.constraint(equalTo: createMeetingCalendarContainer.bottomAnchor).isActive = true
        meetingCalendar.view.topAnchor.constraint(equalTo: createMeetingCalendarContainer.topAnchor).isActive = true
    }
    
    func instantiateController() -> CreateMeetingCalendar {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CreateMeetingCalendar.storyboardIdentifier)
                as? CreateMeetingCalendar
            else { fatalError("Unable to instantiate controller from the storyboard") }
        
        controller.delegate = self
        controller.numRows = 1
        
        return controller
    }
}

protocol CreateMeetingPreviewViewControllerDelegate: AnyObject {
    func createMeetingPreviewViewControllerDidSelectExpand(controller: CreateMeetingPreviewViewController)
}

extension MessagesViewController: CreateMeetingPreviewViewControllerDelegate {
    func createMeetingPreviewViewControllerDidSelectExpand(controller: CreateMeetingPreviewViewController) {
        requestPresentationStyle(.expanded)
    }
}
