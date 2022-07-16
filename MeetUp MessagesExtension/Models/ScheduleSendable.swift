//
//  Schedule.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import Foundation
import UIKit

class ScheduleSendable: QueryItemRepresentable {
    
    var schedule: Schedule;
    static var queryItemKey: String {
        return "schedule"
    }
    let jsonValue: String;
    
    init(timesFree: Int, personName: String, personId: String) {
        self.schedule = Schedule(timesFree: timesFree, personName: personName, personID: personId)
        let encodedData = try! JSONEncoder().encode(self.schedule)
        self.jsonValue = String(data: encodedData, encoding: .utf8)!
    }
    
    init(jsonValue: String) {
        self.jsonValue = jsonValue
        let dataFromJsonString = self.jsonValue.data(using: .utf8)!
        self.schedule = try! JSONDecoder().decode(Schedule.self, from: dataFromJsonString)
    }
}

extension QueryItemRepresentable where Self: ScheduleSendable {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: Self.queryItemKey, value: jsonValue)
    }

}
