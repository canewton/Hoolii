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
    
    func isDate() -> Bool {
        return date != nil
    }
    
    func isWeekDate() -> Bool {
        return weekDate != nil
    }
}
