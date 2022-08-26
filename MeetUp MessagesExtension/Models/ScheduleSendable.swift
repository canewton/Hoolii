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
    
    init(datesFree: [Day], user: User) {
        self.schedule = Schedule(datesFree: datesFree, user: user)
    }
    
    init(jsonValue: String) {
        let dataFromJsonString = jsonValue.data(using: .utf8)!
        self.schedule = try! JSONDecoder().decode(Schedule.self, from: dataFromJsonString)
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self.schedule)
        return String(data: encodedData, encoding: .utf8)!
    }
}

extension QueryItemRepresentable where Self: ScheduleSendable {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: Self.queryItemKey, value: getJsonValue())
    }

}
