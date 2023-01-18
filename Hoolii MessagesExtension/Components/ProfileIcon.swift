//
//  ProfileIcon.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/17/23.
//

import UIKit

public class ProfileIcon: UIView {
    var height: CGFloat = 40
    var width: CGFloat = 40
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var avatarDisplay: FacialFeatureOption!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        layer.cornerRadius = CGFloat(height/2)
    }
    
    convenience init(avatar: Avatar) {
        self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let profileIconContent = (avatar.toFacialFeatureOption())
        self.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        generateUserAvatar(avatarInput: profileIconContent)
    }
    
    convenience init(initials: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let initialsLabel = UILabel(frame: CGRect(x: 14, y: 14, width: width, height: height))
        initialsLabel.font = .systemFont(ofSize: 11, weight: .bold)
        initialsLabel.text = initials
        initialsLabel.textColor = .white
        initialsLabel.textAlignment = .center
        self.addSubview(initialsLabel)

        initialsLabel.center.x = CGFloat(width/2)
        initialsLabel.center.y = CGFloat(height/2)
    }
    
    func generateUserAvatar(avatarInput: FacialFeatureOption) {
        avatarDisplay = avatarInput
        for _ in 0..<self.subviews.count {
            self.subviews[0].removeFromSuperview()
        }

        let shiftConst = avatarDisplay.getShiftConst() * self.bounds.height
        self.addSubview(avatarDisplay)
        avatarDisplay.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = avatarDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: 1 - shiftConst)
        avatarDisplay.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        avatarDisplay.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        bottomConstraint = avatarDisplay.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1 - shiftConst)
        
        topConstraint.isActive = true
        bottomConstraint.isActive = true
    }
}
