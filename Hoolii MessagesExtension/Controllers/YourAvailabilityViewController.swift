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
    @IBOutlet weak var meetingTitle: UILabel!
    var availabilityInput: FullAvailabilityInput!
    var isShowingPersonalView: Bool = true
    var isCreatingMeeting = false
    var userSchedule: Schedule!
    
    var firstName: String!
    var lastName: String!
    var id: String!
    var collectiveSchedule: CollectiveSchedule!
    let availabilityBarWidth: CGFloat = 120 // width of the interactive column that determines availability
    let timeIndicatorViewHeight: CGFloat = 15 // might need to delete
    
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
        
        configureMeetingName()
        
        // create new schedule for user if user has not filled it out yet
        if collectiveSchedule.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName)) == nil {
            userSchedule = collectiveSchedule.appendEmptySchedule(user: User(id: id, firstName: firstName, lastName: lastName))
        } else {
            userSchedule = collectiveSchedule.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName))!
        }
        
        // determine if this person was the one who created the meeting
        // they have a chance to edit the meeting if they were the one who created it
        if !isCreatingMeeting {
            editMeetingButton.removeFromSuperview()
            topBarHeightConstraint.constant = 55
        }
        
        configureEditButton()
        configureFilterSwitch()
        configureSendButton()
        configureBottomBar()
        configureAvailabilityInput()
        
        // dummy data that represents responses to the message
        if collectiveSchedule.allSchedules.count < 2 {
            collectiveSchedule.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("12-27-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("12-28-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("12-29-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "1", firstName: "Joanna", lastName: "Hu")))
            collectiveSchedule.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("12-27-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 9, minute: 30), to: HourMinuteTime(hour: 14, minute: 0))]), Day(date: ScheduleDate(CalendarDate("12-28-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 14, minute: 0), to: HourMinuteTime(hour: 19, minute: 0))]),Day(date: ScheduleDate(CalendarDate("12-29-2022").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 14, minute: 0), to: HourMinuteTime(hour: 20, minute: 0))]),], user: User(id: "2", firstName: "Jessica", lastName: "Mei")))
        }
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        collectiveSchedule.setScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName), schedule: userSchedule)
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(collectiveSchedule: collectiveSchedule)
    }
    
    @objc func onEditMeeting(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Determine the name of the meeting
    func configureMeetingName() {
        var name: String = collectiveSchedule.meetingName
        if name == "" {
            
            let date: CalendarDate = CalendarDate(collectiveSchedule.dates[0])
            
            if collectiveSchedule.dates.count == 1 {
                if date == CalendarDate(Date()) {
                    name += "Meeting for today"
                } else {
                    name += "Meeting for \(date.getMonthSymbol()) \(date.day)"
                }
            } else {
                name += "Meeting(s) starting \(date.getMonthSymbol()) \(date.day)"
            }
        }
        
        meetingTitle.text = name
        collectiveSchedule.meetingName = name
    }
    
    // Determine if the group view or the user view should be displayed
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
    
    // use the group data to display the group view
    private func displayGroupView() {
        let allAvailabilities: [DayCollective?] = AvailabilityLogic.getDaysAndTimesFree(collectiveSchedule.allSchedules)

        for i in 0..<allAvailabilities.count {
            let availabilityBar: AvailabilityBar = availabilityInput.availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayAllUsersDay(day: allAvailabilities[i], numUsers: collectiveSchedule.allSchedules.count)
        }
    }

    // use the user data to display the personal view
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
    
    // set constraints for the availability input
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
    
    // set styling for the bottom bar
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
