//
//  GetAvailabilityLogic.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/23/22.
//

import Foundation

class AvailabilityLogic {
    // separate schedules out into timestamps that defines the user it refers to and if it is the begining of their availability
    private static func convertSchedulesToTimeStamps(_ allSchedules: [Schedule], _ updateDatesCallback: (ScheduleDate) -> ()) -> [[[TimeStamp]]] {
        var unsortedTimeStampCollections: [[[TimeStamp]]] = []
        
        for schedule in allSchedules {
            let user: User = schedule.user
            let datesFree: [Day] = schedule.datesFree
            
            var index: Int = 0
            
            for day in datesFree {
                var timeStamps: [TimeStamp] = []
                
                let timesFree = day.timesFree
                
                if index == unsortedTimeStampCollections.count {
                    updateDatesCallback(day.date)
                    unsortedTimeStampCollections.append([])
                }
                
                for timeRange in timesFree {
                    let beginningTimeStamp: TimeStamp = TimeStamp(time: timeRange.from, user: user, isBeginning: true)
                    let endingTimeStamp: TimeStamp = TimeStamp(time: timeRange.to, user: user, isBeginning: false)
                    
                    timeStamps.append(beginningTimeStamp)
                    timeStamps.append(endingTimeStamp)
                }
                
                unsortedTimeStampCollections[index].append(timeStamps)
                
                index = index + 1
            }
        }
        
        return unsortedTimeStampCollections;
    }
    
    // take all the timestamps and sort them by recency
    private static func sortTimeStamps(_ unsortedTimeStampCollections: [[[TimeStamp]]]) -> [[TimeStamp]] {
        var sortedTimeStampCollections: [[TimeStamp]] = []
        
        for i in 0..<unsortedTimeStampCollections.count {
            
            var unsortedTimeStampCollection: [[TimeStamp]] = unsortedTimeStampCollections[i]
            
            sortedTimeStampCollections.append([])
            
            while unsortedTimeStampCollection.count > 0 {
                let earliestTimeIndexOptional: Int? = getEarliestTimeIndex(collection: unsortedTimeStampCollection)
                
                if earliestTimeIndexOptional == nil {
                    break
                }
                
                var earliestTimeIndex: Int = earliestTimeIndexOptional!
                var earliestTime: TimeStamp = unsortedTimeStampCollection[earliestTimeIndex][0]
                
                for j in 1..<unsortedTimeStampCollection.count {
                    if unsortedTimeStampCollection[j].count > 0 && earliestTime.time > unsortedTimeStampCollection[j][0].time {
                        earliestTime = unsortedTimeStampCollection[j][0]
                        earliestTimeIndex = j
                    }
                }
                
                sortedTimeStampCollections[i].append(earliestTime)
                unsortedTimeStampCollection[earliestTimeIndex].remove(at: 0)
                
                if unsortedTimeStampCollection[earliestTimeIndex].count == 0 {
                    unsortedTimeStampCollection.remove(at: earliestTimeIndex)
                }
            }
        }
        
        return sortedTimeStampCollections
    }
    
    private static func getEarliestTimeIndex(collection: [[TimeStamp]]) -> Int? {
        for j in 0..<collection.count {
            if collection[j].count > 0 {
                return j
            }
        }
        return nil
    }
    
    // convert the timestamps into time range collective
    // then, use TimeRangeCollective to create DayCollective
    private static func getAvailabilityFromTimestamps(_ sortedTimeStampCollections: [[TimeStamp]], _ dates: [ScheduleDate]) -> [DayCollective] {
        var allAvailability: [DayCollective] = []
        
        for i in 0..<sortedTimeStampCollections.count {
            let timeStampCollection: [TimeStamp] = sortedTimeStampCollections[i]
            
            var timeStampCollectiveCollection: [TimeRangeCollective] = []
            var users: [User] = []
            
            if timeStampCollection.count == 0 {
                allAvailability.append(DayCollective(date: dates[i], timesFree: []))
                continue
            }
            
            for j in 0..<(timeStampCollection.count - 1) {
                let timeStampCurrentIndex: TimeStamp = timeStampCollection[j]
                let timeStampNextIndex: TimeStamp = timeStampCollection[j + 1]
                
                if timeStampCurrentIndex.isBeginning {
                    users.append(timeStampCurrentIndex.user)
                } else {
                    users.remove(at: users.firstIndex(of: timeStampCurrentIndex.user)!)
                }
                
                if timeStampCurrentIndex.time != timeStampNextIndex.time && users.count > 0 {
                    timeStampCollectiveCollection.append(TimeRangeCollective(from: timeStampCurrentIndex.time, to: timeStampNextIndex.time, users: users))
                }
            }
            
            allAvailability.append(DayCollective(date: dates[i], timesFree: timeStampCollectiveCollection))
        }
        
        return allAvailability
    }
    
    static func getDaysAndTimesFree(_ allSchedules: [Schedule]) -> [DayCollective] {
        var dates: [ScheduleDate] = []
        
        let unsortedTimeStampCollections: [[[TimeStamp]]] = convertSchedulesToTimeStamps(allSchedules) { (date) -> () in
            dates.append(date)
        }
        let sortedTimeStampCollections: [[TimeStamp]] = sortTimeStamps(unsortedTimeStampCollections)
        let allAvailability: [DayCollective] = getAvailabilityFromTimestamps(sortedTimeStampCollections, dates)
        return allAvailability
    }
    
    static func getSchedules(_ daysAndTimesFree: [DayCollective], users: [User]) -> [Schedule] {
        var schedules: [Schedule] = []
        
        let timeRangeCollectives: [[TimeRangeCollective]] = turnIntoTimeRanges(daysAndTimesFree)
        let dates: [ScheduleDate] = turnIntoDates(daysAndTimesFree)
        let days: [[Day]] = turnIntoDays(timeRangeCollectives, dates: dates, users: users)
        for i in 0..<users.count {
            schedules.append(Schedule(datesFree: days[i], user: users[i]))
        }
        
        return schedules
    }
    
    private static func turnIntoTimeRanges(_ daysAndTimesFree: [DayCollective]) -> [[TimeRangeCollective]] {
        var output: [[TimeRangeCollective]] = []
        for i in 0..<daysAndTimesFree.count {
            output.append(daysAndTimesFree[i].timesFree)
        }
        return output
    }
    
    private static func turnIntoDates(_ daysAndTimesFree: [DayCollective]) -> [ScheduleDate] {
        var output: [ScheduleDate] = []
        for i in 0..<daysAndTimesFree.count {
            output.append(daysAndTimesFree[i].date)
        }
        return output
    }
    
    private static func turnIntoDays(_ timeRangeCollectives: [[TimeRangeCollective]], dates: [ScheduleDate], users: [User]) -> [[Day]] {
        var output: [[Day]] = Array(repeating: [], count: users.count)
        for i in 0..<timeRangeCollectives.count {
            for j in 0..<users.count {
                let timeRanges = getUserTimeRanges(user: users[j], times: timeRangeCollectives[i])
                output[j].append(Day(date: dates[i], timesFree: timeRanges))
            }
        }
        return output
    }
    
    private static func getUserTimeRanges(user: User, times: [TimeRangeCollective]) -> [TimeRange] {
        var output: [TimeRange] = []
        for i in 0..<times.count {
            for j in 0..<times[i].users.count {
                if times[i].users[j].id == user.id {
                    output.append(TimeRange(from: times[i].from, to: times[i].to))
                }
            }
        }
        
        var i = 0
        while i < output.count - 1 {
            if output[i].to == output[i + 1].from {
                output[i] = TimeRange(from: output[i].from, to: output[i + 1].to)
                output.remove(at: i + 1)
            } else {
                i += 1
            }
        }
        
        return output
    }
}
