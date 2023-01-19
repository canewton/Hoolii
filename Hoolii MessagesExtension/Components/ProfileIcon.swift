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
    var avatar: Avatar?
    var avatarDisplay: FacialFeatureOption?
    
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
        self.avatar = avatar
        
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        layer.cornerRadius = CGFloat(height/2)
        
        let profileIconContent = (avatar.toFacialFeatureOption())
        self.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        generateUserAvatar(avatarInput: profileIconContent)
    }
    
    convenience init(avatar: Avatar, userID: String, height: CGFloat = 40, width: CGFloat = 40) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.height = height
        self.width = width
        self.avatar = avatar
        
        self.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        layer.cornerRadius = CGFloat(height/2)
        
        self.backgroundColor = AppColors.backgroundColorArray[avatar.backgroundIndex]
        generateUserAvatarImage(avatarInput: avatar, userID: userID)
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

        let shiftConst = avatarInput.getShiftConst() * height
        self.addSubview(avatarInput)
        avatarInput.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = avatarInput.topAnchor.constraint(equalTo: self.topAnchor, constant: (1/30) * pow(height, 5.0/4.0) - shiftConst)
        avatarInput.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        avatarInput.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        bottomConstraint = avatarInput.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (-1/30) * pow(height, 5.0/4.0) - shiftConst)
        
        topConstraint.isActive = true
        bottomConstraint.isActive = true
    }
    
    func generateUserAvatarImage(avatarInput: Avatar, userID: String) {
        let avatarImage = UIImageView()
        avatarImage.image = findAvatarImageInMemory(userID: userID)
        avatarImage.contentMode = .scaleAspectFit
        
        let shiftConst = avatarInput.getShiftConst() * height
        addSubview(avatarImage)
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = avatarImage.topAnchor.constraint(equalTo: self.topAnchor, constant: (1/30) * pow(height, 5.0/4.0) - shiftConst)
        avatarImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        avatarImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1).isActive = true
        bottomConstraint = avatarImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (-1/30) * pow(height, 5.0/4.0) - shiftConst)
        
        topConstraint.isActive = true
        bottomConstraint.isActive = true
    }
    
    
    func findAvatarImageInMemory(userID: String) -> UIImage? {
        for i in 0..<ImageStorage.avatarImages.count {
            if ImageStorage.avatarImages[i].userID == userID {
                return ImageStorage.avatarImages[i].avatarImage
            }
        }
        return nil
    }
}
