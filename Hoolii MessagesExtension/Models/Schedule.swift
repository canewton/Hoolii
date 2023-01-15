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
    
    init(jsonValue: String) {
        let dataFromJsonString = jsonValue.data(using: .utf8)!
        self = try! JSONDecoder().decode(Schedule.self, from: dataFromJsonString)
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        return String(data: encodedData, encoding: .utf8)!
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
    
    // for debugging purposes
    func toString() -> String {
        var output: String = ""
        
        for i in 0..<datesFree.count {
            output += "*** \(datesFree[i].date.date): "
            for j in 0..<datesFree[i].timesFree.count {
                output += "\(datesFree[i].timesFree[j].from.hour) \(datesFree[i].timesFree[j].from.minute) - \(datesFree[i].timesFree[j].to.hour) \(datesFree[i].timesFree[j].to.minute) -> "
            }
        }
        
        return output
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
