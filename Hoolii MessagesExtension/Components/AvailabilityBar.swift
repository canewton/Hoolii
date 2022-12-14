//
//  AvailabilityBar.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class AvailabilityBar: UIView {
    @IBOutlet weak var verticalStack: UIStackView!
    var performHighlightAction: Bool = true
    var displayAllUsers: Bool = false
    
    let timeInterval: Int = 60
    var startTime: HourMinuteTime = HourMinuteTime(hour: 0, minute: 0)
    var endTime: HourMinuteTime = HourMinuteTime(hour: 0, minute: 0)
    
    var userDay: Day!
    var dayChangedCallback: ((Day) -> ())!
    var showDetailCallback: ((Day) -> ())!
    var hideDetailCallback: (() -> ())!
    
    // get the day that the availability bar represents
    func getDay() -> Day {
        return userDay
    }
    
    // set the day that the availability bar represents
    func setDay(day: Day) {
        self.userDay = day
        
        // if the day has an empty times free array, return
        if day.timesFree.count == 0 {
            return
        }
        
        // display the availabilities using the timesFree array
        if !displayAllUsers {
            displayUserDay()
        }
    }
    
    // color in time blocks in the availability bar to correspond to the timesFree property of userDay
    func displayUserDay() {
        displayAllUsers = false
        var timesFreeIndex: Int = 0
        for i in 0..<verticalStack.arrangedSubviews.count {
            let block: UIView = verticalStack.arrangedSubviews[i]
            if block is TimeBlock {
                let timeBlock = block as? TimeBlock
                let time = indexToTime(index: i)
                
                // if there are no days the user is available, make all of the time blocks blanck
                if userDay.timesFree.count == 0 {
                    timeBlock?.undoHighlight()
                } else {
                    // determine if this time block resides within the times that the user is free
                    // color in the block if this is the case
                    if userDay.timesFree[timesFreeIndex].from <= time && userDay.timesFree[timesFreeIndex].to > time {
                        timeBlock?.highlight()
                    } else if userDay.timesFree[timesFreeIndex].to <= time && timesFreeIndex + 1 < userDay.timesFree.count {
                        timesFreeIndex = timesFreeIndex + 1
                        if userDay.timesFree[timesFreeIndex].from <= time && userDay.timesFree[timesFreeIndex].to > time {
                            timeBlock?.highlight()
                        } else {
                            timeBlock?.undoHighlight()
                        }
                    } else {
                        timeBlock?.undoHighlight()
                    }
                }
            }
        }
    }
    
    // color in the time blocks in the availability bar to correspond to the availibility of everyone who responded
    func displayAllUsersDay(day: DayCollective?, numUsers: Int) {
        displayAllUsers = true
        var timesFreeIndex: Int = 0
        for i in 0..<verticalStack.arrangedSubviews.count {
            let block: UIView = verticalStack.arrangedSubviews[i]
            if block is TimeBlock {
                let timeBlock = block as? TimeBlock
                let time = indexToTime(index: i)
                
                if day != nil {
                    if day!.timesFree[timesFreeIndex].from <= time && day!.timesFree[timesFreeIndex].to > time {
                        timeBlock?.highlight(numPeople: day!.timesFree[timesFreeIndex].users.count, totalPeople: numUsers)
                    } else if day!.timesFree[timesFreeIndex].to <= time && timesFreeIndex + 1 < day!.timesFree.count {
                        timesFreeIndex = timesFreeIndex + 1
                        if day!.timesFree[timesFreeIndex].from <= time && day!.timesFree[timesFreeIndex].to > time {
                            timeBlock?.highlight(numPeople: day!.timesFree[timesFreeIndex].users.count, totalPeople: numUsers)
                        } else {
                            timeBlock?.undoHighlight()
                        }
                    } else {
                        timeBlock?.undoHighlight()
                    }
                } else {
                    timeBlock?.undoHighlight()
                }
                
            }
        }
    }
    
    // convert the 0...n index to an integer that represents time
    private func indexToTime(index: Int) -> HourMinuteTime {
        return startTime + index * timeInterval
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureHighlightCallback(_ callback: @escaping (Day)->()) {
        self.dayChangedCallback = callback
    }
    
    func configureDetailsCallback(show: @escaping (Day)->(), hide: @escaping ()->()) {
        self.showDetailCallback = show
        self.hideDetailCallback = hide
    }
    
    // before the component gets displayed to the UI, configure some properties
    func nibSetup() {
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let numberOfBlocks: Int = (Int((endTime - startTime).toFloat())/(timeInterval/60))
        
        // add lines between the blocks
        for i in 0..<numberOfBlocks {
            let block: TimeBlock = TimeBlock()
            if i == numberOfBlocks - 1 {
                block.addBorders(edges: .bottom, color: AppColors.offBlack)
            }
            verticalStack.addArrangedSubview(block)
        }
        
        clipsToBounds = true
        layer.cornerRadius = 6
        isUserInteractionEnabled = true
        
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(longPress)
        self.addGestureRecognizer(tap)
    }
    
    // instantiate the availability bar view using start times and end times passed in
    class func instanceFromNib(startime: HourMinuteTime, endTime: HourMinuteTime) -> AvailabilityBar? {
        let availabilityBar = UINib(nibName: "AvailabilityBar", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvailabilityBar
        availabilityBar?.startTime = startime
        availabilityBar?.endTime = endTime
        availabilityBar?.nibSetup()
        return availabilityBar
    }
    
    // detect which time block got pressed and handle the tap accordingly
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended && !displayAllUsers {
            let loc = gesture.location(in: self)
            for i in 0..<verticalStack.arrangedSubviews.count {
                let block: UIView = verticalStack.arrangedSubviews[i]
                if block.frame.contains(loc) && block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    
                    if !timeBlock!.isHighlighted() {
                        timeBlock!.highlight()
                        userDay.addAvailability(indexToTime(index: i))
                    } else {
                        timeBlock!.undoHighlight()
                        userDay.removeAvailability(indexToTime(index: i))
                    }
                }
            }
            
            dayChangedCallback(userDay)
        }
    }
    
    // detect which time block got swiped over and hand the gester accordingly
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .ended || gesture.state == .began {
            var barConatinsGesture: Bool = false
            // get the location of the gesture
            let loc = gesture.location(in: self)
            // loop through each label to see if its frame contains the gesture point
            for i in 0..<verticalStack.arrangedSubviews.count {
                let block: UIView = verticalStack.arrangedSubviews[i]
                if block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    
                    if block.frame.contains(loc) {
                        barConatinsGesture = true
                        if displayAllUsers {
                            toggleDisplayAvailabilityDetail(gesture: gesture, timeBlock: timeBlock!)
                        } else {
                            toggleBlockHighlight(gesture: gesture, timeBlock: timeBlock!, index: i)
                            dayChangedCallback(userDay)
                        }
                    }
                }
            }
            
            if !barConatinsGesture {
                hideDetailCallback()
            }
        }
    }
    
    // only toggle a block's highlight for the first time it get's swiped over in the same gesture
    // if a block gets swiped over twice, it doesn't toggle highlight the second time
    func toggleBlockHighlight(gesture: UIPanGestureRecognizer, timeBlock: TimeBlock, index: Int) {
        if gesture.state == .began && timeBlock.isHighlighted(){
            performHighlightAction = false
        } else if gesture.state == .began && timeBlock.isHighlighted() {
            performHighlightAction = true
        }
        
        if performHighlightAction {
            timeBlock.highlight()
            userDay.addAvailability(indexToTime(index: index))
        } else {
            timeBlock.undoHighlight()
            userDay.removeAvailability(indexToTime(index: index))
        }
    }
    
    // show the availability detail for a certain time block when displaying the group availability
    func toggleDisplayAvailabilityDetail(gesture: UIPanGestureRecognizer, timeBlock: TimeBlock) {
        if displayAllUsers && (gesture.state == .began || gesture.state == .changed) {
            showDetailCallback(userDay)
        } else if displayAllUsers && gesture.state == .ended {
            hideDetailCallback()
        }
    }
}
