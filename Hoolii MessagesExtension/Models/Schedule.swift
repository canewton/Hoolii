//
//  Schedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/26/22.
//

import Foundation
import UIKit

struct Schedule: Codable {
    
    // MARK: Properties
    var datesFree: [Day]
    var user: User
    
    init(datesFree: [Day], user: User) {
        self.datesFree = datesFree
        self.user = user
    }
    
    mutating func addDate(_ date: ScheduleDate) {
        self.addDate(date, timesFree: [])
    }
    
    mutating func addDate(_ date: ScheduleDate, timesFree: [TimeRange]) {
        var insertedDate: Bool = false
        for i in 0..<datesFree.count {
            if datesFree[i].date < date {
                datesFree.insert(Day(date: date, timesFree: timesFree), at: i)
                insertedDate = true
                break
            }
        }
        if !insertedDate {
            datesFree.append(Day(date: date, timesFree: timesFree))
        }
    }
    
    mutating func removeDate(_ date: ScheduleDate) {
        for i in 0..<datesFree.count {
            if datesFree[i].date == date {
                datesFree.remove(at: i)
                return
            }
        }
    }
    
    mutating func updateDay(_ day: Day) {
        for i in 0..<datesFree.count {
            if day.date == datesFree[i].date{
                datesFree[i] = day
                return
            }
        }
    }
}

struct TimeStamp {
    
    // MARK: Properties
    var time: HourMinuteTime
    var user: User
    var isBeginning: Bool
    
    init(time: HourMinuteTime, user: User, isBeginning: Bool) {
        self.time = time
        self.user = user
        self.isBeginning = isBeginning
    }
}
