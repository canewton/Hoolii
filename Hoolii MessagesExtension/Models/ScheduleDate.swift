//
//  ScheduleDate.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/14/22.
//

import Foundation

class ScheduleDate: Codable {
    let date: Date?
    let weekDate: Int?
    
    init(_ date: Date) {
        self.date = date
        self.weekDate = nil
    }
    
    init(_ weekDate: Int) {
        self.date = nil
        self.weekDate = weekDate
    }
    
    public static func <(a: ScheduleDate, b: ScheduleDate) -> Bool {
        if a.date != nil && b.date != nil {
            return a.date!.timeIntervalSince1970 < b.date!.timeIntervalSince1970
        } else if a.weekDate != nil && b.weekDate != nil {
            return a.weekDate! < b.weekDate!
        }
        return false
    }
    
    public static func ==(a: ScheduleDate, b: ScheduleDate) -> Bool {
        if a.date != nil && b.date != nil {
            return a.date!.timeIntervalSince1970 == b.date!.timeIntervalSince1970
        } else if a.weekDate != nil && b.weekDate != nil {
            return a.weekDate! == b.weekDate!
        }
        return false
    }
    
    public static func >(a: ScheduleDate, b: ScheduleDate) -> Bool {
        if a.date != nil && b.date != nil {
            return a.date!.timeIntervalSince1970 > b.date!.timeIntervalSince1970
        } else if a.weekDate != nil && b.weekDate != nil {
            return a.weekDate! > b.weekDate!
        }
        return false
    }
    
    // determine if the schedule date is a week date or actual date
    // a week date is for the user's weekly availability where their availability is associated with a day of the week instead of a specific date
    // a date is a specific date that availabilities are associated with
    func isDate() -> Bool {
        return date != nil
    }
    
    func isWeekDate() -> Bool {
        return weekDate != nil
    }
}
