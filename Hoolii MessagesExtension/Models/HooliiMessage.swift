//
//  HooliiMessage.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/4/23.
//

// urls have a max characters of 2083
// encode collective schedules to have a character count that is under this number

import Foundation
import Messages

class HooliiMessage {
    var dates: [Date]
    var meetingName: String
    var startTime: HourMinuteTime
    var endTime: HourMinuteTime
    var users: [User]
    var allSchedules: [String]
    let maxPeople: Int = 20
    let encodingChars: KeyValuePairs<Character, Int> = ["g": 1, "h":2, "i":3, "j":4, "k":5, "l":6, "m":7, "n":8, "o":9, "p":10, "q":11, "r":12, "s":13, "t":14, "u":14, "v":15, "w":16, "x":17, "y":18, "z":19]
    
    // prepare the schedule to be sent in a message
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        let datesAsStrings: [String] = dates.map{CalendarDate($0).dateString}
        let datessEncoded = try! JSONEncoder().encode(datesAsStrings)
        let datesEncodedString = String(data: datessEncoded, encoding: .utf8)!
        let allSchedulesEncoded = try! JSONEncoder().encode(allSchedules)
        let allSchedulesEncodedString = String(data: allSchedulesEncoded, encoding: .utf8)!
        let usersEncoded = try! JSONEncoder().encode(users)
        let usersEncodedString = String(data: usersEncoded, encoding: .utf8)!
        let startTimeEncoded = try! JSONEncoder().encode(startTime)
        let startTimeEncodedString = String(data: startTimeEncoded, encoding: .utf8)!
        let endTimeEncoded = try! JSONEncoder().encode(endTime)
        let endTimeEncodedString = String(data: endTimeEncoded, encoding: .utf8)!
        
        items.append(URLQueryItem(name: "allSchedules", value: allSchedulesEncodedString))
        items.append(URLQueryItem(name: "users", value: usersEncodedString))
        items.append(URLQueryItem(name: "dates", value: datesEncodedString))
        items.append(URLQueryItem(name: "meetingName", value: meetingName))
        items.append(URLQueryItem(name: "startTime", value: startTimeEncodedString))
        items.append(URLQueryItem(name: "endTime", value: endTimeEncodedString))
        
        return items
    }
    
    convenience init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        // NSURLComponents parses URLs into and constructs URLs from constituent parts
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        // Query items is the query URL component as an array of nam/value pairs
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
    
    // decode a message into a CollectiveSchedule object
    convenience init?(queryItems: [URLQueryItem]) {
        self.init(collectiveSchedule: CollectiveSchedule())
        for queryItem in queryItems {
            if queryItem.name == "allSchedules" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                allSchedules = try! JSONDecoder().decode([String].self, from: dataFromJsonString)
            } else if queryItem.name == "users" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                users = try! JSONDecoder().decode([User].self, from: dataFromJsonString)
            } else if queryItem.name == "meetingName" {
                meetingName = queryItem.value!
            } else if queryItem.name == "endTime" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                endTime = try! JSONDecoder().decode(HourMinuteTime.self, from: dataFromJsonString)
            } else if queryItem.name == "startTime" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                startTime = try! JSONDecoder().decode(HourMinuteTime.self, from: dataFromJsonString)
            } else if queryItem.name == "dates" {
                let dataFromJsonString = queryItem.value!.data(using: .utf8)!
                let datesAsStrings = try! JSONDecoder().decode([String].self, from: dataFromJsonString)
                dates = datesAsStrings.map{CalendarDate($0).date}
            }
        }
    }
    
    init(collectiveSchedule: CollectiveSchedule) {
        self.dates = collectiveSchedule.dates
        self.meetingName = collectiveSchedule.meetingName
        self.startTime = collectiveSchedule.startTime
        self.endTime = collectiveSchedule.endTime
        self.users = []
        
        for i in 0..<collectiveSchedule.allSchedules.count {
            users.append(collectiveSchedule.allSchedules[i].user)
        }
        
        let daysAndTimesFree: [DayCollective] = AvailabilityLogic.getDaysAndTimesFree(collectiveSchedule.allSchedules)
        self.allSchedules = []
        self.allSchedules = dayCollectivesToStrings(daysAndTimesFree: daysAndTimesFree)
    }
    
    func getCollectiveSchedule() -> CollectiveSchedule {
        let dayCollectives = stringsToDayCollectives(strings: self.allSchedules, dates: dates, startTime: startTime)
        let collectiveSchedule: CollectiveSchedule = CollectiveSchedule()
        collectiveSchedule.startTime = self.startTime
        collectiveSchedule.endTime = self.endTime
        collectiveSchedule.dates = self.dates
        collectiveSchedule.meetingName = self.meetingName
        collectiveSchedule.allSchedules = AvailabilityLogic.getSchedules(dayCollectives, users: self.users)
        
        return collectiveSchedule
    }
    
    func dayCollectivesToStrings(daysAndTimesFree: [DayCollective]) -> [String] {
        var output: [String] = []
        for i in 0..<daysAndTimesFree.count {
            var dayString = ""
            var lastUsers: [User] = []
            let baseIndex: Int = hourMinuteTimeToIndex(time: startTime)
            let endIndex: Int = hourMinuteTimeToIndex(time: endTime)
            var timesFreeIndex = 0
            var j = baseIndex
            while j < endIndex {
                if timesFreeIndex >= daysAndTimesFree[i].timesFree.count {
                    dayString += usersToString(usersInput: [])
                } else {
                    let fromIndex = hourMinuteTimeToIndex(time: daysAndTimesFree[i].timesFree[timesFreeIndex].from)
                    let toIndex = hourMinuteTimeToIndex(time: daysAndTimesFree[i].timesFree[timesFreeIndex].to)
                    if j < fromIndex {
                        dayString += usersToString(usersInput: [])
                    } else if j == fromIndex {
                        lastUsers = daysAndTimesFree[i].timesFree[timesFreeIndex].users
                        dayString += usersToString(usersInput: lastUsers)
                    } else if j < toIndex {
                        dayString += usersToString(usersInput: lastUsers)
                    } else if j == toIndex {
                        timesFreeIndex += 1
                        j -= 1
                    }
                }
                j += 1
            }
            output.append(compressHexString(hexStr: dayString))
        }
        return output
    }
    
    func stringsToDayCollectives(strings: [String], dates: [Date], startTime: HourMinuteTime) -> [DayCollective] {
        var output: [DayCollective] = []
        
        for i in 0..<strings.count {
            var j = 0
            var timeCollectives: [TimeRangeCollective] = []
            var lastUsers: [User] = []
            var time = startTime
            var decompressedString = decompressHexString(compressedStr: strings[i])
            while j < decompressedString.count {
                let startIndex = decompressedString.index(decompressedString.startIndex, offsetBy: j)
                let endIndex = decompressedString.index(decompressedString.startIndex, offsetBy: j + 5)
                let hexStr = decompressedString[startIndex..<endIndex]
                let binary = hexStringToBinaryString(hexStr: String(hexStr))
                let users: [User] = stringToUsers(binary: binary)
                if users.count == 0 {
                    lastUsers = []
                } else if lastUsers.count != 0 && userArraysAreTheSame(arr1: users, arr2: lastUsers) {
                    timeCollectives[timeCollectives.count - 1].to = timeCollectives[timeCollectives.count - 1].to + 30
                } else {
                    timeCollectives.append(TimeRangeCollective(from: time, to: time + 30, users: users))
                    lastUsers = users
                }
                time = time + 30
                j += 5
            }
            output.append(DayCollective(date: ScheduleDate(dates[i]), timesFree: timeCollectives))
        }
        
        return output
    }
    
    func userArraysAreTheSame(arr1: [User], arr2: [User]) -> Bool {
        if arr1.count != arr2.count {
            return false
        }
        for i in 0..<arr1.count {
            if arr1[i].id != arr2[i].id {
                return false
            }
        }
        return true
    }
    
    func hourMinuteTimeToIndex(time: HourMinuteTime) -> Int {
        return time.hour * 2 + (time.minute > 0 ? 1 : 0)
    }
    
    func indexToHourMinuteTime(index: Int, baseTime: HourMinuteTime) -> HourMinuteTime {
        return baseTime + (index * 30)
    }
    
    func usersToString(usersInput: [User]) -> String {
        var userNumbers: [Int] = []
        for i in 0..<usersInput.count {
            for j in 0..<users.count {
                if users[j].id == usersInput[i].id {
                    userNumbers.append(j)
                }
            }
        }
        
        var outputStr: String = ""
        for _ in 0..<maxPeople {
            outputStr += "0"
        }
        
        for i in 0..<userNumbers.count {
            let index: Int = userNumbers[i]
            outputStr = replace(myString: outputStr, index, "1")
        }

        return binaryStringToHexString(binartyStr: outputStr)
    }
    
    func stringToUsers(binary: String) -> [User] {
        var output: [User] = []
        let one: Character = "1"
        let binaryStrArr = Array(binary)
        for i in 0..<users.count {
            if binaryStrArr[i] == one {
                output.append(users[i])
            }
        }
        return output
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    // only for going from 20 chars to 5 chars
    func binaryStringToHexString(binartyStr: String) -> String {
        let hexStr = String(Int(binartyStr, radix: 2)!, radix: 16)
        return hexStr.padding(toLength: 5, withPad: "0", startingAt: 0)
    }
    
    func compressHexString(hexStr: String) -> String{
        var strArr: [Character] = Array(hexStr)
        var duplicateCount = 0
        var lastChar: Character = strArr[0]
        var i = 1
        while i < strArr.count {
            if lastChar == strArr[i] {
                duplicateCount += 1
                if duplicateCount == 1 {
                    if let index = encodingChars.firstIndex(where: { $0.1 == duplicateCount }) {
                        strArr[i] = encodingChars[index].0
                    }
                    i += 1
                } else if duplicateCount > 1 && duplicateCount <= 19 {
                    strArr.remove(at: i)
                    if let index = encodingChars.firstIndex(where: { $0.1 == duplicateCount }) {
                        strArr[i - 1] = encodingChars[index].0
                    }
                } else if duplicateCount > 19 {
                    duplicateCount = 0
                    lastChar = strArr[i]
                    i += 1
                }
            } else {
                duplicateCount = 0
                lastChar = strArr[i]
                i += 1
            }
        }
        
        return String(strArr)
    }
    
    func decompressHexString(compressedStr: String) -> String {
        var strArr: [Character] = Array(compressedStr)
        var strOutputArr: [Character] = Array(compressedStr)
        var lastChar: Character = strArr[0]
        var strOutputIndex: Int = 1
        for i in 1..<strArr.count {
            if let index = encodingChars.firstIndex(where: { $0.0 == strArr[i] }) {
                strOutputArr.remove(at: strOutputIndex)
                for _ in 0..<encodingChars[index].1 {
                    strOutputArr.insert(lastChar, at: strOutputIndex)
                    strOutputIndex += 1
                }
            } else {
                lastChar = strArr[i]
                strOutputIndex += 1
            }
        }
        
        return String(strOutputArr)
    }
    
    // only for going from 5 chars to 20 chars
    func hexStringToBinaryString(hexStr: String) -> String {
        var binaryStr: String = String(Int(hexStr, radix: 16)!, radix: 2)
        for _ in 0..<(20 - binaryStr.count) {
            binaryStr = "0" + binaryStr
        }
        return binaryStr
    }
}
