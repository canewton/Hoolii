//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var AvatarCreatorButton: UIButton!
    @IBOutlet weak var profileIcon: UIView!
    @IBOutlet weak var profileInitials: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileAvailabilityPreviewContainer: UIView!
    @IBOutlet weak var createProfileButton: ThemedButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var screenContent: UIView!
    var profileAvailabilityPreview: ProfileAvailabilityPreview!
    var newMeetingViewController: NewMeetingViewController!
    var userHasEmptySchedule: Bool = true
    var prevController: UIViewController!
    
    let defaults = UserDefaults.standard
    
    static let storyboardIdentifier = "CreateProfileViewController"
    var delegate: AnyObject?
    
    @IBAction func avatarButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAvatar", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) {
            createProfileButton.removeFromSuperview()
        }
        
        // set initial values of the profile if a profile has not yet been created
        StoredValues.setIfEmpty(key: StoredValuesConstants.firstName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.lastName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.userID, value: makeID(length: 20))
        
        usernameField.delegate = self
        backButton.configure(viewController: self)
        
        configureAvailabilityPreview()
        configureTextFields()
        configureProfileIcon()
        configureEditButton()
        
        setInitials()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: screenContent.bounds.height)
        screenContent.frame.size.width = view.frame.width
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
    }
    
    // make a random id with the specified length
    func makeID(length: Int) -> String {
        var result = ""
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        for _ in 1...length {
            let character = characters[characters.index(
                characters.startIndex, offsetBy: Int.random(in: 0...(characters.count - 1))
            )]
            result = result + String(character)
        }
        return result
    }
    
    // populate the edit weekly availability screen with the user's weekly availability data
    // navigate to the weekly availability screen
    @IBAction func OnEditWeeklyAvailability(_ sender: Any) {
        let weeklyAvailabilityVC = self.storyboard?
            .instantiateViewController(withIdentifier: "WeeklyAvailabilityInputViewController") as! WeeklyAvailabilityInputViewController
        weeklyAvailabilityVC.userSchedule = getUserAvailability()
        weeklyAvailabilityVC.onSaveCallback = updateAvailabilityPreview
        self.transitionToScreen(viewController: weeklyAvailabilityVC)
    }
    
    // Determine how the initials will look like
    func setInitials() {
        if firstNameTextField.text!.count > 0 && lastNameTextField.text!.count > 0 {
            let firstName = firstNameTextField.text!.uppercased()
            let lastName = lastNameTextField.text!.uppercased()
            let firstNameIndex = firstName.index(firstName.startIndex, offsetBy: 1)
            let lastNameIndex = lastName.index(lastName.startIndex, offsetBy: 1)
            profileInitials.text = String(firstName.prefix(upTo: firstNameIndex)) + String(lastName.prefix(upTo: lastNameIndex))
        } else if firstNameTextField.text!.count > 0 {
            let firstName = firstNameTextField.text!.uppercased()
            let index = firstName.index(firstName.startIndex, offsetBy: 1)
            profileInitials.text = String(firstName.prefix(upTo: index))
        } else if lastNameTextField.text!.count > 0 {
            let lastName = lastNameTextField.text!.uppercased()
            let index = lastName.index(lastName.startIndex, offsetBy: 1)
            profileInitials.text = String(lastName.prefix(upTo: index))
        } else {
            profileInitials.text = ""
        }
    }
    
    @objc func firstNameTextFieldDidChange(_ textField: UITextField) {
        StoredValues.set(key: StoredValuesConstants.firstName, value: textField.text!.trimmingCharacters(in: .whitespaces))
        setInitials()
        StoredValues.set(key: StoredValuesConstants.initials, value: profileInitials.text!)
    }
    
    @objc func lastNameTextFieldDidChange(_ textField: UITextField) {
        StoredValues.set(key: StoredValuesConstants.lastName, value: textField.text!.trimmingCharacters(in: .whitespaces))
        setInitials()
        StoredValues.set(key: StoredValuesConstants.initials, value: profileInitials.text!)
    }
    
    // get the user stored in local storage
    func getUser() -> User {
        let id: String = StoredValues.get(key: StoredValuesConstants.userID)!
        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName)!
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName)!
        return User(id: id, firstName: firstName, lastName: lastName)
    }
    
    // if there is the weekly availability has not been set, return an empty scedule
    // otherwise, decode the json string that has been stored locally and return its contents
    func getUserAvailability() -> Schedule {
        let jsonString: String? = StoredValues.get(key: StoredValuesConstants.userSchedule)
        var userSchedule: Schedule = Schedule(datesFree: [
            Day(date: ScheduleDate(0), timesFree: []),
            Day(date: ScheduleDate(1), timesFree: []),
            Day(date: ScheduleDate(2), timesFree: []),
            Day(date: ScheduleDate(3), timesFree: []),
            Day(date: ScheduleDate(4), timesFree: []),
            Day(date: ScheduleDate(5), timesFree: []),
            Day(date: ScheduleDate(6), timesFree: []),
        ], user: getUser())
        if jsonString != nil {
            userSchedule = Schedule(jsonValue: jsonString!)
            userHasEmptySchedule = false
        }
        return userSchedule
    }
    
    func updateAvailabilityPreview() {
        profileAvailabilityPreview.removeFromSuperview()
        configureAvailabilityPreview()
    }
    
    func configureAvailabilityPreview() {
        profileAvailabilityPreview = ProfileAvailabilityPreview.instanceFromNib(schedules: [getUserAvailability()], emptySchedule: userHasEmptySchedule)!
        profileAvailabilityPreviewContainer.addSubview(profileAvailabilityPreview)
        profileAvailabilityPreview.translatesAutoresizingMaskIntoConstraints = false
        profileAvailabilityPreview.leftAnchor.constraint(equalTo: profileAvailabilityPreviewContainer.leftAnchor).isActive = true
        profileAvailabilityPreview.rightAnchor.constraint(equalTo: profileAvailabilityPreviewContainer.rightAnchor).isActive = true
        profileAvailabilityPreview.bottomAnchor.constraint(equalTo: profileAvailabilityPreviewContainer.bottomAnchor).isActive = true
        profileAvailabilityPreview.topAnchor.constraint(equalTo: profileAvailabilityPreviewContainer.topAnchor).isActive = true
    }
    
    func configureTextFields() {
        firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.text = StoredValues.get(key: StoredValuesConstants.firstName)
        lastNameTextField.text = StoredValues.get(key: StoredValuesConstants.lastName)
    }
    
    func configureProfileIcon() {
        profileIcon.layer.cornerRadius = 55
    }
    
    func configureEditButton() {
        let editIcon: UIImage = ScaledIcon(name: "edit", width: 14, height: 14, color: .label).image
        editButton.setImage(editIcon, for: .normal)
    }
    
    @IBAction func onCreateProfile(_ sender: Any) {
        StoredValues.setIfEmpty(key: StoredValuesConstants.hasBeenOnboarded, value: "yes")
        (delegate as? CreateProfileViewControllerDelegate)?.transitonToNewMeeting(self)
        
        self.dismiss(animated: true, completion: { () -> Void in self.prevController.dismiss(animated: true)})
    }
}

extension CreateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol CreateProfileViewControllerDelegate: AnyObject {
    func transitonToNewMeeting(_ controller: CreateProfileViewController)
}

extension MessagesViewController: CreateProfileViewControllerDelegate {
    // allow this controller to transition to the YourAvailabilities screen
    func transitonToNewMeeting(_ controller: CreateProfileViewController) {
        let newMeetingVC: NewMeetingViewController = instantiateController()
        controller.newMeetingViewController = newMeetingVC
    }
}
