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
    var availabilityInput: FullAvailabilityInput!
    var availabilityDetail: AvailabilityDetail!
    var isShowingPersonalView: Bool = true
    var isShowingAvailabilityDetail: Bool = false
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
        
        if collectiveSchedule.getScheduleWithhUser(User(id: id, firstName: firstName, lastName: lastName)) == nil {
            userSchedule = collectiveSchedule.appendEmptySchedule(user: User(id: id, firstName: firstName, lastName: lastName))
        } else {
            userSchedule = collectiveSchedule.getScheduleWithhUser(User(id: id, firstName: firstName, lastName: lastName))!
        }
        
        configureFilterSwitch()
        configureSendButton()
        configureBottomBar()
        
        availabilityInput = FullAvailabilityInput.instanceFromNib(userSchedule: userSchedule, startTime: collectiveSchedule.startTime, endTime: collectiveSchedule.endTime, buildCollectiveScheduleCallback: buildCollectiveSchedule)
        availabilityInputContainer.addSubview(availabilityInput)
        availabilityInput.translatesAutoresizingMaskIntoConstraints = false
        availabilityInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        availabilityInput.bottomAnchor.constraint(equalTo: availabilityInputContainer.bottomAnchor).isActive = true
        availabilityInput.topAnchor.constraint(equalTo: availabilityInputContainer.topAnchor).isActive = true
        
        
        collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: CalendarDate("09-13-2022").date, timesFree: [TimeRange(from: 11, to: 16)]), Day(date: CalendarDate("09-14-2022").date, timesFree: [TimeRange(from: 10, to: 13)]),Day(date: CalendarDate("09-15-2022").date, timesFree: [TimeRange(from: 12, to: 18)]),], user: User(id: "1", firstName: "Joanna", lastName: "Hu")))
        collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: CalendarDate("09-13-2022").date, timesFree: [TimeRange(from: 9, to: 14)]), Day(date: CalendarDate("09-14-2022").date, timesFree: [TimeRange(from: 14, to: 19)]),Day(date: CalendarDate("09-15-2022").date, timesFree: [TimeRange(from: 14, to: 20)]),], user: User(id: "2", firstName: "Jessica", lastName: "Mei")))
        
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        collectiveSchedule.setScheduleWithhUser(User(id: id, firstName: firstName, lastName: lastName), schedule: userSchedule)
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(collectiveSchedule: collectiveSchedule)
    }
    
    func toggleFilterSwitch(_ filter: String) {
        if filter == "Group" {
            collectiveSchedule.setScheduleWithhUser(User(id: id, firstName: firstName, lastName: lastName), schedule: userSchedule)
            displayGroupView()
            isShowingPersonalView = false
            
        } else {
            displayPersonalView()
            isShowingPersonalView = true
        }
    }
    
    private func displayGroupView() {
        let allAvailabilities: [DayCollective?] = getDaysAndTimesFree(collectiveSchedule.allSchedules)

        print(allAvailabilities)

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
    
    func buildCollectiveSchedule(_ day: Day) {
        userSchedule.updateDay(day)
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
        let sendIcon: UIImage = ScaledIcon(name: "send", width: 14, height: 14).image
        sendButton.setImage(sendIcon, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 14)
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
