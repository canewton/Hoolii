//
//  AlertManager.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/7/23.
//

import UIKit
class AlertManager {
    static func createNewMeetingAlert(controller: UIViewController) {
        let alert = AppAlert.instanceFromNib(image: UIImage(named: "cal-phone"), title: "You're all set!", description: "You can start creating your new Hoolii", dismissButtonText: "Create a Hoolii")!
        let darkenedScreen: DarkenedScreen = DarkenedScreen(viewController: controller)
        alert.backgroundColor = AppColors.alert
        darkenedScreen.addAlert(alert: alert)
        darkenedScreen.dismissOnTap = false
        alert.heightAnchor.constraint(equalToConstant: 290).isActive = true
        
        StoredValues.set(key: StoredValuesConstants.newMeetingOnboarding, value: "yes")
        
        controller.present(darkenedScreen, animated: true, completion: nil)
    }
    
    static func yourAvailabilityAlert(controller: UIViewController) {
        let alert = AppAlert.instanceFromNib(image: UIImage(named: "phone-graphic"), title: "Plan your meeting!", description: "Start planning your hangout by filling out the times you're free.", labelOnBottom: false, dismissButtonText: "Start Planning")!
        let darkenedScreen: DarkenedScreen = DarkenedScreen(viewController: controller)
        alert.backgroundColor = AppColors.alert
        darkenedScreen.addAlert(alert: alert)
        darkenedScreen.dismissOnTap = false
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        StoredValues.set(key: StoredValuesConstants.newMeetingOnboarding, value: "yes")
        StoredValues.set(key: StoredValuesConstants.yourAvailabilityOnboarding, value: "yes")
        
        controller.present(darkenedScreen, animated: true, completion: nil)
    }
    
    static func autofillAlert(controller: UIViewController, acceptCallback: @escaping (_ darkenedScreen: UIViewController) -> Void, cancelCallback: @escaping (_ darkenedScreen: UIViewController) -> Void) {
        let alert = AppActionableAlert.instanceFromNib(image: UIImage(named: "cal-stick.png"), cancelText: "I'll do it later", acceptText: "Set Availability", title: "What's your availibility?", description: "You haven't set up your weekly availability in your Profile yet.")!
        let darkenedScreen: DarkenedScreen = DarkenedScreen(viewController: controller)
        alert.acceptCallback = acceptCallback
        alert.cancelCallback = cancelCallback
        alert.backgroundColor = AppColors.alert
        darkenedScreen.addAlert(alert: alert)
        
        controller.present(darkenedScreen, animated: true, completion: nil)
    }
    
    static func sendAlert(controller: UIViewController, acceptCallback: @escaping ((_ darkenedScreen: UIViewController) -> Void) , cancelCallback: @escaping ((_ darkenedScreen: UIViewController) -> Void)) {
        let alert = AppActionableAlert.instanceFromNib(image: UIImage(named: "cal-alert.png"), cancelText: "Keep editing", acceptText: "Send away", title: "Wait! Your availability is empty.", description: "You are sending a blank schedule with no availabilities for your hangout.")!
        let darkenedScreen: DarkenedScreen = DarkenedScreen(viewController: controller)
        alert.acceptCallback = acceptCallback
        alert.cancelCallback = cancelCallback
        alert.backgroundColor = AppColors.alert
        darkenedScreen.addAlert(alert: alert)
        
        controller.present(darkenedScreen, animated: true, completion: nil)
        
    }
    
    static func saveWeeklyAvailabilityAlert(controller: UIViewController, dismissCallback: @escaping (() -> Void)) {
        let alert = AppAlert.instanceFromNib(image: UIImage(named: "cal-jumping"), title: "Saved!", description: "You can now autofill your weekly availability for all future hangouts")!
        let darkenedScreen: DarkenedScreen = DarkenedScreen(viewController: controller)
        alert.backgroundColor = AppColors.alert
        darkenedScreen.addAlert(alert: alert)
        darkenedScreen.addDismissCallback(callback: dismissCallback)
        
        controller.present(darkenedScreen, animated: true, completion: nil)
    }
}
