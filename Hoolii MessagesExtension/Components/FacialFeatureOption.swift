//
//  FacialFeatureOption.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

class FacialFeatureOption: UIView {
    
    @IBOutlet weak var avatar: UIImageView!
    
    class func instanceFromNib(images: AvatarImageCollection) -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        facialFeatureOption?.setFromImageCollection(images: images)
        
        return facialFeatureOption!
    }
    
    class func instanceFromNib() -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        return facialFeatureOption!
    }
    
    func adjustedColorForColor( c: UIColor, percent: CGFloat) -> UIColor {
        var r,g,b,a: CGFloat
        r = 0.0
        g = 0.0
        b = 0.0
        a = 0.0

        if c.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r * percent, 0.0), green: max(g * percent, 0.0), blue: max(b * percent, 0.0), alpha: a)
        }

        return UIColor()
    }
    
    func setFromImageCollection(images: AvatarImageCollection) {
        let avatarPath = Bundle.main.path(forResource: images.avatar, ofType: "png")!
        avatar.image = UIImage(contentsOfFile: avatarPath)
    }
    
    func freeMemory() {
        avatar.removeFromSuperview()
        avatar = nil
    }
}
