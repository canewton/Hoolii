//
//  CalendarDate.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/15/22.
//

import Foundation

struct CalendarDate: Codable {
    let date: Date
    let weekdayString: String
    let day: Int
    let month: Int
    let year: Int
    
    init(_ date: Date) {
        self.date = date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        let weekdaySymbols: [String] = ["S", "M", "T", "W", "T", "F", "S"]

        year = components.year!
        month = components.month!
        day = components.day!
        let weekdayIndex: Int = components.weekday! - 1
        weekdayString = weekdaySymbols[weekdayIndex]
    }
    
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let parsedDate = dateFormatter.date(from: dateString)!
        
        self.init(parsedDate)
    }
}
