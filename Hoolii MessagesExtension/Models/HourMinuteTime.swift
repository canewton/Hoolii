//
//  HourMinuteTime.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/24/22.
//

import Foundation

class HourMinuteTime: Codable {
    let hour: Int
    let minute: Int
    init(hour: Int, minute: Int) {
        self.hour = hour % 24
        self.minute = minute % 60
    }
    
    init(date: Date) {
        let calendar = Calendar.current
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
    
    func toString() -> String {
        var timeString: String = ""
        if hour == 0 {
            timeString = "  12 AM"
        } else if hour < 12 {
            timeString = "  \(hour) AM"
        } else if hour == 12 {
            timeString = "  \(hour) PM"
        } else {
            timeString = "  \(hour - 12) PM"
        }
        return timeString
    }
    
    func toDate() -> Date {
        let calendar = Calendar.current
        let dateComponents = DateComponents(hour: hour, minute: minute)
        return calendar.date(from: dateComponents)!
    }
    
    public static func +(a: HourMinuteTime, b: Int) -> HourMinuteTime {
        return HourMinuteTime(hour: ((a.minute + b)/60 + a.hour) % 24, minute: (a.minute + b) % 60)
    }
    
    public static func -(a: HourMinuteTime, b: Int) -> HourMinuteTime {
        if a.minute - b < 0 {
            return HourMinuteTime(hour: (a.hour + ((a.minute * -1) - b)/60) % 24, minute: 60 + ((a.minute - b)%60))
        }
        return HourMinuteTime(hour: a.hour % 24, minute: (a.minute - b) % 60)
    }
    
    public static func +(a: HourMinuteTime, b: HourMinuteTime) -> HourMinuteTime {
        return HourMinuteTime(hour: ((b.minute + a.minute)/60 + a.hour + b.hour) % 24, minute: (a.minute + b.minute) % 60)
    }
    
    public static func -(a: HourMinuteTime, b: HourMinuteTime) -> HourMinuteTime {
        if a.minute - b.minute < 0 {
            return HourMinuteTime(hour: (a.hour - b.hour - 1 + (a.minute - b.minute)/60) % 24, minute: 60 + ((a.minute - b.minute)%60))
        }
        return HourMinuteTime(hour: (a.hour - b.hour) % 24, minute: (a.minute - b.minute) % 60)
    }
    
    public static func ==(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return a.hour == b.hour && a.minute == b.minute
    }
    
    public static func !=(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return !(a.hour == b.hour && a.minute == b.minute)
    }
    
    public static func >(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute)
    }
    
    public static func >=(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute)
    }
    
    public static func <(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute)
    }
    
    public static func <=(a: HourMinuteTime, b: HourMinuteTime) -> Bool {
        return a.hour < b.hour || (a.hour == b.hour && a.minute <= b.minute)
    }
    
    func toFloat() -> CGFloat{
        return CGFloat(hour) + CGFloat(minute)/60.0
    }
}
