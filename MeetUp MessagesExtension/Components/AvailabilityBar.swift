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
    
    let hourDivisions: Int = 1
    var startTime: Int = 0
    var endTime: Int = 0
    
    var userDay: Day!
    var dayChangedCallback: ((Day) -> ())!
    
    func getDay() -> Day {
        return userDay
    }
    
    func setDay(day: Day) {
        self.userDay = day
        
        if day.timesFree.count == 0 {
            return
        }
        
        if !displayAllUsers {
            displayUserDay()
        }
    }
    
    func displayUserDay() {
        var timesFreeIndex: Int = 0
        for i in 0..<verticalStack.arrangedSubviews.count {
            let block: UIView = verticalStack.arrangedSubviews[i]
            if block is TimeBlock {
                let timeBlock = block as? TimeBlock
                let time = indexToTime(index: i)
                
                if userDay.timesFree.count == 0 {
                    timeBlock?.undoHighlight()
                } else {
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
    
    func displayAllUsersDay(day: DayCollective?, numUsers: Int) {
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
    
    private func indexToTime(index: Int) -> Int {
        return index/hourDivisions + startTime
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(callback: @escaping (Day)->()) {
        self.dayChangedCallback = callback
    }
    
    func nibSetup() {
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let numberOfBlocks: Int = (hourDivisions * (endTime - startTime))
        
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
    
    class func instanceFromNib(startime: Int, endTime: Int) -> AvailabilityBar? {
        let availabilityBar = UINib(nibName: "AvailabilityBar", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvailabilityBar
        availabilityBar?.startTime = startime
        availabilityBar?.endTime = endTime
        availabilityBar?.nibSetup()
        return availabilityBar
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
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
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .ended || gesture.state == .began {
            // get the location of the gesture
            let loc = gesture.location(in: self)
            // loop through each label to see if its frame contains the gesture point
            for i in 0..<verticalStack.arrangedSubviews.count {
                let block: UIView = verticalStack.arrangedSubviews[i]
                if block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    
                    if block.frame.contains(loc) {
                        if gesture.state == .began && timeBlock!.isHighlighted(){
                            performHighlightAction = false
                        } else if gesture.state == .began && !timeBlock!.isHighlighted() {
                            performHighlightAction = true
                        }
                        
                        if performHighlightAction {
                            timeBlock!.highlight()
                            userDay.addAvailability(indexToTime(index: i))
                        } else {
                            timeBlock!.undoHighlight()
                            userDay.removeAvailability(indexToTime(index: i))
                        }
                    }
                }
            }
            
            dayChangedCallback(userDay)
        }
    }
}
