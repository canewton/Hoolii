//
//  ProfileAvailabilityPreview.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/1/22.
//

import UIKit

// the preview block for the weekly avaialabilities presented in the Profile Screen
class ProfileAvailabilityPreview: UIView {
    @IBOutlet weak var availabilityHorizontalList: UIStackView!
    var schedules: [Schedule]!
    var userHasEmptySchedule: Bool!
    var numUsers: Int = 3
    var overallTimeRange: TimeRange!
    
    var allAvailabilities: [DayCollective]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // get the percentage that a time range fills in comparison to the overall time range
    func getMultiplier(above: HourMinuteTime, below: HourMinuteTime) -> CGFloat {
        return (below - above).toFloat()/(overallTimeRange.to - overallTimeRange.from).toFloat()
    }
    
    func setUp() {
        overallTimeRange = getTimeRange()
        allAvailabilities = AvailabilityLogic.getDaysAndTimesFree(schedules)
        if userHasEmptySchedule {
            // create a list of empty containers
            for _ in 0..<7 {
                let containerView = UIView()
                containerView.backgroundColor = AppColors.lightGrey
                containerView.layer.cornerRadius = 3
                availabilityHorizontalList.addArrangedSubview(containerView)
            }
        } else {
            // create a list of containers that may have content in it that represents a user's availability
            for i in 0..<allAvailabilities.count {
                let containerView = UIView()
                containerView.backgroundColor = AppColors.lightGrey
                containerView.layer.cornerRadius = 3
                availabilityHorizontalList.addArrangedSubview(containerView)
                
                if allAvailabilities[i].timesFree.count > 0 {
                    for j in 0..<allAvailabilities[i].timesFree.count {
                        let timeRange: TimeRangeCollective = allAvailabilities[i].timesFree[j]
                        let availabilityView = UIView()
                        let availabilityOffsetView = UIView()
                        containerView.addSubview(availabilityView)
                        containerView.addSubview(availabilityOffsetView)
                        availabilityView.backgroundColor = AppColors.availability
                        
                        // define custom constraints for the content within a container
                        availabilityView.translatesAutoresizingMaskIntoConstraints = false
                        availabilityView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: getMultiplier(above: timeRange.from, below: timeRange.to)).isActive = true
                        
                        // define custom constraints for invisible views whos only purpose is to offset the availability view
                        availabilityOffsetView.translatesAutoresizingMaskIntoConstraints = false
                        availabilityOffsetView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: getMultiplier(above: overallTimeRange.from, below: timeRange.from)).isActive = true
                        availabilityOffsetView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
                        availabilityView.topAnchor.constraint(equalTo: availabilityOffsetView.bottomAnchor, constant: 0).isActive = true
                        
                        availabilityView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
                        availabilityView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
                        availabilityView.layer.cornerRadius = 3
                        
                        // display the start for the content within a container
                        let fromLabel: UILabel = UILabel()
                        fromLabel.text = timeRange.from.toStringHourMinute()
                        fromLabel.font = .systemFont(ofSize: 8)
                        availabilityView.addSubview(fromLabel)
                        fromLabel.translatesAutoresizingMaskIntoConstraints = false
                        fromLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 2).isActive = true
                        fromLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                        fromLabel.topAnchor.constraint(equalTo: availabilityView.topAnchor, constant: 2).isActive = true
                        
                        // display the end time if the availability block is big enough
                        if (timeRange.to - timeRange.from).toFloat() > 1 {
                            let toLabel: UILabel = UILabel()
                            toLabel.text = timeRange.to.toStringHourMinute()
                            toLabel.font = .systemFont(ofSize: 8)
                            availabilityView.addSubview(toLabel)
                            toLabel.translatesAutoresizingMaskIntoConstraints = false
                            toLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 2).isActive = true
                            toLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                            toLabel.bottomAnchor.constraint(equalTo: availabilityView.bottomAnchor, constant: -2).isActive = true
                        }
                    }
                }
            }
        }
        
        // determine how to scale the content with the containers to fit the container
        func getTimeRange() -> TimeRange {
            var minTime: HourMinuteTime = HourMinuteTime(hour: 23, minute: 59)
            var maxTime: HourMinuteTime = HourMinuteTime(hour: 0, minute: 0)
            for scheduleIndex in 0..<schedules.count {
                for i in 0..<schedules[scheduleIndex].datesFree.count {
                    let schedule = schedules[scheduleIndex]
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
    }
    
    // instantiate the view using schedules that are passed in as a parameter
    class func instanceFromNib(schedules: [Schedule], emptySchedule: Bool) -> ProfileAvailabilityPreview? {
        let profileAvailabilityPreview: ProfileAvailabilityPreview? = UINib(nibName: "ProfileAvailabilityPreview", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileAvailabilityPreview
        profileAvailabilityPreview?.schedules = schedules
        profileAvailabilityPreview?.userHasEmptySchedule = emptySchedule
        profileAvailabilityPreview?.setUp()
        return profileAvailabilityPreview
    }
}
