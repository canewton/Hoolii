//
//  AvatarImageCollection.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/23/23.
//

import Foundation
import UIKit

class AvatarImageCollection {
    let head: String = "Ear 1 + Head"
    var chin: String = "Chin 1"
    var nose: String = ""
    var hairFront: String = ""
    var hairBack: String = ""
    var hairMidFront: String = ""
    var hairMidBack: String = ""
    var ears: String = ""
    var eyes: String = ""
    var beard: String = ""
    var brows: String = ""
    var mouth: String = ""
    var glasses: String = ""
    var skinTone: Int = 0
    var hairColor: Int = 0
    var backgroundColor: Int = 0
    var hairShift: CGFloat = 0
    var beardShift: CGFloat = 0
    
    init(chin: String, nose: String, hairFront: String, hairBack: String, hairMidFront: String, hairMidBack: String, ears: String, eyes: String, beard: String, brows: String, mouth: String, glasses: String, skinTone: Int, hairColor: Int, backgroundColor: Int, hairShift: CGFloat, beardShift: CGFloat) {
        self.chin = chin
        self.nose = nose
        self.hairFront = hairFront
        self.hairBack = hairBack
        self.hairMidFront = hairMidFront
        self.hairMidBack = hairMidBack
        self.ears = ears
        self.eyes = eyes
        self.beard = beard
        self.brows = brows
        self.mouth = mouth
        self.glasses = glasses
        self.skinTone = skinTone
        self.hairColor = hairColor
        self.backgroundColor = backgroundColor
        self.hairShift = hairShift
        self.beardShift = beardShift
    }
    
    init(avatar: Avatar) {
        self.chin = AvatarConstants.chinOptions[avatar.chinIndex].chin
        self.nose = AvatarConstants.noseOptions[avatar.noseIndex].nose
        self.hairFront = AvatarConstants.hairOptions[avatar.hairIndex].hairFront
        self.hairBack = AvatarConstants.hairOptions[avatar.hairIndex].hairBack
        self.hairMidBack = AvatarConstants.hairOptions[avatar.hairIndex].hairMidBack
        self.hairMidFront = AvatarConstants.hairOptions[avatar.hairIndex].hairMidFront
        self.ears = AvatarConstants.earOptions[avatar.earIndex].ears
        self.eyes = AvatarConstants.eyeOptions[avatar.glassIndex].eyes
        self.beard = AvatarConstants.chinOptions[avatar.chinIndex].beard
        self.brows = AvatarConstants.browOptions[avatar.browIndex].brows
        self.mouth = AvatarConstants.mouthOptions[avatar.mouthIndex].mouth
        self.glasses = AvatarConstants.eyeOptions[avatar.glassIndex].glasses
        
        self.skinTone = avatar.skinTone
        self.hairColor = avatar.hairColor
    }
    
    init() {}
    
    deinit {
        print("deinit avatar")
    }
    
    @discardableResult func addChin(_ string: String) -> AvatarImageCollection {
        if chin != "" {
            chin = string
        }
        return self
    }
    
    @discardableResult func addNose(_ string: String) -> AvatarImageCollection {
        nose = string
        return self
    }
    
    @discardableResult func addHair(front: String, back: String) -> AvatarImageCollection {
        hairFront = front
        hairBack = back
        return self
    }
    
    @discardableResult func addHair(_ front: String) -> AvatarImageCollection {
        hairFront = front
        return self
    }
    
    @discardableResult func addHair(front: String, middle: String, back: String) -> AvatarImageCollection {
        hairFront = front
        hairBack = back
        hairMidBack = middle
        return self
    }
    
    @discardableResult func addHair(front: String, midFront: String, midBack: String, back: String) -> AvatarImageCollection {
        hairFront = front
        hairBack = back
        hairMidBack = midBack
        hairMidFront = midFront
        return self
    }
    
    @discardableResult func addHair(front: String, back: String, hairShift: CGFloat) -> AvatarImageCollection {
        self.hairShift = hairShift
        return addHair(front: front, back: back)
    }
    
    @discardableResult func addHair(_ front: String, hairShift: CGFloat) -> AvatarImageCollection {
        self.hairShift = hairShift
        return addHair(front)
    }
    
    @discardableResult func addHair(front: String, middle: String, back: String, hairShift: CGFloat) -> AvatarImageCollection {
        self.hairShift = hairShift
        return addHair(front: front, middle: middle, back: back)
    }
    
    @discardableResult func addHair(front: String, midFront: String, midBack: String, back: String, hairShift: CGFloat) -> AvatarImageCollection {
        self.hairShift = hairShift
        return addHair(front: front, midFront: midFront, midBack: midBack, back: back)
    }
    
    @discardableResult func addEyes(_ image: String) -> AvatarImageCollection {
        eyes = "Eyes 1"
        glasses = image
        return self
    }
    
    @discardableResult func addBeard(_ string: String) -> AvatarImageCollection {
        beard = string
        chin = "Chin 2"
        return self
    }
    
    @discardableResult func addBeardAndChin(beard: String, chin: String) -> AvatarImageCollection {
        self.beard = beard
        self.chin = chin
        return self
    }
    
    @discardableResult func addBeard(_ image: String, beardShift: CGFloat) -> AvatarImageCollection {
        self.beardShift = beardShift
        return addBeard(image)
    }
    
    @discardableResult func addBeardAndChin(beard: String, chin: String, beardShift: CGFloat) -> AvatarImageCollection {
        self.beardShift = beardShift
        return addBeardAndChin(beard: beard, chin: chin)
    }
    
    @discardableResult func addEars(_ string: String) -> AvatarImageCollection {
        ears = string
        return self
    }
    
    @discardableResult func addBrows(_ string: String) -> AvatarImageCollection {
        brows = string
        return self
    }
    
    @discardableResult func addMouth(_ string: String) -> AvatarImageCollection {
        mouth = string
        return self
    }
    
    func getShiftConst() -> CGFloat {
        if self.hairShift >= 0 && self.beardShift >= 0 {
            return hairShift > beardShift ? hairShift : beardShift
        } else if hairShift <= 0 && beardShift >= 0 {
            return hairShift + beardShift
        }
        return 0
    }
}
