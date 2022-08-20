//
//  YourAvailabilityViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

class YourAvailabilitiesViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var availabilityBarContainer: UIView!
    @IBOutlet weak var sendButton: ThemedButton!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var profileButton: ProfileButton!
    
    var avaiabilityBar: AvailabilityBar = AvailabilityBar()
    var name: String = "Caden"
    var id: String = "hi"
    
    // MARK: Properties
    static let storyboardIdentifier = "YourAvailabilitiesViewController"
    weak var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProfileButton()
        configureSendButton()
        configureAvailabilityBar()
        configureTopBar()
        configureBottomBar()
    }
    
    @IBAction func OnSaveAndSend(_ sender: Any) {
        print("sending")
        (delegate as? YourAvaialabilitiesViewControllerDelegate)?.addDataToMessage(schedule: ScheduleSendable(datesFree: [avaiabilityBar.getDay()], user: User(id: self.id, name: self.name)))
    }
    
    func configureProfileButton() {
        profileButton.configure(viewController: self)
    }
    
    func configureTopBar() {
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.2
        topBar.layer.shadowOffset = .zero
        topBar.layer.shadowRadius = 2
        topBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func configureBottomBar() {
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.6
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowRadius = 10
    }
    
    func configureAvailabilityBar() {
        avaiabilityBar = AvailabilityBar(frame: availabilityBarContainer.frame)
        avaiabilityBar.frame.size.height = UIScreen.main.bounds.height - 350
        view.addSubview(avaiabilityBar)
        availabilityBarContainer.backgroundColor = UIColor.clear
    }
    
    func configureSendButton() {
        let sendIcon: UIImage = ScaledIcon(name: "paper-plane-regular", width: 15, height: 15).image
        sendButton.setImage(sendIcon, for: .normal)
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
        collectiveSchedule.expirationDate = CalendarDate("09-04-2022").date
        SendMessage(collectiveSchedule, "When should we meet up?")
        dismiss()
    }
}
