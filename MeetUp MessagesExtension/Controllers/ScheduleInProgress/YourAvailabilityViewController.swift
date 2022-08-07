//
//  YourAvailabilityViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

class YourAvailabilitiesViewController: UIViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var availabilityBarContainer: UIView!
    
    var avaiabilityBar: AvailabilityBar = AvailabilityBar()
    var name: String = "Caden"
    var id: String = "hi"
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avaiabilityBar = AvailabilityBar(frame: availabilityBarContainer.frame)
        avaiabilityBar.frame.size.height = UIScreen.main.bounds.height - 350
        view.addSubview(avaiabilityBar)
        availabilityBarContainer.backgroundColor = UIColor.clear
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        print("sending")
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(schedule: ScheduleSendable(datesFree: [avaiabilityBar.getDay()], user: User(id: self.id, name: self.name)))
    }
}

protocol YourAvaialabilitiesViewControllerDelegate: AnyObject {
    func addDataToMessage(schedule: ScheduleSendable)
}

extension MessagesViewController: YourAvaialabilitiesViewControllerDelegate {
    func addDataToMessage(schedule: ScheduleSendable) {
        var collectiveSchedule: CollectiveSchedule = CollectiveSchedule();
        
        var userScheduleIndex: Int = -1
        for i in 0..<allSchedules.count {
            if self.allSchedules[i].schedule.user.id == schedule.schedule.user.id {
                userScheduleIndex = i
            }
        }
        
        if userScheduleIndex >= 0 {
            // edit the user if the user already replied
            self.allSchedules[userScheduleIndex] = schedule
        } else {
            // append the user if the user has not replied
            self.allSchedules.append(schedule)
        }
        
        collectiveSchedule.allSchedules = self.allSchedules
        collectiveSchedule.expirationDateString = "09-04-2022"
        SendMessage(collectiveSchedule, "When should we meet up?")
        dismiss()
    }
}
