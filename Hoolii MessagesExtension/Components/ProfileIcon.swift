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
    }
    
    convenience init(avatar: Avatar, height: CGFloat = 40, width: CGFloat = 40) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.height = height
        self.width = width
        
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        layer.cornerRadius = CGFloat(height/2)
        
        let profileIconContent = (avatar.toFacialFeatureOption())
        self.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        generateUserAvatar(avatarInput: profileIconContent)
    }
    
    convenience init(initials: String, color: UIColor, height: CGFloat = 40, width: CGFloat = 40) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.height = height
        self.width = width
        
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        layer.cornerRadius = CGFloat(height/2)
        
        let initialsLabel = UILabel(frame: CGRect(x: 14, y: 14, width: width, height: height))
        initialsLabel.font = .systemFont(ofSize: 14 + (height - 40)/2, weight: .semibold)
        initialsLabel.text = initials
        initialsLabel.textColor = .white
        initialsLabel.textAlignment = .center
        self.addSubview(initialsLabel)
        
        backgroundColor = color

        initialsLabel.center.x = CGFloat(width/2)
        initialsLabel.center.y = CGFloat(height/2)
    }
    
    func generateUserAvatar(avatarInput: FacialFeatureOption) {
        avatarDisplay = avatarInput
        for _ in 0..<self.subviews.count {
            self.subviews[0].removeFromSuperview()
        }

        let shiftConst = avatarDisplay.getShiftConst() * height
        print("shiftConst: \(shiftConst) height: \(height)")
        self.addSubview(avatarDisplay)
        avatarDisplay.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = avatarDisplay.topAnchor.constraint(equalTo: self.topAnchor, constant: (1/100) * pow(height, 5.0/4.0) - shiftConst)
        avatarDisplay.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        avatarDisplay.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        bottomConstraint = avatarDisplay.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (-1/100) * pow(height, 5.0/4.0) - shiftConst)
        
        topConstraint.isActive = true
        bottomConstraint.isActive = true
    }
}
