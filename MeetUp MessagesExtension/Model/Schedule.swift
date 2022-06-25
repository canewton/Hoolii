//
//  Schedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import Foundation
import Messages

struct Schedule {
    
    // MARK: Properties
    var timesFree: Int
    var person: String
    
    var queryItem: URLQueryItem {
        return URLQueryItem(name: QueryItemKeys.schedule, value: "rawValue")
    }
}

struct QueryItemKeys {
    static var schedule: String {
        return "Schedule"
    }
}
