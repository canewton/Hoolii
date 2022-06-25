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
}

/// Extends `CollectiveSchedule` to be able to be represented by and created with an array of `NSURLQueryItems`s
extension CollectiveSchedule {
    
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        for schedule in allSchedules {
            items.append(schedule.queryItem)
        }
        
        return items
    }
    
    // MARK: Initialization
    
    init?(queryItems: [URLQueryItem]) {
        var allSchedules: [Schedule] = []
        
        for queryItem in queryItems {
            // guard let value = queryItem.value else { continue }
            
            if queryItem.name == QueryItemKeys.schedule {
                allSchedules.append(Schedule(timesFree: 0, person: ""))
            }
        }
        
        self.allSchedules = allSchedules
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
