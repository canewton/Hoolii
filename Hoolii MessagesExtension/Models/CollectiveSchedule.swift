//
//  CollectiveSchedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import Foundation
import Messages

struct CollectiveSchedule {
    var allSchedules: [Schedule] = []
    var dates: [Date] = []
    var expirationDate: Date = Date()
    var meetingName: String = ""
    var startTime: HourMinuteTime = HourMinuteTime(hour: 0, minute: 0)
    var endTime: HourMinuteTime = HourMinuteTime(hour: 0, minute: 0)
}

/// Extends `CollectiveSchedule` to be able to be represented by and created with an array of `NSURLQueryItems`s
extension CollectiveSchedule {
    
    // prepare the schedule to be sent in a message
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        let datesAsStrings: [String] = dates.map{CalendarDate($0).dateString}
        let datessEncoded = try! JSONEncoder().encode(datesAsStrings)
        let datesEncodedString = String(data: datessEncoded, encoding: .utf8)!
        let allSchedulesEncoded = try! JSONEncoder().encode(allSchedules)
        let allSchedulesEncodedString = String(data: allSchedulesEncoded, encoding: .utf8)!
        let startTimeEncoded = try! JSONEncoder().encode(startTime)
        let startTimeEncodedString = String(data: startTimeEncoded, encoding: .utf8)!
        let endTimeEncoded = try! JSONEncoder().encode(endTime)
        let endTimeEncodedString = String(data: endTimeEncoded, encoding: .utf8)!
        
        items.append(URLQueryItem(name: "allSchedules", value: allSchedulesEncodedString))
        items.append(URLQueryItem(name: "dates", value: datesEncodedString))
        items.append(URLQueryItem(name: "expirationDate", value: CalendarDate(expirationDate).dateString))
        items.append(URLQueryItem(name: "meetingName", value: meetingName))
        items.append(URLQueryItem(name: "startTime", value: startTimeEncodedString))
        items.append(URLQueryItem(name: "endTime", value: endTimeEncodedString))
        
        return items
    }
    
    // decode a message into a CollectiveSchedule object
    init?(queryItems: [URLQueryItem]) {
        for queryItem in queryItems {
            if queryItem.name == "allSchedules" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                allSchedules = try! JSONDecoder().decode([Schedule].self, from: dataFromJsonString)
            } else if queryItem.name == "expirationDate" {
                expirationDate = CalendarDate(queryItem.value!).date
            } else if queryItem.name == "meetingName" {
                meetingName = queryItem.value!
            } else if queryItem.name == "endTime" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                endTime = try! JSONDecoder().decode(HourMinuteTime.self, from: dataFromJsonString)
            } else if queryItem.name == "startTime" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                startTime = try! JSONDecoder().decode(HourMinuteTime.self, from: dataFromJsonString)
            } else if queryItem.name == "dates" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                let datesAsStrings = try! JSONDecoder().decode([String].self, from: dataFromJsonString)
                dates = datesAsStrings.map{CalendarDate($0).date}
            }
        }
    }
    
    func getScheduleWithUser(_ user: User) -> Schedule? {
        for i in 0..<allSchedules.count {
            if user == allSchedules[i].user {
                return allSchedules[i]
            }
        }
        
        return nil
    }
    
    mutating func setScheduleWithUser(_ user: User, schedule: Schedule) {
        for i in 0..<allSchedules.count {
            if user == allSchedules[i].user {
                allSchedules[i] = schedule
            }
        }
    }
    
    // add an empty user schedule
    mutating func appendEmptySchedule(user: User) -> Schedule {
        let dayObjects: [Day] = dates.map{Day(date: ScheduleDate($0), timesFree: [])}
        let schedule = Schedule(datesFree: dayObjects, user: user)
        allSchedules.append(schedule)
        return schedule
    }
    
    mutating func addDate(_ date: Date) {
        var insertedDate: Bool = false
        for i in 0..<dates.count {
            if date.timeIntervalSince1970 < dates[i].timeIntervalSince1970 {
                dates.insert(date, at: i)
                insertedDate = true
                break
            }
        }
        if !insertedDate {
            dates.append(date)
        }
    }
    
    mutating func removeDate(_ date: Date) {
        for i in 0..<dates.count {
            if dates[i] == date {
                dates.remove(at: i)
                return
            }
        }
    }
}

/// Extends `CollectiveSchedule` to be able to be created with the contents of `MSMessage`
extension CollectiveSchedule {
    
    // MARK: Initialization
    
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        // NSURLComponents parses URLs into and constructs URLs from constituent parts
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        // Query items is the query URL component as an array of nam/value pairs
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
