//
//  ProfileButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/14/22.
//

import UIKit

public class ProfileButton: UIView {
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var callback: (() -> Void)?
    static var viewController: AppViewController!
    static let height: CGFloat = 40
    static let width: CGFloat = 40
    var delegate: AnyObject?
    static var profileIcon: ProfileIcon!
    
    // define the dimentions and styling of the profile button
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let storedAvatar = StoredValues.get(key: StoredValuesConstants.userAvatar)
        
        if storedAvatar != nil {
            ProfileButton.profileIcon = ProfileIcon(avatar: Avatar(jsonValue: storedAvatar!))
        } else {
            ProfileButton.profileIcon = ProfileIcon(avatar: Avatar())
        }
        
        addSubview(ProfileButton.profileIcon)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        ProfileButton.profileIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ProfileButton.profileIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = CGFloat(ProfileButton.width/2)
    }
    
    static func configure(viewController: AppViewController) {
        self.viewController = viewController
    }
    
    // transition to the profile screen when this button is pressed
    @objc func onPressed() {
        delegate = (ProfileButton.viewController as! ViewControllerWithIdentifier).delegate
        let profileVC: CreateProfileViewController = (delegate as! ProfileButtonDelegate).getProfileVC()
        ProfileButton.viewController.transitionToScreen(viewController: profileVC)
        if callback != nil {
            callback!()
        }
    }
}

protocol ProfileButtonDelegate: AnyObject {
    func getProfileVC() -> CreateProfileViewController
}

extension MessagesViewController: ProfileButtonDelegate {
    // allow this controller to transition to the YourAvailabilities screen
    func getProfileVC() -> CreateProfileViewController {
        let profileVC: CreateProfileViewController = instantiateController()
        return profileVC
    }
}
