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
    var userSchedule: Schedule!
    var onSaveCallback: (() -> Void)?
    
    var delegate: AnyObject?
    static let storyboardIdentifier = "WeeklyAvailabilityInputViewController"
    
    // configue the availability input component that will be used to recieve weekly availability data from user interaction
    override func viewDidLoad() {
        configureBottomBar()
        
        availabilityInput = FullAvailabilityInput.instanceFromNib(userSchedule: userSchedule, startTime: HourMinuteTime(hour: 0, minute: 0), endTime: HourMinuteTime(hour: 24, minute: 0), setScheduleCallback: setCollectiveSchedule)
        availabilityInputContainer.addSubview(availabilityInput)
        availabilityInput.translatesAutoresizingMaskIntoConstraints = false
        availabilityInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        availabilityInput.bottomAnchor.constraint(equalTo: availabilityInputContainer.bottomAnchor).isActive = true
        availabilityInput.topAnchor.constraint(equalTo: availabilityInputContainer.topAnchor).isActive = true
    }
    
    func setCollectiveSchedule(_ schedule: Schedule) {
        userSchedule = schedule
    }
    
    @IBAction func OnSave(_ sender: Any) {
        StoredValues.set(key: StoredValuesConstants.userSchedule, value: userSchedule.getJsonValue())
        if onSaveCallback != nil {
            onSaveCallback!()
        }
        
        AlertManager.saveWeeklyAvailabilityAlert(controller: self, dismissCallback: afterSaveAlertAction)
    }
    
    func afterSaveAlertAction() {
        self.dismiss(animated: true)
    }
    
    func configureBottomBar() {
        if traitCollection.userInterfaceStyle == .light {
            bottomBar.layer.shadowColor = AppColors.shadowColor.cgColor
            bottomBar.layer.shadowOpacity = 0.6
            bottomBar.layer.shadowOffset = .zero
            bottomBar.layer.shadowRadius = 10
        }
    }
}
