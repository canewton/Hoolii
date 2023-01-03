//
//  TimeRange.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/3/22.
//

import Foundation
import UIKit

struct TimeRange: Codable {
    
    // MARK: Properties
    
    var from: HourMinuteTime
    var to: HourMinuteTime
    
    init(from: HourMinuteTime, to: HourMinuteTime) {
        self.from = from
        self.to = to
    }
}

struct TimeRangeCollective {
    
    // MARK: Properties
    var from: HourMinuteTime
    var to: HourMinuteTime
    var users: [User]
    
    init(from: HourMinuteTime, to: HourMinuteTime, users: [User]) {
        self.from = from
        self.to = to
        self.users = users
    }
    
    func isWithinRange(time: HourMinuteTime) -> Bool {
        if time >= from && time <= to {
            return true
        } else {
            return false
        }
    }
}
