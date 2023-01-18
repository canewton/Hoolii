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
        ProfileButton.profileIcon.translatesAutoresizingMaskIntoConstraints = false
        ProfileButton.profileIcon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ProfileButton.profileIcon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        ProfileButton.profileIcon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ProfileButton.profileIcon.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = CGFloat(ProfileButton.width/2)
    }
    
    static func configure(viewController: AppViewController) {
        self.viewController = viewController
    }
    
    // transition to the profile screen when this button is pressed
    @objc func onPressed() {
        let profileVC = ProfileButton.viewController.storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        ProfileButton.viewController.transitionToScreen(viewController: profileVC)
        if callback != nil {
            callback!()
        }
    }
}
