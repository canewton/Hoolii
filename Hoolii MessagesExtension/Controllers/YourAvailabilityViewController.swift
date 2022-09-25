//
//  YourAvailabilityViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

class YourAvailabilitiesViewController: AppViewController, ViewControllerWithIdentifier, UIScrollViewDelegate {
    @IBOutlet weak var sendButton: ThemedButton!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var filterAvailabilitiesSwitch: FilterAvailabilitiesSwitch!
    @IBOutlet weak var availabilityInputContainer: UIView!
    @IBOutlet weak var editMeetingIcon: UIImageView!
    @IBOutlet weak var editMeetingButton: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    var availabilityInput: FullAvailabilityInput!
    var isShowingPersonalView: Bool = true
    var isCreatingMeeting = false
    var userSchedule: Schedule!
    
    var firstName: String!
    var lastName: String!
    var id: String!
    var collectiveSchedule: CollectiveSchedule!
    let availabilityBarWidth: CGFloat = 120
    let timeIndicatorViewHeight: CGFloat = 15
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileButton.configure(viewController: self)
        
        firstName = StoredValues.get(key: StoredValuesConstants.firstName)!
        lastName = StoredValues.get(key: StoredValuesConstants.lastName)!
        id = StoredValues.get(key: StoredValuesConstants.userID)!
        
        if collectiveSchedule == nil {
            return
        }
        
        if collectiveSchedule.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName)) == nil {
            userSchedule = collectiveSchedule.appendEmptySchedule(user: User(id: id, firstName: firstName, lastName: lastName))
        } else {
            userSchedule = collectiveSchedule.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName))!
        }
        
        if !isCreatingMeeting {
            editMeetingButton.removeFromSuperview()
            topBarHeightConstraint.constant = 55
        }
        
        configureEditButton()
        configureFilterSwitch()
        configureSendButton()
        configureBottomBar()
        configureAvailabilityInput()
        
        if collectiveSchedule.allSchedules.count < 2 {
            collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: ScheduleDate(CalendarDate("09-27-2022").date), timesFree: [TimeRange(from: 11, to: 16)]), Day(date: ScheduleDate(CalendarDate("09-28-2022").date), timesFree: [TimeRange(from: 10, to: 13)]),Day(date: ScheduleDate(CalendarDate("09-29-2022").date), timesFree: [TimeRange(from: 12, to: 18)]),], user: User(id: "1", firstName: "Joanna", lastName: "Hu")))
            collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: ScheduleDate(CalendarDate("09-27-2022").date), timesFree: [TimeRange(from: 9, to: 14)]), Day(date: ScheduleDate(CalendarDate("09-28-2022").date), timesFree: [TimeRange(from: 14, to: 19)]),Day(date: ScheduleDate(CalendarDate("09-29-2022").date), timesFree: [TimeRange(from: 14, to: 20)]),], user: User(id: "2", firstName: "Jessica", lastName: "Mei")))
        }
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        collectiveSchedule.setScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName), schedule: userSchedule)
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(collectiveSchedule: collectiveSchedule)
    }
    
    @objc func onEditMeeting(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func toggleFilterSwitch(_ filter: String) {
        if filter == "Group" {
            collectiveSchedule.setScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName), schedule: userSchedule)
            availabilityInput.hideAutoFillButton()
            displayGroupView()
            isShowingPersonalView = false
            
        } else {
            displayPersonalView()
            availabilityInput.showAutoFillButton()
            isShowingPersonalView = true
        }
    }
    
    private func displayGroupView() {
        let allAvailabilities: [DayCollective?] = AvailabilityLogic.getDaysAndTimesFree(collectiveSchedule.allSchedules)

        for i in 0..<allAvailabilities.count {
            let availabilityBar: AvailabilityBar = availabilityInput.availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayAllUsersDay(day: allAvailabilities[i], numUsers: collectiveSchedule.allSchedules.count)
        }
    }

    private func displayPersonalView() {
        for i in 0..<availabilityInput.availabilityBarHorizontalList.arrangedSubviews.count {
            let availabilityBar: AvailabilityBar = availabilityInput.availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayUserDay()
        }
    }
    
    func setCollectiveSchedule(_ schedule: Schedule) {
        userSchedule = schedule
    }
    
    func configureAvailabilityInput() {
        availabilityInput = FullAvailabilityInput.instanceFromNib(userSchedule: userSchedule, startTime: collectiveSchedule.startTime, endTime: collectiveSchedule.endTime, setCollectiveScheduleCallback: setCollectiveSchedule)
        availabilityInputContainer.addSubview(availabilityInput)
        availabilityInput.translatesAutoresizingMaskIntoConstraints = false
        availabilityInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        availabilityInput.bottomAnchor.constraint(equalTo: availabilityInputContainer.bottomAnchor).isActive = true
        availabilityInput.topAnchor.constraint(equalTo: availabilityInputContainer.topAnchor).isActive = true
    }
    
    func configureFilterSwitch() {
        filterAvailabilitiesSwitch.configure(callback: toggleFilterSwitch)
    }
    
    func configureBottomBar() {
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.6
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowRadius = 10
    }
    
    func configureSendButton() {
        let sendIcon: UIImage = ScaledIcon(name: "send", width: 14, height: 14, color: .black).image
        sendButton.setImage(sendIcon, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    func configureEditButton() {
        let editIcon: UIImage = ScaledIcon(name: "edit", width: 12, height: 12, color: .secondaryLabel).image
        editMeetingIcon.image = editIcon
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onEditMeeting(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        editMeetingButton.addGestureRecognizer(tap)
    }
}

protocol YourAvaialabilitiesViewControllerDelegate: AnyObject {
    func addDataToMessage(collectiveSchedule: CollectiveSchedule)
}

extension MessagesViewController: YourAvaialabilitiesViewControllerDelegate {
    func addDataToMessage(collectiveSchedule: CollectiveSchedule) {
        SendMessage(collectiveSchedule, "When should we meet up?")
        dismiss()
    }
}
