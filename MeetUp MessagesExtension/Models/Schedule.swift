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
}

struct Day: Codable {
    
    // MARK: Properties
    var dateString: String
    var timesFree: [TimeRange]
    
    init(dateString: String, timesFree: [TimeRange]) {
        self.dateString = dateString
        self.timesFree = timesFree
    }
}

struct TimeRange: Codable {
    
    // MARK: Properties
    
    // represented in hours from 12am
    var from: Int
    var to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
}

struct DayCollective {
    
    // MARK: Properties
    var dateString: String
    var timesFree: [TimeRangeCollective]
    
    init(dateString: String, timesFree: [TimeRangeCollective]) {
        self.dateString = dateString
        self.timesFree = timesFree
    }
}

struct TimeRangeCollective {
    
    // MARK: Properties
    var from: Int
    var to: Int
    var users: [User]
    
    init(from: Int, to: Int, users: [User]) {
        self.from = from
        self.to = to
        self.users = users
    }
}

struct TimeStamp {
    
    // MARK: Properties
    var time: Int
    var user: User
    var isBeginning: Bool
    
    init(time: Int, user: User, isBeginning: Bool) {
        self.time = time
        self.user = user
        self.isBeginning = isBeginning
    }
}
