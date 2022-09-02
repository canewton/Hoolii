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
    weak var availabilityDetail: AvailabilityDetail!
    var isShowingPersonalView: Bool = true
    var isShowingAvailabilityDetail: Bool = false
    var userSchedule: Schedule!
    
    var name: String = "Caden"
    var id: String = "hi"
    var collectiveSchedule: CollectiveSchedule!
    let availabilityBarWidth: CGFloat = 120
    let timeIndicatorViewHeight: CGFloat = 15
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datesScrollView.delegate = self
        availabilityBarScrollView.delegate = self
        timeIndicatorScrollView.delegate = self
        
        if collectiveSchedule.getScheduleWithhUser(User(id: id, name: name)) == nil {
            userSchedule = collectiveSchedule.appendEmptySchedule(user: User(id: id, name: name))
        } else {
            userSchedule = collectiveSchedule.getScheduleWithhUser(User(id: id, name: name))!
        }
        
        configureAvailabilityBars()
        configureFilterSwitch()
        configureTimeIndicatorVerticalList()
        configureDatesHorizontalList()
        configureProfileButton()
        configureSendButton()
        configureTopBar()
        configureBottomBar()
        
        collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: CalendarDate("09-13-2022").date, timesFree: [TimeRange(from: 11, to: 16)]), Day(date: CalendarDate("09-14-2022").date, timesFree: [TimeRange(from: 10, to: 13)]),Day(date: CalendarDate("09-15-2022").date, timesFree: [TimeRange(from: 12, to: 18)]),], user: User(id: "1", name: "Joanna")))
        collectiveSchedule.allSchedules.append(ScheduleSendable(datesFree: [Day(date: CalendarDate("09-13-2022").date, timesFree: [TimeRange(from: 9, to: 14)]), Day(date: CalendarDate("09-14-2022").date, timesFree: [TimeRange(from: 14, to: 19)]),Day(date: CalendarDate("09-15-2022").date, timesFree: [TimeRange(from: 14, to: 20)]),], user: User(id: "2", name: "Jessica")))
        
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
            collectiveSchedule.setScheduleWithhUser(User(id: id, name: name), schedule: userSchedule)
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
            let availabilityBar: AvailabilityBar = availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayAllUsersDay(day: allAvailabilities[i], numUsers: collectiveSchedule.allSchedules.count)
        }
    }
    
    private func displayPersonalView() {
        for i in 0..<availabilityBarHorizontalList.arrangedSubviews.count {
            let availabilityBar: AvailabilityBar = availabilityBarHorizontalList.arrangedSubviews[i] as! AvailabilityBar
            availabilityBar.translatesAutoresizingMaskIntoConstraints = false
            availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            availabilityBar.displayUserDay()
        }
    }
    
    private func configureAvailabilityBars() {
        let startTime: Int = collectiveSchedule.startTime
        let endTime: Int = collectiveSchedule.endTime
        
        for i in 0..<userSchedule.datesFree.count {
            if let availabilityBar = AvailabilityBar.instanceFromNib(startime: startTime, endTime: endTime) {
                availabilityBar.translatesAutoresizingMaskIntoConstraints = false
                availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                availabilityBar.setDay(day: userSchedule.datesFree[i])
                availabilityBar.configureHighlightCallback(buildCollectiveSchedule)
                availabilityBar.configureDetailsCallback(show: showAvailiabilityDetail, hide: hideAvailiabilityDetail)
                availabilityBarHorizontalList.addArrangedSubview(availabilityBar)
            }
        }
    }
    
    func buildCollectiveSchedule(_ day: Day) {
        userSchedule.updateDay(day)
    }
    
    func showAvailiabilityDetail(_ day: Day) {
        if !isShowingAvailabilityDetail {
            createAvailabilityDetail()
        }
        isShowingAvailabilityDetail = true
    }
    
    func hideAvailiabilityDetail() {
        if isShowingAvailabilityDetail {
            availabilityDetail.removeFromSuperview()
            availabilityDetail = nil
        }
        isShowingAvailabilityDetail = false
    }
    
    func createAvailabilityDetail() {
        availabilityDetail = AvailabilityDetail.instanceFromNib()
        availabilityBarScrollView.addSubview(availabilityDetail)
        availabilityDetail.bottomAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        availabilityDetail.rightAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
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
    
    func configureDatesHorizontalList() {
        for i in 0..<userSchedule.datesFree.count {
            if let dateView = DateHeaderView.instanceFromNib() {
                dateView.translatesAutoresizingMaskIntoConstraints = false
                dateView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                dateView.dateLabel.text = String(CalendarDate(userSchedule.datesFree[i].date).day)
                dateView.weekdayLabel.text = CalendarDate(userSchedule.datesFree[i].date).weekdayString
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
