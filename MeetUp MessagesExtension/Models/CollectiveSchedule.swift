//
//  CollectiveSchedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import Foundation
import Messages

struct CollectiveSchedule {
    var allSchedules: [ScheduleSendable] = []
    var expirationDate: Date = Date()
    var meetingName: String = ""
    var startTime: Int = 0
    var endTime: Int = 0
}

/// Extends `CollectiveSchedule` to be able to be represented by and created with an array of `NSURLQueryItems`s
extension CollectiveSchedule {
    
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
//        var allSchedulesJson: [String] = []
//
//        for schedule in allSchedules {
//            allSchedulesJson.append(schedule.getJsonValue())
//            print(schedule.getJsonValue())
//        }
        
        let allSchedulesEncoded = try! JSONEncoder().encode(allSchedules)
        let allSchedulesEncodedString = String(data: allSchedulesEncoded, encoding: .utf8)!
        
        items.append(URLQueryItem(name: "allSchedules", value: allSchedulesEncodedString))
        items.append(URLQueryItem(name: "expirationDate", value: CalendarDate(expirationDate).dateString))
        items.append(URLQueryItem(name: "meetingName", value: meetingName))
        items.append(URLQueryItem(name: "startTime", value: String(startTime)))
        items.append(URLQueryItem(name: "endTime", value: String(endTime)))
        
        return items
    }
    
    // MARK: Initialization
    
    init?(queryItems: [URLQueryItem]) {
        for queryItem in queryItems {
            if queryItem.name == "allSchedules" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                allSchedules = try! JSONDecoder().decode([ScheduleSendable].self, from: dataFromJsonString)
            } else if queryItem.name == "expirationDate" {
                expirationDate = CalendarDate(queryItem.value!).date
            } else if queryItem.name == "meetingName" {
                meetingName = queryItem.value!
            } else if queryItem.name == "endTime" {
                endTime = Int(queryItem.value!)!
            } else if queryItem.name == "startTime" {
                startTime = Int(queryItem.value!)!
            }
        }
    }
    
    func getScheduleWithhUser(_ user: User) -> Schedule? {
        for i in 0..<allSchedules.count {
            if user == allSchedules[i].schedule.user {
                return allSchedules[i].schedule
            }
        }
        
        return nil
    }
    
    func setScheduleWithhUser(_ user: User, schedule: Schedule) {
        for i in 0..<allSchedules.count {
            if user == allSchedules[i].schedule.user {
                allSchedules[i].schedule = schedule
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
