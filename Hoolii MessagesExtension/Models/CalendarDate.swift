//
//  CalendarDate.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/15/22.
//

import Foundation

// Get date information with this class
// Often used to get the month, day, and year of a Date object
struct CalendarDate: Codable {
    let date: Date
    let weekdayString: String
    let weekday: Int
    let day: Int
    let month: Int
    let year: Int
    let dateString: String
    static let weekdaySymbols: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    static let weekdayNames: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    static let monthSymbols: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    static let monthNames: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    init(_ date: Date) {
        self.date = date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: date)

        year = components.year!
        month = components.month!
        day = components.day!
        weekday = components.weekday! - 1
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
    
    func getMonthSymbol() -> String {
        return CalendarDate.monthSymbols[month - 1]
    }
    
    func getMonthName() -> String {
        return CalendarDate.monthNames[month - 1]
    }
    
    func getWeekdayName() -> String {
        return CalendarDate.weekdayNames[weekday]
    }
    
    func getWeekdayAbr() -> String {
        return CalendarDate.weekdaySymbols[weekday]
    }
    
    public static func ==(a: CalendarDate, b: CalendarDate) -> Bool {
        return a.month == b.month && a.day == b.day && a.year == b.year
    }
}
