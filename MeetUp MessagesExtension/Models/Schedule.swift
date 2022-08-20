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
    
    mutating func addDate(_ date: Date) {
        datesFree.append(Day(date: date, timesFree: []))
    }
    
    mutating func addDate(_ date: Date, timesFree: [TimeRange]) {
        datesFree.append(Day(date: date, timesFree: timesFree))
    }
    
    mutating func removeDate(_ date: Date) {
        for i in 0..<datesFree.count {
            if datesFree[i].date == date {
                datesFree.remove(at: i)
                return
            }
        }
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
