//
//  FullAvailabilityInput.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/7/22.
//

import UIKit

// a collection of all of the availability bars
class FullAvailabilityInput: UIView, UIScrollViewDelegate {
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var datesHorizontalList: UIStackView!
    @IBOutlet weak var availabilityBarHorizontalList: UIStackView!
    @IBOutlet weak var timeIndicatorVerticalList: UIStackView!
    @IBOutlet weak var datesScrollView: UIScrollView!
    @IBOutlet weak var availabilityBarScrollView: UIScrollView!
    @IBOutlet weak var timeIndicatorScrollView: UIScrollView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var backgroundStackView: UIStackView!
    var availabilityDetail: AvailabilityDetail!
    var autofillButton: AutofillButton!
    var autofillFeedback: AutofillFeedback?
    var isShowingAvailabilityDetail: Bool = false
    var currentDateShowing: ScheduleDate = ScheduleDate(Date())
    var userSchedule: Schedule!
    var setScheduleCallback: ((Schedule) -> Void)!
    
    let availabilityBarWidth: CGFloat = 120 // width of the interactive column that determines
    let timeIndicatorViewHeight: CGFloat = 15 // height of the segments inside the bar
    var startTime: HourMinuteTime!
    var endTime: HourMinuteTime!
    
    var availabilityDetailLeftConstraint: NSLayoutConstraint!
    var availabilityDetailTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        datesScrollView.delegate = self
        availabilityBarScrollView.delegate = self
        timeIndicatorScrollView.delegate = self
    }
    
    func setUpComponents() {
        configureAvailabilityBars()
        configureTimeIndicatorVerticalList()
        configureDatesHorizontalList()
        configureTopBar()
        
        if userSchedule.datesFree.count > 0 && userSchedule.datesFree[0].date.date != nil {
            showAutoFillButton()
            monthLabel.text = CalendarDate(userSchedule.datesFree[0].date.date!).getMonthSymbol()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // display all of the availability bars based on a schedule
    class func instanceFromNib(userSchedule: Schedule, startTime: HourMinuteTime, endTime: HourMinuteTime, setScheduleCallback: @escaping ((Schedule) -> Void)) -> FullAvailabilityInput? {
        let fullAvailabilityInput: FullAvailabilityInput? = UINib(nibName: "FullAvailabilityInput", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FullAvailabilityInput
        fullAvailabilityInput?.userSchedule = userSchedule
        fullAvailabilityInput?.startTime = startTime
        fullAvailabilityInput?.endTime = endTime
        fullAvailabilityInput?.setScheduleCallback = setScheduleCallback
        fullAvailabilityInput?.setUpComponents()
        return fullAvailabilityInput
    }
    
    // when the left space that show the times that time blocks represent is scrolled through, the availability bars should be scrolled through at the same rate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        availabilityBarScrollView.contentOffset.x = datesScrollView.contentOffset.x
        backgroundScrollView.contentOffset.x = datesScrollView.contentOffset.x
        if scrollView == availabilityBarScrollView {
            timeIndicatorScrollView.contentOffset.y = availabilityBarScrollView.contentOffset.y
        } else if scrollView == timeIndicatorScrollView {
            availabilityBarScrollView.contentOffset.y = timeIndicatorScrollView.contentOffset.y
        }
    }
    
    func buildCollectiveSchedule(_ day: Day) {
        userSchedule.updateDay(day)
        
        // the parent screen needs to set the userSchedule data based on information provided in this component
        // the callback allows for this
        setScheduleCallback(userSchedule)
    }
    
    // when each availability bar is interacted with, set callbacks so that data is changed from these interactions
    private func configureAvailabilityBars() {
        let startTime: HourMinuteTime = startTime
        let endTime: HourMinuteTime = endTime
        
        for i in 0..<userSchedule.datesFree.count {
            if let availabilityBar = AvailabilityBar.instanceFromNib(startime: startTime, endTime: endTime) {
                availabilityBar.translatesAutoresizingMaskIntoConstraints = false
                availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                availabilityBar.setDay(day: userSchedule.datesFree[i])
                availabilityBar.configureHighlightCallback(buildCollectiveSchedule)
                availabilityBar.configureDetailsCallback(show: showAvailiabilityDetail, hide: hideAvailiabilityDetail)
                availabilityBarHorizontalList.addArrangedSubview(availabilityBar)
            }
            let backgroundBar: UIView = UIView()
            backgroundStackView.addArrangedSubview(backgroundBar)
            backgroundBar.heightAnchor.constraint(equalToConstant: self.bounds.height * 2).isActive = true
            backgroundBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
            backgroundBar.backgroundColor = AppColors.backgroundBar
        }
    }
    
    // when there is a new schedule passed in, remove all of the availability bars from this view and reinstantiate all of the availability bars
    func updateUserSchedule(schedule: Schedule) {
        userSchedule = schedule
        for _ in 0..<availabilityBarHorizontalList.subviews.count {
            availabilityBarHorizontalList.subviews[0].removeFromSuperview()
            backgroundStackView.subviews[0].removeFromSuperview()
        }
        configureAvailabilityBars()
    }
    
    // autofill all of the availability bars with data from the weekly availability housed in the profile screen
    func autofillButtonCallback() {
        let jsonString: String? = StoredValues.get(key: StoredValuesConstants.userSchedule)
        if jsonString != nil {
            let regularSchedule: Schedule = Schedule(jsonValue: jsonString!)
            
            if checkIfWeeklyAvailEmpty(schedule: regularSchedule) {
                alertForBlankWeeklyAvailability()
            } else {
                setAvailabilitiesFromWeeklyAvailability(schedule: regularSchedule)
                
                displayAutofillFeedback(text: "Your weekly availability has autofilled your schedule!")
            }
        } else {
            alertForBlankWeeklyAvailability()
        }
    }
    
    func displayAutofillFeedback(text: String) {
        if autofillFeedback == nil {
            autofillFeedback = AutofillFeedback.instanceFromNib()
            availabilityBarScrollView.addSubview(autofillFeedback!)
            autofillFeedback?.translatesAutoresizingMaskIntoConstraints = false
            autofillFeedback?.widthAnchor.constraint(equalToConstant: 200).isActive = true
            autofillFeedback?.heightAnchor.constraint(equalToConstant: 60).isActive = true
            autofillFeedback?.bottomAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
            autofillFeedback?.rightAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
            autofillFeedback?.feedbackLabel.text = text
            autofillFeedback?.transform = CGAffineTransform(scaleX: 0.85, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
                self.autofillFeedback?.transform = .identity
            })
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: hideAutofillFeedback)
        }
    }
    
    func hideAutofillFeedback(timer: Timer) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.autofillFeedback?.transform = CGAffineTransform(scaleX: 0.85, y: 0.001)

         }) { (success) in
             self.autofillFeedback?.removeFromSuperview()
             self.autofillFeedback = nil
         }
    }
    
    func setAvailabilitiesFromWeeklyAvailability(schedule: Schedule) {
        var autofilledAvailabilities = false
        for i in 0..<userSchedule.datesFree.count {
            let correspondingWeekday: Day = schedule.datesFree[CalendarDate(userSchedule.datesFree[i].date.date!).weekday]
            userSchedule.datesFree[i].timesFree = correspondingWeekday.timesFree
            
            if correspondingWeekday.timesFree.count > 0 && (CollectiveSchedule.shared.startTime < correspondingWeekday.timesFree[0].from || CollectiveSchedule.shared.endTime > correspondingWeekday.timesFree[correspondingWeekday.timesFree.count - 1].to) {
                autofilledAvailabilities = true
            }
        }
        
        if autofilledAvailabilities == false {
            displayAutofillFeedback(text: "No weekly availabilities fit into this timeframe.")
        }
        updateUserSchedule(schedule: userSchedule)
        setScheduleCallback(userSchedule)
    }
    
    func checkIfWeeklyAvailEmpty(schedule: Schedule) -> Bool {
        var isEmpty = true
        for i in 0..<schedule.datesFree.count {
            if !schedule.datesFree[i].timesFree.isEmpty {
                isEmpty = false
                break
            }
        }
        return isEmpty
    }
    
    func alertForBlankWeeklyAvailability() {
        AlertManager.autofillAlert(controller: findViewController()!, acceptCallback: {(_ darkenedScreen: UIViewController) -> Void in
            darkenedScreen.dismiss(animated: true)
            self.goToProfileViewController()
        }, cancelCallback: {(_ darkenedScreen: UIViewController) -> Void in darkenedScreen.dismiss(animated: true)})
    }
    
    func goToProfileViewController() {
        let profileVC = self.findViewController()?.storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        (self.findViewController() as? YourAvailabilitiesViewController)?.transitionToScreen(viewController: profileVC)
    }
    
    // the availability detail must be created every time it is displayed
    func showAvailiabilityDetail(_ day: DayCollective, _ time: HourMinuteTime) {
        if availabilityDetail != nil && availabilityDetail.isCollapsed == false {
            return
        }
        
        var timeRangeToDisplay: TimeRangeCollective = TimeRangeCollective(from: startTime, to: endTime, users: [])
        if day.timesFree.count > 0 {
            timeRangeToDisplay = TimeRangeCollective(from: startTime, to: day.timesFree[0].from, users: [])
            
            if time >= day.timesFree[day.timesFree.count - 1].to {
                timeRangeToDisplay = TimeRangeCollective(from: day.timesFree[day.timesFree.count - 1].to, to: endTime, users: [])
            }
            for i in 0..<day.timesFree.count {
                if day.timesFree[i].isWithinRange(time: time) {
                    timeRangeToDisplay = day.timesFree[i]
                    break
                }
            }
        }
        
        if !isShowingAvailabilityDetail {
            createAvailabilityDetail(date: day.date, timeRange: timeRangeToDisplay)
            isShowingAvailabilityDetail = true
            currentDateShowing = day.date
        } else if currentDateShowing == day.date {
            availabilityDetail.configureTimeRange(timeRange: TimeRange(from: timeRangeToDisplay.from, to: timeRangeToDisplay.to), date: day.date)
            availabilityDetail.configureUsers(users: timeRangeToDisplay.users)
        } else {
            hideAvailiabilityDetail()
            createAvailabilityDetail(date: day.date, timeRange: timeRangeToDisplay)
            currentDateShowing = day.date
            isShowingAvailabilityDetail = true
        }
        
        availabilityDetailTopConstraint = availabilityDetail.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 80)
        availabilityDetailLeftConstraint = availabilityDetail.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 10)
    }
    
    // the availability detail must be destroyed every time it is closed
    func hideAvailiabilityDetail() {
        if isShowingAvailabilityDetail {
            availabilityDetail.removeFromSuperview()
            availabilityDetail = nil
            isShowingAvailabilityDetail = false
        }
    }
    
    func expandAvailabilityDetail() {
        availabilityDetailLeftConstraint.isActive = true
        availabilityDetailTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
           self.layoutIfNeeded()
        })
    }
    
    func collapseAvailabilityDetail() {
        availabilityDetailLeftConstraint.isActive = false
        availabilityDetailTopConstraint.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: {
           self.layoutIfNeeded()
        })
    }

    // instantiate the availability detail in the bottom right corner
    func createAvailabilityDetail(date: ScheduleDate, timeRange: TimeRangeCollective) {
        availabilityDetail = AvailabilityDetail.instanceFromNib(closeDetail: hideAvailiabilityDetail, expandDetail: expandAvailabilityDetail, collapseDetail: collapseAvailabilityDetail)
        availabilityDetail.configureTimeRange(timeRange: TimeRange(from: timeRange.from, to: timeRange.to), date: date)
        availabilityDetail.configureUsers(users: timeRange.users)
        self.addSubview(availabilityDetail)
        availabilityDetail.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        availabilityDetail.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
    }
    
    // instantiate the autofill button in the bottom right corner
    func showAutoFillButton() {
        if autofillButton == nil {
            autofillButton = AutofillButton.instanceFromNib()
            availabilityBarScrollView.addSubview(autofillButton)
            autofillButton.translatesAutoresizingMaskIntoConstraints = false
            autofillButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            autofillButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            autofillButton.bottomAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
            autofillButton.rightAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
            autofillButton.callback = autofillButtonCallback
        }
    }
    
    // delete the autofill button
    func hideAutoFillButton() {
        if autofillButton != nil {
            autofillButton.removeFromSuperview()
        }
        autofillButton = nil
    }
    
    // display a list of times to the side of availability bars
    func configureTimeIndicatorVerticalList() {
        let startTime: HourMinuteTime = startTime
        let endTime: HourMinuteTime = endTime
        //for time in startTime...endTime {
        for i in 0..<Int((endTime - startTime).toFloat() + 1) {
            let time: HourMinuteTime = startTime + AvailabilityConstants.timeInterval * (i * 2)
            if let timeIndicatorView = TimeIndicatorView.instanceFromNib() {
                timeIndicatorView.time.text = time.toString()
                timeIndicatorView.heightAnchor.constraint(equalToConstant: timeIndicatorViewHeight).isActive = true
                timeIndicatorVerticalList.addArrangedSubview(timeIndicatorView)
                timeIndicatorVerticalList.spacing = CGFloat(AvailabilityConstants.blockHeight) * 2 - timeIndicatorViewHeight
            }
        }
    }
    
    // display dates on the top of each availability bar
    func configureDatesHorizontalList() {
        for i in 0..<userSchedule.datesFree.count {
            // the availability bars are displaying dates for user view a group view
            if userSchedule.datesFree[i].date.isDate() {
                if let dateView = DateHeaderView.instanceFromNib() {
                    dateView.translatesAutoresizingMaskIntoConstraints = false
                    dateView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                    dateView.dateLabel.text = String(CalendarDate(userSchedule.datesFree[i].date.date!).day)
                    dateView.weekdayLabel.text = CalendarDate(userSchedule.datesFree[i].date.date!).getWeekdayAbr().uppercased()
                    datesHorizontalList.addArrangedSubview(dateView)
                }
            // the availability bars are displaying weekdays for setting the profile weekly availability
            } else {
                if let dayView = DayHeaderView.instanceFromNib() {
                    dayView.translatesAutoresizingMaskIntoConstraints = false
                    dayView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                    
                    let weekdayStr = CalendarDate.weekdaySymbols[userSchedule.datesFree[i].date.weekDate!]
                    dayView.weekdayLabel.text = weekdayStr.uppercased()
                    datesHorizontalList.addArrangedSubview(dayView)
                }
            }
            
        }
    }
    
    // style the top bar
    func configureTopBar() {
        topBar.layer.shadowColor = AppColors.shadowColor.cgColor
        topBar.layer.shadowOpacity = 0.2
        topBar.layer.shadowOffset = .zero
        topBar.layer.shadowRadius = 2
        topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
