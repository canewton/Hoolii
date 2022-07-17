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
    var timesFree: Int
    var user: User
    
    init(timesFree: Int, user: User) {
        self.timesFree = timesFree
        self.user = user
    }
}
