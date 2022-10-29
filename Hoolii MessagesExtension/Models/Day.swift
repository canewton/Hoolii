//
//  Day.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/3/22.
//

import Foundation
import UIKit

struct Day: Codable {
    
    // MARK: Properties
    var date: ScheduleDate
    var timesFree: [TimeRange]
    
    init(date: ScheduleDate, timesFree: [TimeRange]) {
        self.date = date
        self.timesFree = timesFree
    }

    
    mutating func addAvailability(_ availability: Int) {
        if timesFree.isEmpty {
            timesFree.append(TimeRange(from: availability, to: availability + 1))
        }
        
        checkInsertTop(availability: availability)
        for i in 0..<(timesFree.count - 1) {
            if i >= timesFree.count - 1 {
                break
            }
            
            // check if adding an availability merges two disconected availability blocks
            let mergedWithTopBlock: Bool = checkMergeWithTopBlock(availability: availability, blockIndex: i)
            let mergedWithBottomBlock: Bool = checkMergeWithBottomBlock(availability: availability, blockIndex: i + 1)
            
            if (!mergedWithTopBlock
                && !mergedWithBottomBlock
                && availability < timesFree[i].to
                && availability > timesFree[i + 1].from) {
                timesFree.insert(TimeRange(from: availability, to: availability + 1), at: i)
            }
        }
        checkInsertBottom(availability: availability)
        
    }
    
    // when removing an availability, check to see if it splits a block of time into two disconnected blocks of time
    mutating func removeAvailability(_ availability: Int) {
        for i in 0..<timesFree.count {
            if i >= timesFree.count {
                break
            }
            
            if (availability > timesFree[i].from && availability + 1 < timesFree[i].to) {
                let beginning: Int = timesFree[i].from
                let end: Int = timesFree[i].to
                timesFree.remove(at: i)
                timesFree.insert(TimeRange(from: beginning, to: availability), at: i)
                timesFree.insert(TimeRange(from: availability + 1, to: end), at: i + 1)
            } else if (availability == timesFree[i].from && availability + 1 < timesFree[i].to) {
                let beginning: Int = availability + 1
                let end: Int = timesFree[i].to
                timesFree.remove(at: i)
                timesFree.insert(TimeRange(from: beginning, to: end), at: i)
            } else if (availability > timesFree[i].from && availability + 1 == timesFree[i].to) {
                let beginning: Int = timesFree[i].from
                let end: Int = availability
                timesFree.remove(at: i)
                timesFree.insert(TimeRange(from: beginning, to: end), at: i)
            } else if (availability == timesFree[i].from && availability + 1 == timesFree[i].to) {
                timesFree.remove(at: i)
            }
        }
    }
    
    // merge two disconected availability blocks relative to the top
    @discardableResult private mutating func checkMergeWithTopBlock(availability: Int, blockIndex: Int) -> Bool {
        if availability == timesFree[blockIndex].to {
            let begining: Int = timesFree[blockIndex].from
            timesFree.remove(at: blockIndex)
            timesFree.insert(TimeRange(from: begining, to: availability + 1), at: blockIndex)
            return true
        }
        return false
    }
    
    // merge two disconected availability blocks relative to the bottom
    @discardableResult private mutating func checkMergeWithBottomBlock(availability: Int, blockIndex: Int) -> Bool {
        if blockIndex > 0 && timesFree[blockIndex - 1].to == timesFree[blockIndex].from {
            let begining: Int = timesFree[blockIndex - 1].from
            let end: Int = timesFree[blockIndex].to
            timesFree.remove(at: blockIndex)
            timesFree.remove(at: blockIndex - 1)
            timesFree.insert(TimeRange(from: begining, to: end), at: blockIndex - 1)
        } else if availability + 1 == timesFree[blockIndex].from {
            let end: Int = timesFree[blockIndex].to
            timesFree.remove(at: blockIndex)
            timesFree.insert(TimeRange(from: availability, to: end), at: blockIndex)
            return true
        }
        return false
    }
    
    // insert an availability on its own above all the other availability timeframes
    private mutating func checkInsertTop(availability: Int) {
        let mergedWithBottomBlock = checkMergeWithBottomBlock(availability: availability, blockIndex: 0)
        if !mergedWithBottomBlock && availability < timesFree[0].from {
            timesFree.insert(TimeRange(from: availability, to: availability + 1), at: 0)
        }
    }
    
    // insert an availability on its own below all the other availability timeframes
    private mutating func checkInsertBottom(availability: Int) {
        let mergedWithTopBlock: Bool = checkMergeWithTopBlock(availability: availability, blockIndex: timesFree.count - 1)
        if !mergedWithTopBlock && availability > timesFree[timesFree.count - 1].to {
            timesFree.append(TimeRange(from: availability, to: availability + 1))
        }
    }
}

struct DayCollective {
    
    // MARK: Properties
    var date: ScheduleDate
    var timesFree: [TimeRangeCollective]
    
    init(date: ScheduleDate, timesFree: [TimeRangeCollective]) {
        self.date = date
        self.timesFree = timesFree
    }
}
