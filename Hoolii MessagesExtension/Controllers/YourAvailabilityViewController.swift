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
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
    var availabilityInput: FullAvailabilityInput!
    var isShowingPersonalView: Bool = true
    var isCreatingMeeting = false
    var userSchedule: Schedule!
    
    var firstName: String!
    var lastName: String!
    var id: String!
    var userAvatar: Avatar!
    let availabilityBarWidth: CGFloat = 120 // width of the interactive column that determines availability
    let timeIndicatorViewHeight: CGFloat = 15 // might need to delete
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileButton.configure(viewController: self)
        
        StoredValues.setIfEmpty(key: StoredValuesConstants.firstName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.lastName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.userID, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.userAvatar, value: "")
        
        firstName = StoredValues.get(key: StoredValuesConstants.firstName)!
        lastName = StoredValues.get(key: StoredValuesConstants.lastName)!
        id = StoredValues.get(key: StoredValuesConstants.userID)!
        userAvatar = Avatar(jsonValue: StoredValues.get(key: StoredValuesConstants.userAvatar)!)
        
        configureMeetingName()
        
        // create new schedule for user if user has not filled it out yet
        if CollectiveSchedule.shared.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName, avatar: Avatar().encodeAvatar())) == nil {
            userSchedule = CollectiveSchedule.shared.appendEmptySchedule(user: User(id: id, firstName: firstName, lastName: lastName, avatar: userAvatar.encodeAvatar()))
        } else {
            userSchedule = CollectiveSchedule.shared.getScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName, avatar: userAvatar.encodeAvatar()))!
        }
        
        // determine if this person was the one who created the meeting
        // they have a chance to edit the meeting if they were the one who created it
        if !isCreatingMeeting {
            editMeetingButton.removeFromSuperview()
            topBarHeightConstraint.constant = 55
        }
        
        // fix bug when onboarding screen goes back to this screen
        bottomBarConstraint.isActive = true
        
        configureEditButton()
        configureFilterSwitch()
        configureSendButton()
        configureBottomBar()
        configureAvailabilityInput()
        
        // dummy data that represents responses to the message
        if CollectiveSchedule.shared.allSchedules.count < 2 {
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R1", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R19", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R2", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R3", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R4", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R5", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R6", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R7", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R8", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R9", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R10", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R11", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R12", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R13", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R14", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R15", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R16", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R17", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
//            CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "08vnG54CgIqjvzFeB41R18", firstName: "Joanna", lastName: "Hu", avatar: Avatar(randomized: true).encodeAvatar())))
            //CollectiveSchedule.shared.allSchedules.append(Schedule(datesFree: [Day(date: ScheduleDate(CalendarDate("1-23-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-24-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-25-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-26-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-27-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 11, minute: 0), to: HourMinuteTime(hour: 16, minute: 0))]), Day(date: ScheduleDate(CalendarDate("1-28-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 10, minute: 0), to: HourMinuteTime(hour: 13, minute: 0))]),Day(date: ScheduleDate(CalendarDate("1-29-2023").date), timesFree: [TimeRange(from: HourMinuteTime(hour: 12, minute: 0), to: HourMinuteTime(hour: 18, minute: 0))]),], user: User(id: "19", firstName: "Joanna", lastName: "Hu")))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) && StoredValues.isKeyNil(key: StoredValuesConstants.yourAvailabilityOnboarding)) {
            AlertManager.yourAvailabilityAlert(controller: self)
        }
    }
    
    func userHasEmptySchedule() -> Bool {
        var hasEmptySchedule: Bool = true
        for i in 0..<userSchedule.datesFree.count {
            if userSchedule.datesFree[i].timesFree.count > 0 {
                hasEmptySchedule = false
            }
        }
        return hasEmptySchedule
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        if userHasEmptySchedule() {
            AlertManager.sendAlert(controller: self, acceptCallback: {(_ darkenedScreen: UIViewController) -> Void in darkenedScreen.dismiss(animated: true)
                self.sendMessage()
            }, cancelCallback: {(_ darkenedScreen: UIViewController) -> Void in
                darkenedScreen.dismiss(animated: true)
            })
        } else {
            sendMessage()
        }
    }
    
    func sendMessage() {
        CollectiveSchedule.shared.setScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName, avatar: userAvatar.encodeAvatar()), schedule: userSchedule)
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.dismissExtension()
    }
    
    @objc func onEditMeeting(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Determine the name of the meeting
    func configureMeetingName() {
        var name: String = CollectiveSchedule.shared.meetingName
        if name == "" {
            
            let date: CalendarDate = CalendarDate(CollectiveSchedule.shared.dates[0])
            
            if CollectiveSchedule.shared.dates.count == 1 {
                if date == CalendarDate(Date()) {
                    name += "Today's meeting"
                } else {
                    name += "\(date.getMonthName()) \(date.day) meeting"
                }
            } else {
                name += "Meeting(s) starting \(date.getMonthSymbol()) \(date.day)"
            }
        }
        
        meetingTitle.text = name
        CollectiveSchedule.shared.meetingName = name
    }
    
    // Determine if the group view or the user view should be displayed
    func toggleFilterSwitch(_ filter: String) {
        if filter == "Group" {
            CollectiveSchedule.shared.setScheduleWithUser(User(id: id, firstName: firstName, lastName: lastName, avatar: userAvatar.encodeAvatar()), schedule: userSchedule)
            availabilityInput.hideAutoFillButton()
            displayGroupView()
            isShowingPersonalView = false
        } else {
            displayPersonalView()
            availabilityInput.hideAvailiabilityDetail()
            availabilityInput.showAutoFillButton()
            isShowingPersonalView = true
        }
    }
    
    // use the group data to display the group view
    private func displayGroupView() {
        let allAvailabilities: [DayCollective] = AvailabilityLogic.getDaysAndTimesFree(CollectiveSchedule.shared.allSchedules)

        for i in 0..<allAvailabilities.count {
            let availabilityBar: AvailabilityBar = availabilityInput.availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayAllUsersDay(day: allAvailabilities[i], numUsers: CollectiveSchedule.shared.allSchedules.count)
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
    
    func setSchedule(_ schedule: Schedule) {
        userSchedule = schedule
    }
    
    // set constraints for the availability input
    func configureAvailabilityInput() {
        availabilityInput = FullAvailabilityInput.instanceFromNib(userSchedule: userSchedule, startTime: CollectiveSchedule.shared.startTime, endTime: CollectiveSchedule.shared.endTime, setScheduleCallback: setSchedule)
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
        if traitCollection.userInterfaceStyle == .light {
            bottomBar.layer.shadowColor = AppColors.shadowColor.cgColor
            bottomBar.layer.shadowOpacity = 0.6
            bottomBar.layer.shadowOffset = .zero
            bottomBar.layer.shadowRadius = 10
        }
    }
    
    func configureSendButton() {
        let sendIcon: UIImage = ScaledIcon(name: "send", width: 14, height: 14, color: .label).image
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
    func dismissExtension()
}

extension MessagesViewController: YourAvaialabilitiesViewControllerDelegate {
    func dismissExtension() {
        SendMessage()
        dismiss()
    }
}
