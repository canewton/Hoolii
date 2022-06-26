//
//  Schedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import Foundation
import UIKit

class Schedule: QueryItemRepresentable {
    
    // MARK: Properties
    var timesFree: Int
    var person: String
    static var queryItemKey: String {
        return "schedule"
    }
    let jsonValue: String;
    
    init(timesFree: Int, person: String) {
        self.timesFree = timesFree
        self.person = person
        self.jsonValue = "{\"timesFree\":\"\(String(timesFree))\", \"person\":\"\(person)\"}"
    }
}

extension QueryItemRepresentable where Self: Schedule {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: Self.queryItemKey, value: jsonValue)
    }

}
