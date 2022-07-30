//
//  GetAvailabilityLogic.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/23/22.
//

import Foundation

extension MessagesViewController {
    private func convertSchedulesToTimeStamps(_ allSchedules: [ScheduleSendable], _ updateDateStringsCallback: (String) -> ()) -> [[[TimeStamp]]] {
        var unsortedTimeStampCollections: [[[TimeStamp]]] = []
        
        for schedule in allSchedules {
            let user: User = schedule.schedule.user
            let datesFree: [Day] = schedule.schedule.datesFree
            
            var index: Int = 0
            
            for day in datesFree {
                var timeStamps: [TimeStamp] = []
                
                let timesFree = day.timesFree
                
                if index == unsortedTimeStampCollections.count {
                    updateDateStringsCallback(day.dateString)
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
    
    private func sortTimeStamps(_ unsortedTimeStampCollections: [[[TimeStamp]]]) -> [[TimeStamp]] {
        var sortedTimeStampCollections: [[TimeStamp]] = []
        
        for i in 0..<unsortedTimeStampCollections.count {
            
            var unsortedTimeStampCollection: [[TimeStamp]] = unsortedTimeStampCollections[i]
            
            sortedTimeStampCollections.append([])
            
            while unsortedTimeStampCollection.count > 0 {
                var earliestTime: TimeStamp = unsortedTimeStampCollection[0][0]
                var earliestTimeIndex: Int = 0
                
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
    
    private func getAvailabilityFromTimestamps(_ sortedTimeStampCollections: [[TimeStamp]], _ dateStrings: [String]) -> [DayCollective] {
        var allAvailability: [DayCollective] = []
        
        for i in 0..<sortedTimeStampCollections.count {
            let timeStampCollection: [TimeStamp] = sortedTimeStampCollections[i]
            
            var timeStampCollectiveCollection: [TimeRangeCollective] = []
            var users: [User] = []
            
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
            
            allAvailability.append(DayCollective(dateString: dateStrings[i], timesFree: timeStampCollectiveCollection))
        }
        
        return allAvailability
    }
    
    func getDaysAndTimesFree(_ allSchedules: [ScheduleSendable]) {
        var dateStrings: [String] = []
        
        let unsortedTimeStampCollections: [[[TimeStamp]]] = convertSchedulesToTimeStamps(allSchedules) { (dateString) -> () in
            dateStrings.append(dateString)
        }
        let sortedTimeStampCollections: [[TimeStamp]] = sortTimeStamps(unsortedTimeStampCollections)
        let allAvailability: [DayCollective] = getAvailabilityFromTimestamps(sortedTimeStampCollections, dateStrings)
        
        print(allAvailability)
    }
}
