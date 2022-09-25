//
//  HourMinuteTime.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/24/22.
//

import Foundation

class HourMinuteTime {
    let hour: Int
    let minute: Int
    let date: Date
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
        date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
    
    init(date: Date) {
        self.date = date
        hour = Calendar.current.component(.hour, from: date)
        minute = Calendar.current.component(.minute, from: date)
    }
}
