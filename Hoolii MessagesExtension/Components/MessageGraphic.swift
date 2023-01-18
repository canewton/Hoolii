//
//  MessageGraphic.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/4/23.
//

import UIKit

final class MessageGraphic: UIView {
    var userArr: [User] = []
    
    func convertToImage() -> UIImage? {
        for i in 0..<userArr.count {
            let backgroundCircle: UIImageView = self.subviews[i + 1] as! UIImageView
            let circleCenterX = backgroundCircle.center.x
            let circleCenterY = backgroundCircle.center.y
            
            var profileIcon = ProfileIcon(initials: userArr[i].getInitials(), color: AppColors.backgroundColorArray[userArr[i].backgroundColor], height: 100, width: 100)
            
            if userArr[i].avatar != nil {
                profileIcon = ProfileIcon(avatar: userArr[i].avatar!, height: 100, width: 100)
            }
            
            profileIcon.layoutIfNeeded()
            
            let imageView = UIImageView(frame: CGRect(x: 30, y: 30, width: backgroundCircle.bounds.width - 10, height: backgroundCircle.bounds.height - 10))
            imageView.contentMode = .scaleAspectFit
            imageView.center.x = backgroundCircle.center.x
            imageView.center.y = backgroundCircle.center.y
            imageView.image = imageFromAvatar(icon: profileIcon)
            addSubview(imageView)
            
            backgroundCircle.frame.size.height -= 10
            backgroundCircle.frame.size.width -= 10
            backgroundCircle.center.x = circleCenterX
            backgroundCircle.center.y = circleCenterY
            //backgroundCircle.tintColor = AppColors.main
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
          layer.render(in: rendererContext.cgContext)
        }
    }
    
    func imageWithLabel(label: UILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func imageFromAvatar(icon: ProfileIcon) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0.0)
        icon.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    class func instanceFromNib() -> MessageGraphic? {
        var numPeople = CollectiveSchedule.shared.allSchedules.count
        numPeople = numPeople > 15 ? 15 : numPeople
        var userArr: [User] = []
        for i in 0..<numPeople {
            userArr.append(CollectiveSchedule.shared.allSchedules[i].user)
        }
        let messageGraphic = UINib(nibName: "MessageGraphic\(numPeople)People", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? MessageGraphic
        messageGraphic?.userArr = userArr
        return messageGraphic
    }
}
