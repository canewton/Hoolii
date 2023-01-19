//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var profileIcon: UIView!
    @IBOutlet weak var profileAvailabilityPreviewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var screenContent: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIView!
    @IBOutlet weak var editAvailabilityButton: UIView!
    var profileAvailabilityPreview: ProfileAvailabilityPreview!
    var newMeetingViewController: NewMeetingViewController!
    var userHasEmptySchedule: Bool = true
    var prevController: UIViewController!
    var dismissCallback: (() -> Void)!
    
    let defaults = UserDefaults.standard
    
    static let storyboardIdentifier = "CreateProfileViewController"
    var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial values of the profile if a profile has not yet been created
        StoredValues.setIfEmpty(key: StoredValuesConstants.firstName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.lastName, value: "")
        StoredValues.setIfEmpty(key: StoredValuesConstants.userID, value: makeID(length: 20))
        
        backButton.configure(viewController: self)
        
        configureAvailabilityPreview()
        configureProfileIcon()
        configureNameLabel()
        configureEditButtons()
        generateUserAvatar()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: screenContent.bounds.height)
        screenContent.frame.size.width = view.frame.width
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
    
    func configureNameLabel() {
        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName) ?? ""
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName) ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
    }
    
    func configureEditButtons() {
        let editAvailTap = UITapGestureRecognizer(target: self, action: #selector(onEditWeeklyAvailability(gesture: )))
        editAvailabilityButton.addGestureRecognizer(editAvailTap)
        
        let editProfileTap = UITapGestureRecognizer(target: self, action: #selector(onEditProfile(gesture: )))
        editProfileButton.addGestureRecognizer(editProfileTap)
    }
    
    // populate the edit weekly availability screen with the user's weekly availability data
    // navigate to the weekly availability screen
    @objc func onEditWeeklyAvailability(gesture: UITapGestureRecognizer) {
        let weeklyAvailabilityVC = self.storyboard?
            .instantiateViewController(withIdentifier: "WeeklyAvailabilityInputViewController") as! WeeklyAvailabilityInputViewController
        weeklyAvailabilityVC.userSchedule = getUserAvailability()
        weeklyAvailabilityVC.onSaveCallback = updateAvailabilityPreview
        self.transitionToScreen(viewController: weeklyAvailabilityVC)
    }
    
    @objc func onEditProfile(gesture: UITapGestureRecognizer) {
        let avatarCreatorVC = self.storyboard?
            .instantiateViewController(withIdentifier: "AvatarCreatorViewController") as! AvatarCreatorViewController
        avatarCreatorVC.editNameCallback = configureNameLabel
        avatarCreatorVC.editProfileCallback = generateUserAvatar
        self.transitionToScreen(viewController: avatarCreatorVC)
    }
    
    func generateUserAvatar() {
        for _ in 0..<profileIcon.subviews.count {
            profileIcon.subviews[0].removeFromSuperview()
        }
        
        let storedAvatar = StoredValues.get(key: StoredValuesConstants.userAvatar)
        if storedAvatar != nil {
            let avatar = Avatar(jsonValue: storedAvatar!)
            let profileIconContent = (avatar.toFacialFeatureOption())
            let shiftConst = profileIconContent.getShiftConst() * profileIcon.bounds.height
            profileIcon.addSubview(profileIconContent)
            profileIconContent.translatesAutoresizingMaskIntoConstraints = false
            profileIconContent.topAnchor.constraint(equalTo: profileIcon.topAnchor, constant: 8 - shiftConst).isActive = true
            profileIconContent.leftAnchor.constraint(equalTo: profileIcon.leftAnchor, constant: 8).isActive = true
            profileIconContent.rightAnchor.constraint(equalTo: profileIcon.rightAnchor, constant: -8).isActive = true
            profileIconContent.bottomAnchor.constraint(equalTo: profileIcon.bottomAnchor, constant: -8 - shiftConst).isActive = true
            
            profileIcon.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        }
    }
    
    // get the user stored in local storage
    func getUser() -> User {
        let id: String = StoredValues.get(key: StoredValuesConstants.userID)!
        let firstName: String = StoredValues.get(key: StoredValuesConstants.firstName)!
        let lastName: String = StoredValues.get(key: StoredValuesConstants.lastName)!
        return User(id: id, firstName: firstName, lastName: lastName, avatar: Avatar().encodeAvatar())
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
    
    func configureProfileIcon() {
        profileIcon.layer.cornerRadius = 80
    }
}
