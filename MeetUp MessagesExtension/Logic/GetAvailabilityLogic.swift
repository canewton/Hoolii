//
//  GetAvailabilityLogic.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/23/22.
//

import Foundation

class AvailabilityLogic {
    private static func convertSchedulesToTimeStamps(_ allSchedules: [ScheduleSendable], _ updateDatesCallback: (ScheduleDate) -> ()) -> [[[TimeStamp]]] {
        var unsortedTimeStampCollections: [[[TimeStamp]]] = []
        
        for schedule in allSchedules {
            let user: User = schedule.schedule.user
            let datesFree: [Day] = schedule.schedule.datesFree
            
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
                    if earliestTime.time > unsortedTimeStampCollection[j][0].time {
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
    
    private static func getAvailabilityFromTimestamps(_ sortedTimeStampCollections: [[TimeStamp]], _ dates: [ScheduleDate]) -> [DayCollective?] {
        var allAvailability: [DayCollective?] = []
        
        for i in 0..<sortedTimeStampCollections.count {
            let timeStampCollection: [TimeStamp] = sortedTimeStampCollections[i]
            
            var timeStampCollectiveCollection: [TimeRangeCollective] = []
            var users: [User] = []
            
            if timeStampCollection.count == 0 {
                allAvailability.append(nil)
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
    
    static func getDaysAndTimesFree(_ allSchedules: [ScheduleSendable]) -> [DayCollective?] {
        var dates: [ScheduleDate] = []
        
        let unsortedTimeStampCollections: [[[TimeStamp]]] = convertSchedulesToTimeStamps(allSchedules) { (date) -> () in
            dates.append(date)
        }
        let sortedTimeStampCollections: [[TimeStamp]] = sortTimeStamps(unsortedTimeStampCollections)
        let allAvailability: [DayCollective?] = getAvailabilityFromTimestamps(sortedTimeStampCollections, dates)
        return allAvailability
    }
}
