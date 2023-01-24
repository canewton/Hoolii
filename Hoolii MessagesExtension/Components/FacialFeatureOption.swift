//
//  FacialFeatureOption.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

final class FacialFeatureOption: UIView {
    
    @IBOutlet weak var chin: UIImageView!
    @IBOutlet weak var nose: UIImageView!
    @IBOutlet weak var hairFront: UIImageView!
    @IBOutlet weak var eyes: UIImageView!
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var hairBack: UIImageView!
    @IBOutlet weak var beard: UIImageView!
    @IBOutlet weak var ears: UIImageView!
    @IBOutlet weak var glasses: UIImageView!
    @IBOutlet weak var hairMidBack: UIImageView!
    @IBOutlet weak var hairMidFront: UIImageView!
    @IBOutlet weak var brows: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    var hairShiftConst: CGFloat = 0
    var beardShiftConst: CGFloat = 0
    
    class func instanceFromNib(images: AvatarImageCollection) -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        facialFeatureOption?.setFromImageCollection(images: images)
        
        facialFeatureOption?.chin.tintColor = AppColors.skintoneArray[0]
        facialFeatureOption?.face.tintColor = AppColors.skintoneArray[0]
        
        return facialFeatureOption!
    }
    
    class func instanceFromNib() -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        facialFeatureOption?.chin.tintColor = AppColors.skintoneArray[0]
        facialFeatureOption?.face.tintColor = AppColors.skintoneArray[0]
        
        return facialFeatureOption!
    }
    
    func setHairColor(color: UIColor) {
        hairBack.tintColor = color
        hairFront.tintColor = color
        hairMidBack.tintColor = color
        hairMidFront.tintColor = color
        brows.tintColor = color
        beard.tintColor = color
        
        if hairMidFront.image == UIImage(named: "Male hair 7 side") {
            hairMidFront.tintColor = adjustedColorForColor(c: color, percent: 0.6)
        }
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
    
    func setSkinColor(color: UIColor) {
        chin.tintColor = color
        face.tintColor = color
    }
    
    func setFromImageCollection(images: AvatarImageCollection) {
        chin.image = images.chin == "" ? nil : UIImage(named: images.chin)
        face.image = images.head == "" ? nil : UIImage(named: images.head)
        nose.image = images.nose == "" ? nil : UIImage(named: images.nose)
        hairFront.image = images.hairFront == "" ? nil : UIImage(named: images.hairFront)
        hairBack.image = images.hairBack == "" ? nil : UIImage(named: images.hairBack)
        beard.image = images.beard == "" ? nil : UIImage(named: images.beard)
        ears.image = images.ears == "" ? nil : UIImage(named: images.ears)
        glasses.image = images.glasses == "" ? nil : UIImage(named: images.glasses)
        hairMidBack.image = images.hairMidBack == "" ? nil : UIImage(named: images.hairMidBack)
        hairMidFront.image = images.hairMidFront == "" ? nil : UIImage(named: images.hairMidFront)
        brows.image = images.brows == "" ? nil : UIImage(named: images.brows)
        mouth.image = images.mouth == "" ? nil : UIImage(named: images.mouth)
        eyes.image = images.eyes == "" ? nil : UIImage(named: images.eyes)
        
        setSkinColor(color: AppColors.skintoneArray[images.skinTone])
        setHairColor(color: AppColors.hairColorArray[images.hairColor])
    }
}
