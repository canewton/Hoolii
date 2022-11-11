//
//  NewMeetingViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit
import JTAppleCalendar

class NewMeetingViewController: AdaptsToKeyboard, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "NewMeetingViewController"
    weak var delegate: AnyObject?
    var yourAvailabiliesViewController: YourAvailabilitiesViewController?
    @IBOutlet weak var createMeetingCalendarContainer: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopContraint: NSLayoutConstraint!
    let arrowLeftIcon: ScaledIcon = ScaledIcon(name: "chevron-left-solid", width: 15, height: 15, color: .black)
    let arrowRightIcon: ScaledIcon = ScaledIcon(name: "chevron-right-solid", width: 15, height: 15, color: .black)
    @IBOutlet weak var newMeetingField: UITextField!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    let formatter = DateFormatter()
    var collectiveSchedule: CollectiveSchedule = CollectiveSchedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileButton.configure(viewController: self)
        
        configureDatePickers()
        configureMeetingCalendar()
        configureNameField()
        configureMainViewConstraints()
    }
    
    // set the possible meeting time frame of a meetup
    @IBAction func OnSetTimeframe(_ sender: Any) {
        (delegate as? NewMeetingViewControllerDelegate)?.transitonToYourAvailabilities(self)
        collectiveSchedule.startTime = 9
        collectiveSchedule.endTime = 21
        yourAvailabiliesViewController?.collectiveSchedule = collectiveSchedule
        yourAvailabiliesViewController?.isCreatingMeeting = true
        self.transitionToScreen(viewController: yourAvailabiliesViewController!)
    }
    
    func configureDatePickers() {
        fromDatePicker.tintColor = AppColors.main
        toDatePicker.tintColor = AppColors.main
    }
    
    func configureNameField() {
        newMeetingField.addTarget(self, action: #selector(newMeetingFieldDidChange(_:)), for: .editingChanged)
    }
    
    func configureMainViewConstraints() {
        mainViewBottomConstraint.isActive = true
        super.configure(bottomConstraint: mainViewBottomConstraint, topConstraint: mainViewTopContraint)
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
    
    func addDateCallback(_ collectiveSchedule: CollectiveSchedule) {
        self.collectiveSchedule = collectiveSchedule
    }
    
    @objc func newMeetingFieldDidChange(_ textField: UITextField) {
        collectiveSchedule.meetingName = textField.text!
    }
    
    func instantiateController() -> CreateMeetingCalendar {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CreateMeetingCalendar.storyboardIdentifier)
                as? CreateMeetingCalendar
            else { fatalError("Unable to instantiate controller from the storyboard") }
        
        controller.delegate = self
        controller.numRows = 6
        controller.addDateCallback = addDateCallback
        
        return controller
    }
}

protocol NewMeetingViewControllerDelegate: AnyObject {
    func transitonToYourAvailabilities(_ controller: NewMeetingViewController)
}

extension MessagesViewController: NewMeetingViewControllerDelegate {
    // allow this controller to transition to the YourAvailabilities screen
    func transitonToYourAvailabilities(_ controller: NewMeetingViewController) {
        let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
        controller.yourAvailabiliesViewController = yourAvailabilitiesController
    }
}
