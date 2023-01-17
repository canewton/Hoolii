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
    static var avatar: FacialFeatureOption!
    var delegate: AnyObject?
    static var topConstraint: NSLayoutConstraint!
    static var bottomConstraint: NSLayoutConstraint!
    
    // define the dimentions and styling of the profile button
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.widthAnchor.constraint(equalToConstant: CGFloat(ProfileButton.width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(ProfileButton.height)).isActive = true
        
        let storedAvatar = StoredValues.get(key: StoredValuesConstants.userAvatar)
        
        if storedAvatar != nil {
            let avatar = Avatar(jsonValue: storedAvatar!)
            let profileIconContent = (avatar.toFacialFeatureOption())
            self.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
            generateUserAvatar(avatarInput: profileIconContent)
        } else {
            generateUserAvatar(avatarInput: Avatar().toFacialFeatureOption())
        }
        
//        ProfileButton.initials = UILabel(frame: CGRect(x: 14, y: 14, width: ProfileButton.width, height: ProfileButton.height))
//        ProfileButton.initials.font = .systemFont(ofSize: 11, weight: .bold)
//        ProfileButton.initials.text = StoredValues.get(key: StoredValuesConstants.initials)
//        ProfileButton.initials.textColor = .white
//        ProfileButton.initials.textAlignment = .center
//        self.addSubview(ProfileButton.initials)
//
//        ProfileButton.initials.center.x = CGFloat(ProfileButton.width/2)
//        ProfileButton.initials.center.y = CGFloat(ProfileButton.height/2)
        
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
    
    func generateUserAvatar(avatarInput: FacialFeatureOption) {
        ProfileButton.avatar = avatarInput
        for _ in 0..<self.subviews.count {
            self.subviews[0].removeFromSuperview()
        }

        let shiftConst = ProfileButton.avatar.getShiftConst() * self.bounds.height
        self.addSubview(ProfileButton.avatar)
        ProfileButton.avatar.translatesAutoresizingMaskIntoConstraints = false
        ProfileButton.topConstraint = ProfileButton.avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 1 - shiftConst)
        ProfileButton.avatar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        ProfileButton.avatar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        ProfileButton.bottomConstraint = ProfileButton.avatar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1 - shiftConst)
        
        ProfileButton.topConstraint.isActive = true
        ProfileButton.bottomConstraint.isActive = true
    }
}
