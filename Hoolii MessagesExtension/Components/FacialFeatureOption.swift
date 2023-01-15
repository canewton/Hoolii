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
    
    var tapCallback: ((FacialFeatureOption) -> Void)!
    
    class func instanceFromNib() -> FacialFeatureOption {
        let facialFeatureOption = UINib(nibName: "FacialFeatureOption", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? FacialFeatureOption
        
        facialFeatureOption?.chin.image = UIImage(named: "Chin 1")
        facialFeatureOption?.face.image = UIImage(named: "Ear 1 + Head")
        
        facialFeatureOption?.chin.tintColor = AppColors.skintoneArray[0]
        facialFeatureOption?.face.tintColor = AppColors.skintoneArray[0]
        facialFeatureOption?.nibSetup()
        
        return facialFeatureOption!
    }
    
    func nibSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunct(tapGestureRecognizer:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapFunct(tapGestureRecognizer: UITapGestureRecognizer) {
        tapCallback(self)
    }
    
    func addChin(_ image: UIImage?) -> FacialFeatureOption {
        chin.image = image
        
        chin.tintColor = AppColors.skintoneArray[0]
        return self
    }
    
    func addNose(_ image: UIImage?) -> FacialFeatureOption {
        nose.image = image
        return self
    }
    
    func addHair(front: UIImage?, back: UIImage?) -> FacialFeatureOption {
        hairFront.image = front
        hairBack.image = back
        
        hairFront.tintColor = AppColors.hairColorArray[0]
        hairBack.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addHair(_ front: UIImage?) -> FacialFeatureOption {
        hairFront.image = front
        
        hairFront.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addHair(front: UIImage?, middle: UIImage?, back: UIImage?) -> FacialFeatureOption {
        hairFront.image = front
        hairBack.image = back
        hairMidBack.image = middle
        
        hairFront.tintColor = AppColors.hairColorArray[0]
        hairBack.tintColor = AppColors.hairColorArray[0]
        hairMidBack.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addHair(front: UIImage?, midFront: UIImage?, midBack: UIImage?, back: UIImage?) -> FacialFeatureOption {
        hairFront.image = front
        hairBack.image = back
        hairMidBack.image = midBack
        hairMidFront.image = midFront
        
        hairFront.tintColor = AppColors.hairColorArray[0]
        hairBack.tintColor = AppColors.hairColorArray[0]
        hairMidBack.tintColor = AppColors.hairColorArray[0]
        hairMidFront.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addEyes(_ image: UIImage?) -> FacialFeatureOption {
        eyes.image = UIImage(named: "Eyes 1")
        glasses.image = image
        return self
    }
    
    func addBeard(_ image: UIImage?) -> FacialFeatureOption {
        beard.image = image
        
        beard.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addEars(_ image: UIImage?) -> FacialFeatureOption {
        ears.image = image
        return self
    }
    
    func addBrows(_ image: UIImage?) -> FacialFeatureOption {
        brows.image = image
        
        brows.tintColor = AppColors.hairColorArray[0]
        return self
    }
    
    func addMouth(_ image: UIImage?) -> FacialFeatureOption {
        mouth.image = image
        return self
    }
}
