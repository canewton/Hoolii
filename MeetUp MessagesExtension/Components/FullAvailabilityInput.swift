//
//  FullAvailabilityInput.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/7/22.
//

import UIKit

class FullAvailabilityInput: UIView, UIScrollViewDelegate {
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var datesHorizontalList: UIStackView!
    @IBOutlet weak var availabilityBarHorizontalList: UIStackView!
    @IBOutlet weak var timeIndicatorVerticalList: UIStackView!
    @IBOutlet weak var datesScrollView: UIScrollView!
    @IBOutlet weak var availabilityBarScrollView: UIScrollView!
    @IBOutlet weak var timeIndicatorScrollView: UIScrollView!
    weak var availabilityDetail: AvailabilityDetail!
    var isShowingPersonalView: Bool = true
    var isShowingAvailabilityDetail: Bool = false
    var userSchedule: Schedule!
    var buildCollectiveScheduleCallback: ((Day) -> Void)!
    
    let availabilityBarWidth: CGFloat = 120
    let timeIndicatorViewHeight: CGFloat = 15
    var startTime: Int!
    var endTime: Int!
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func instanceFromNib(userSchedule: Schedule, startTime: Int, endTime: Int, buildScheduleCallback: @escaping ((Day) -> Void)) -> FullAvailabilityInput? {
        let fullAvailabilityInput: FullAvailabilityInput? = UINib(nibName: "FullAvailabilityInput", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FullAvailabilityInput
        fullAvailabilityInput?.userSchedule = userSchedule
        fullAvailabilityInput?.startTime = startTime
        fullAvailabilityInput?.endTime = endTime
        fullAvailabilityInput?.buildCollectiveScheduleCallback = buildScheduleCallback
        fullAvailabilityInput?.setUpComponents()
        return fullAvailabilityInput
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        availabilityBarScrollView.contentOffset.x = datesScrollView.contentOffset.x
        if scrollView == availabilityBarScrollView {
            timeIndicatorScrollView.contentOffset.y = availabilityBarScrollView.contentOffset.y
        } else if scrollView == timeIndicatorScrollView {
            availabilityBarScrollView.contentOffset.y = timeIndicatorScrollView.contentOffset.y
        }
    }
    
    private func configureAvailabilityBars() {
        let startTime: Int = startTime
        let endTime: Int = endTime
        
        for i in 0..<userSchedule.datesFree.count {
            if let availabilityBar = AvailabilityBar.instanceFromNib(startime: startTime, endTime: endTime) {
                availabilityBar.translatesAutoresizingMaskIntoConstraints = false
                availabilityBar.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                availabilityBar.setDay(day: userSchedule.datesFree[i])
                availabilityBar.configureHighlightCallback(buildCollectiveScheduleCallback)
                availabilityBar.configureDetailsCallback(show: showAvailiabilityDetail, hide: hideAvailiabilityDetail)
                availabilityBarHorizontalList.addArrangedSubview(availabilityBar)
            }
        }
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
    
    func configureTimeIndicatorVerticalList() {
        let startTime: Int = startTime
        let endTime: Int = endTime
        for time in startTime...endTime {
            if let timeIndicatorView = TimeIndicatorView.instanceFromNib() {
                var timeString: String = ""
                if time == 0 || time == 24 {
                    timeString = "  12 AM"
                } else if time < 12 {
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
            if userSchedule.datesFree[i].date != nil {
                if let dateView = DateHeaderView.instanceFromNib() {
                    dateView.translatesAutoresizingMaskIntoConstraints = false
                    dateView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                    dateView.dateLabel.text = String(CalendarDate(userSchedule.datesFree[i].date!).day)
                    dateView.weekdayLabel.text = CalendarDate(userSchedule.datesFree[i].date!).weekdayString
                    datesHorizontalList.addArrangedSubview(dateView)
                }
            } else {
                if let dayView = DayHeaderView.instanceFromNib() {
                    dayView.translatesAutoresizingMaskIntoConstraints = false
                    dayView.widthAnchor.constraint(equalToConstant: availabilityBarWidth).isActive = true
                    dayView.weekdayLabel.text = CalendarDate.weekdaySymbols[userSchedule.datesFree[i].dayOfTheWeek!]
                    datesHorizontalList.addArrangedSubview(dayView)
                }
            }
            
        }
    }
    
    func configureTopBar() {
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.2
        topBar.layer.shadowOffset = .zero
        topBar.layer.shadowRadius = 2
        topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
