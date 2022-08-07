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
    
    // represented in hours from 12am
    var from: Int
    var to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
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
