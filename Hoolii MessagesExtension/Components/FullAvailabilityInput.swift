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
    var availabilityDetail: AvailabilityDetail!
    var autofillButton: AutofillButton!
    var isShowingAvailabilityDetail: Bool = false
    var userSchedule: Schedule!
    var setCollectiveScheduleCallback: ((Schedule) -> Void)!
    
    let availabilityBarWidth: CGFloat = 120 // width of the interactive column that determines
    let timeIndicatorViewHeight: CGFloat = 15 // height of the segments inside the bar
    var startTime: HourMinuteTime!
    var endTime: HourMinuteTime!
    
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
        
        if userSchedule.datesFree[0].date.date != nil {
            showAutoFillButton()
            monthLabel.text = CalendarDate(userSchedule.datesFree[0].date.date!).getMonthSymbol()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // display all of the availability bars based on a schedule
    class func instanceFromNib(userSchedule: Schedule, startTime: HourMinuteTime, endTime: HourMinuteTime, setCollectiveScheduleCallback: @escaping ((Schedule) -> Void)) -> FullAvailabilityInput? {
        let fullAvailabilityInput: FullAvailabilityInput? = UINib(nibName: "FullAvailabilityInput", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FullAvailabilityInput
        fullAvailabilityInput?.userSchedule = userSchedule
        fullAvailabilityInput?.startTime = startTime
        fullAvailabilityInput?.endTime = endTime
        fullAvailabilityInput?.setCollectiveScheduleCallback = setCollectiveScheduleCallback
        fullAvailabilityInput?.setUpComponents()
        return fullAvailabilityInput
    }
    
    // when the left space that show the times that time blocks represent is scrolled through, the availability bars should be scrolled through at the same rate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        availabilityBarScrollView.contentOffset.x = datesScrollView.contentOffset.x
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
        setCollectiveScheduleCallback(userSchedule)
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
        }
    }
    
    // when there is a new schedule passed in, remove all of the availability bars from this view and reinstantiate all of the availability bars
    func updateUserSchedule(schedule: Schedule) {
        userSchedule = schedule
        for _ in 0..<availabilityBarHorizontalList.subviews.count {
            availabilityBarHorizontalList.subviews[0].removeFromSuperview()
        }
        configureAvailabilityBars()
    }
    
    // autofill all of the availability bars with data from the weekly availability housed in the profile screen
    func autofillButtonCallback() {
        let jsonString: String? = StoredValues.get(key: StoredValuesConstants.userSchedule)
        if jsonString != nil {
            let regularSchedule: Schedule = Schedule(jsonValue: jsonString!)
            for i in 0..<userSchedule.datesFree.count {
                let correspondingWeekday: Day = regularSchedule.datesFree[CalendarDate(userSchedule.datesFree[i].date.date!).weekday]
                userSchedule.datesFree[i].timesFree = correspondingWeekday.timesFree
                updateUserSchedule(schedule: userSchedule)
                setCollectiveScheduleCallback(userSchedule)
            }
        }
    }
    
    // the availability detail must be created every time it is displayed
    func showAvailiabilityDetail(_ day: Day) {
        if !isShowingAvailabilityDetail {
            createAvailabilityDetail()
        }
        isShowingAvailabilityDetail = true
    }
    
    // the availability detail must be destroyed every time it is closed
    func hideAvailiabilityDetail() {
        if isShowingAvailabilityDetail {
            availabilityDetail.removeFromSuperview()
            availabilityDetail = nil
        }
        isShowingAvailabilityDetail = false
    }

    // instantiate the availability detail in the bottom right corner
    func createAvailabilityDetail() {
        availabilityDetail = AvailabilityDetail.instanceFromNib()
        availabilityBarScrollView.addSubview(availabilityDetail)
        availabilityDetail.bottomAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        availabilityDetail.rightAnchor.constraint(equalTo: availabilityBarScrollView.layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
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
                    dateView.weekdayLabel.text = CalendarDate(userSchedule.datesFree[i].date.date!).weekdayString
                    datesHorizontalList.addArrangedSubview(dateView)
                }
            // the availability bars are displaying weekdays for setting the profile weekly availability
            } else {
                if let dayView = DayHeaderView.instanceFromNib() {
                    dayView.translatesAutoresizingMaskIntoConstraints = false
                    dayView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                    dayView.weekdayLabel.text = CalendarDate.weekdaySymbols[userSchedule.datesFree[i].date.weekDate!]
                    datesHorizontalList.addArrangedSubview(dayView)
                }
            }
            
        }
    }
    
    // style the top bar
    func configureTopBar() {
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.2
        topBar.layer.shadowOffset = .zero
        topBar.layer.shadowRadius = 2
        topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
