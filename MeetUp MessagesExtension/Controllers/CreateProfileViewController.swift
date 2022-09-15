//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: AppViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var profileIcon: UIView!
    @IBOutlet weak var profileInitials: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileAvailabilityPreviewContainer: UIView!
    var profileAvailabilityPreview: ProfileAvailabilityPreview!
    var userHasEmptySchedule: Bool = true
    
    let defaults = UserDefaults.standard
    
    static let storyboardIdentifier = "CreateProfileViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
    }
    
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
    
    @IBAction func OnEditWeeklyAvailability(_ sender: Any) {
        let weeklyAvailabilityVC = self.storyboard?
            .instantiateViewController(withIdentifier: "WeeklyAvailabilityInputViewController") as! WeeklyAvailabilityInputViewController
        weeklyAvailabilityVC.userSchedule = getUserAvailability()
        weeklyAvailabilityVC.onSaveCallback = updateAvailabilityPreview
        self.transitionToScreen(viewController: weeklyAvailabilityVC)
    }
    
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
    
    func getUser() -> User {
        let id: String = StoredValues.get(key: StoredValuesConstants.userID)!
        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName)!
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName)!
        return User(id: id, firstName: firstName, lastName: lastName)
    }
    
    func getUserAvailability() -> ScheduleSendable {
        let jsonString: String? = StoredValues.get(key: StoredValuesConstants.userSchedule)
        var userSchedule: ScheduleSendable = ScheduleSendable(datesFree: [
            Day(date: ScheduleDate(0), timesFree: []),
            Day(date: ScheduleDate(1), timesFree: []),
            Day(date: ScheduleDate(2), timesFree: []),
            Day(date: ScheduleDate(3), timesFree: []),
            Day(date: ScheduleDate(4), timesFree: []),
            Day(date: ScheduleDate(5), timesFree: []),
            Day(date: ScheduleDate(6), timesFree: []),
        ], user: getUser())
        if jsonString != nil {
            userSchedule = ScheduleSendable(jsonValue: jsonString!)
            userHasEmptySchedule = false
        }
        return userSchedule
    }
    
    func updateAvailabilityPreview() {
        profileAvailabilityPreview.removeFromSuperview()
        configureAvailabilityPreview()
    }
    
    func configureAvailabilityPreview() {
        profileAvailabilityPreview = ProfileAvailabilityPreview.instanceFromNib(schedules: [getUserAvailability()], userHasEmptySchedule: userHasEmptySchedule, previewContainerHeight: profileAvailabilityPreviewContainer.frame.height)!
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
        let editIcon: UIImage = ScaledIcon(name: "edit", width: 14, height: 14).image
        editButton.setImage(editIcon, for: .normal)
    }
}

extension CreateProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
