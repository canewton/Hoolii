//
//  ProfileAvailabilityPreview.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/1/22.
//

import UIKit

class ProfileAvailabilityPreview: UIView {
    @IBOutlet weak var availabilityHorizontalList: UIStackView!
    var schedules: [ScheduleSendable]!
    var userHasEmptySchedule: Bool!
    var previewContainerHeight: CGFloat!
    var numUsers: Int = 3
    
    var allAvailabilities: [DayCollective?]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        allAvailabilities = AvailabilityLogic.getDaysAndTimesFree(schedules)
        if userHasEmptySchedule {
            for _ in 0..<7 {
                let containerView = UIView()
                containerView.backgroundColor = AppColors.lightGrey
                containerView.layer.cornerRadius = 3
                availabilityHorizontalList.addArrangedSubview(containerView)
            }
        } else {
            let overallTimeRange: TimeRange = getTimeRange()
            let timeBlockHeight: CGFloat = (previewContainerHeight - 20)/(CGFloat(overallTimeRange.to - overallTimeRange.from))
            for i in 0..<allAvailabilities.count {
                let containerView = UIView()
                containerView.backgroundColor = AppColors.lightGrey
                containerView.layer.cornerRadius = 3
                if allAvailabilities[i] != nil {
                    for j in 0..<allAvailabilities[i]!.timesFree.count {
                        let timeRange: TimeRangeCollective = allAvailabilities[i]!.timesFree[j]
                        let availabilityView = UIView()
                        containerView.addSubview(availabilityView)
                        availabilityView.backgroundColor = AppColors.availability
                        availabilityView.translatesAutoresizingMaskIntoConstraints = false
                        availabilityView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(timeRange.from - overallTimeRange.from) * timeBlockHeight).isActive = true
                        availabilityView.heightAnchor.constraint(equalToConstant: CGFloat(timeRange.to - timeRange.from) * timeBlockHeight).isActive = true
                        availabilityView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
                        availabilityView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
                        availabilityView.layer.cornerRadius = 3
                        
                        if timeRange.to - timeRange.from >= 2 {
                            let fromLabel: UILabel = UILabel()
                            let toLabel: UILabel = UILabel()
                            fromLabel.text = getTime(timeRange.from)
                            fromLabel.font = .systemFont(ofSize: 8)
                            toLabel.text = getTime(timeRange.to)
                            toLabel.font = .systemFont(ofSize: 8)
                            availabilityView.addSubview(fromLabel)
                            availabilityView.addSubview(toLabel)
                            fromLabel.translatesAutoresizingMaskIntoConstraints = false
                            toLabel.translatesAutoresizingMaskIntoConstraints = false
                            fromLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 2).isActive = true
                            fromLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                            fromLabel.topAnchor.constraint(equalTo: availabilityView.topAnchor, constant: 2).isActive = true
                            toLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 2).isActive = true
                            toLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                            toLabel.bottomAnchor.constraint(equalTo: availabilityView.bottomAnchor, constant: -2).isActive = true
                        }
                    }
                }
                
                availabilityHorizontalList.addArrangedSubview(containerView)
            }
        }
        
        func getTimeRange() -> TimeRange {
            var minTime: Int = 24
            var maxTime: Int = 0
            for scheduleIndex in 0..<schedules.count {
                for i in 0..<schedules[scheduleIndex].schedule.datesFree.count {
                    let schedule = schedules[scheduleIndex].schedule
                    for j in 0..<schedule.datesFree[i].timesFree.count {
                        if schedule.datesFree[i].timesFree[j].from < minTime {
                            minTime = schedule.datesFree[i].timesFree[j].from
                        }
                        if schedule.datesFree[i].timesFree[j].to > maxTime {
                            maxTime = schedule.datesFree[i].timesFree[j].to
                        }
                    }
                }
            }
            return TimeRange(from: minTime, to: maxTime)
        }
        
        func getTime(_ timeInput: Int) -> String {
            var timeString: String = ""
            if timeInput == 0 || timeInput == 24 {
                timeString = "12 AM"
            } else if timeInput < 12 {
                timeString = "\(timeInput) AM"
            } else if timeInput == 12 {
                timeString = "\(timeInput) PM"
            } else {
                timeString = "\(timeInput - 12) PM"
            }
            return timeString
        }
    }
    
    class func instanceFromNib(schedules: [ScheduleSendable], userHasEmptySchedule: Bool, previewContainerHeight: CGFloat) -> ProfileAvailabilityPreview? {
        let profileAvailabilityPreview: ProfileAvailabilityPreview? = UINib(nibName: "ProfileAvailabilityPreview", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileAvailabilityPreview
        profileAvailabilityPreview?.schedules = schedules
        profileAvailabilityPreview?.userHasEmptySchedule = userHasEmptySchedule
        profileAvailabilityPreview?.previewContainerHeight = previewContainerHeight
        profileAvailabilityPreview?.setUp()
        return profileAvailabilityPreview
    }
}
