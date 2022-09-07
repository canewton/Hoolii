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
    let dateString: String
    static let weekdaySymbols: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    init(_ date: Date) {
        self.date = date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)

        year = components.year!
        month = components.month!
        day = components.day!
        let weekdayIndex: Int = components.weekday! - 1
        weekdayString = CalendarDate.weekdaySymbols[weekdayIndex]
        dateString = "\(String(format: "%02d", month))-\(String(format: "%02d", day))-\(String(format: "%04d", year))"
    }
    
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let parsedDate = dateFormatter.date(from: dateString)!
        
        self.init(parsedDate)
    }
}
