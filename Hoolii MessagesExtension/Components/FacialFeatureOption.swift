//
//  FacialFeatureOption.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import UIKit

class FacialFeatureOption: UIView {
    
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
        
        return facialFeatureOption!
    }
    
    class func instanceFromNib() -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        return facialFeatureOption!
    }
    
    func setFromImageCollection(images: AvatarImageCollection) {
//        let mouthPath = Bundle.main.path(forResource: "Mouth", ofType: "png")!
//        chin.image = images.chin == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        face.image = images.head == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        nose.image = images.nose == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        hairFront.image = images.hairFront == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        hairBack.image = images.hairBack == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        beard.image = images.beard == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        ears.image = images.ears == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        glasses.image = images.glasses == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        hairMidBack.image = images.hairMidBack == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        hairMidFront.image = images.hairMidFront == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        brows.image = images.brows == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        mouth.image = images.mouth == "" ? nil : UIImage(contentsOfFile: mouthPath)
//        eyes.image = images.eyes == "" ? nil : UIImage(contentsOfFile: mouthPath)
        
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
    }
    
    func freeMemory() {
        chin.removeFromSuperview()
        chin = nil
        nose.removeFromSuperview()
        nose = nil
        hairFront.removeFromSuperview()
        hairFront = nil
        eyes.removeFromSuperview()
        eyes = nil
        face.removeFromSuperview()
        face = nil
        hairBack.removeFromSuperview()
        hairBack = nil
        beard.removeFromSuperview()
        beard = nil
        ears.removeFromSuperview()
        ears = nil
        glasses.removeFromSuperview()
        glasses = nil
        hairMidBack.removeFromSuperview()
        hairMidBack = nil
        hairMidFront.removeFromSuperview()
        hairMidFront = nil
        brows.removeFromSuperview()
        brows = nil
        mouth.removeFromSuperview()
        mouth = nil
        
//        chin.image = nil
//        nose.image = nil
//        hairFront.image = nil
//        eyes.image = nil
//        face.image = nil
//        hairBack.image = nil
//        beard.image = nil
//        ears.image = nil
//        glasses.image = nil
//        hairMidBack.image = nil
//        hairMidFront.image = nil
//        brows.image = nil
//        mouth.image = nil
    }
}
