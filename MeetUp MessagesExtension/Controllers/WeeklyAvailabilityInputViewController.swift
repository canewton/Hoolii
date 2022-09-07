//
//  WeeklyAvailabilityInputViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/7/22.
//

import UIKit

class WeeklyAvailabilityInputViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var availabilityInputContainer: UIView!
    @IBOutlet weak var bottomBar: UIView!
    var availabilityInput: FullAvailabilityInput!
    var userSchedule: ScheduleSendable!
    
    var delegate: AnyObject?
    static let storyboardIdentifier = "WeeklyAvailabilityInputViewController"
    
    override func viewDidLoad() {
        configureBottomBar()
        
        availabilityInput = FullAvailabilityInput.instanceFromNib(userSchedule: userSchedule.schedule, startTime: 0, endTime: 24, buildScheduleCallback: buildUserSchedule)
        availabilityInputContainer.addSubview(availabilityInput)
        availabilityInput.translatesAutoresizingMaskIntoConstraints = false
        availabilityInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        availabilityInput.bottomAnchor.constraint(equalTo: availabilityInputContainer.bottomAnchor).isActive = true
        availabilityInput.topAnchor.constraint(equalTo: availabilityInputContainer.topAnchor).isActive = true
    }
    
    func buildUserSchedule(_ day: Day) {
        userSchedule.schedule.updateDay(day)
    }
    
    @IBAction func OnSave(_ sender: Any) {
        StoredValues.set(key: StoredValuesConstants.userSchedule, value: userSchedule.getJsonValue())
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureBottomBar() {
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.6
        bottomBar.layer.shadowOffset = .zero
        bottomBar.layer.shadowRadius = 10
    }
}
