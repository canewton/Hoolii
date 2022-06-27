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
    var personName: String
    var personID: String
    
    init(timesFree: Int, personName: String, personID: String) {
        self.timesFree = timesFree
        self.personName = personName
        self.personID = personID
    }
}
