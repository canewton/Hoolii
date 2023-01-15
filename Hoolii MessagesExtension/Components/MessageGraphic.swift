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
            let initials: UILabel = UILabel(frame: CGRect(x: 100, y: 100, width: 80, height: 80))
            initials.text = userArr[i].getInitials()
            initials.font = .systemFont(ofSize: 30, weight: .bold)
            initials.textColor = .white
            initials.textAlignment = .center
            initials.center.x = 15
            initials.center.y = 15
            initials.snapshotView(afterScreenUpdates: true)
            
            let imageView = UIImageView(frame: CGRect(x: 30, y: 30, width: backgroundCircle.bounds.width, height: backgroundCircle.bounds.height))
            imageView.center.x = backgroundCircle.center.x
            imageView.center.y = backgroundCircle.center.y
            imageView.image = imageWithLabel(label: initials)
            addSubview(imageView)
            
            backgroundCircle.frame.size.height -= 0.7
            backgroundCircle.frame.size.width -= 0.7
            backgroundCircle.center.x = circleCenterX
            backgroundCircle.center.y = circleCenterY
            backgroundCircle.tintColor = AppColors.main
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
