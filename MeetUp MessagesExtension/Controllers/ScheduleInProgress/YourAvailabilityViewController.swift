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
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var profileButton: ProfileButton!
    @IBOutlet weak var datesHorizontalList: UIStackView!
    @IBOutlet weak var availabilityBarHorizontalList: UIStackView!
    @IBOutlet weak var timeIndicatorVerticalList: UIStackView!
    @IBOutlet weak var datesScrollView: UIScrollView!
    @IBOutlet weak var availabilityBarScrollView: UIScrollView!
    @IBOutlet weak var timeIndicatorScrollView: UIScrollView!
    @IBOutlet weak var filterAvailabilitiesSwitch: FilterAvailabilitiesSwitch!
    var displayPersonalView: Bool = true
    var userSchedule: Schedule!
    
    var name: String = "Caden"
    var id: String = "hi"
    var collectiveSchedule: CollectiveSchedule = CollectiveSchedule()
    let availabilityBarWidth: CGFloat = 120
    let timeIndicatorViewHeight: CGFloat = 15
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(collectiveSchedule)
        print(collectiveSchedule.allSchedules[0].schedule.datesFree)
        
        datesScrollView.delegate = self
        availabilityBarScrollView.delegate = self
        timeIndicatorScrollView.delegate = self
        
        userSchedule = collectiveSchedule.getScheduleWithhUser(User(id: id, name: name))
        
        configureFilterSwitch()
        configureTimeIndicatorVerticalList()
        configureAvailabilityBarScrollView()
        configureDatesHorizontalList()
        configureProfileButton()
        configureSendButton()
        configureTopBar()
        configureBottomBar()
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        collectiveSchedule.setScheduleWithhUser(User(id: id, name: name), schedule: userSchedule)
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(collectiveSchedule: collectiveSchedule)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        availabilityBarScrollView.contentOffset.x = datesScrollView.contentOffset.x
        if scrollView == availabilityBarScrollView {
            timeIndicatorScrollView.contentOffset.y = availabilityBarScrollView.contentOffset.y
        } else if scrollView == timeIndicatorScrollView {
            availabilityBarScrollView.contentOffset.y = timeIndicatorScrollView.contentOffset.y
        }
    }
    
    func toggleFilterSwitch(_ filter: String) {
        if filter == "Group" {
            displayPersonalView = false
        } else {
            displayPersonalView = true
        }
    }
    
    func buildCollectiveSchedule(_ day: Day) {
        userSchedule.updateDay(day)
    }
    
    func configureFilterSwitch() {
        filterAvailabilitiesSwitch.configure(callback: toggleFilterSwitch)
    }
    
    func configureTimeIndicatorVerticalList() {
        let startTime: Int = collectiveSchedule.startTime
        let endTime: Int = collectiveSchedule.endTime
        for time in startTime...endTime {
            if let timeIndicatorView = TimeIndicatorView.instanceFromNib() {
                var timeString: String = ""
                if time < 12 {
                    timeString = "  \(time) AM"
                } else if time == 12 {
                    timeString = "  \(time) PM"
                } else {
                    timeString = "  \(time - 12) PM"
                }
                timeIndicatorView.time.text = timeString
                timeIndicatorView.heightAnchor.constraint(equalToConstant: timeIndicatorViewHeight).isActive = true
                timeIndicatorVerticalList.addArrangedSubview(timeIndicatorView)
                timeIndicatorVerticalList.spacing = 60 - timeIndicatorViewHeight
            }
        }
    }
    
    func configureAvailabilityBarScrollView() {
        let allDates: [Day] = collectiveSchedule.allSchedules[0].schedule.datesFree
        let startTime: Int = collectiveSchedule.startTime
        let endTime: Int = collectiveSchedule.endTime
        for i in 0..<allDates.count {
            if let availabilityBar = AvailabilityBar.instanceFromNib(startime: startTime, endTime: endTime) {
                availabilityBar.translatesAutoresizingMaskIntoConstraints = false
                availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                availabilityBar.day = allDates[i]
                availabilityBar.configure(callback: buildCollectiveSchedule)
                availabilityBarHorizontalList.addArrangedSubview(availabilityBar)
            }
        }
    }
    
    func configureDatesHorizontalList() {
        let allDates: [Day] = collectiveSchedule.allSchedules[0].schedule.datesFree
        for i in 0..<allDates.count {
            if let dateView = DateHeaderView.instanceFromNib() {
                dateView.translatesAutoresizingMaskIntoConstraints = false
                dateView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                dateView.dateLabel.text = String(CalendarDate(allDates[i].date).day)
                dateView.weekdayLabel.text = CalendarDate(allDates[i].date).weekdayString
                datesHorizontalList.addArrangedSubview(dateView)
            }
        }
    }
    
    func configureProfileButton() {
        profileButton.configure(viewController: self)
    }
    
    func configureTopBar() {
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.2
        topBar.layer.shadowOffset = .zero
        topBar.layer.shadowRadius = 2
        topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func configureBottomBar() {
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.6
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowRadius = 10
    }
    
    func configureSendButton() {
        let sendIcon: UIImage = ScaledIcon(name: "paper-plane-regular", width: 15, height: 15).image
        sendButton.setImage(sendIcon, for: .normal)
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
