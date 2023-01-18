//
//  UserAvatar.swift
//  Hoolii MessagesExtension
//
//  Created by Aadam Mirza on 1/7/23.
//

import Foundation
import UIKit

struct Avatar: Codable, Equatable {
    // MARK: Properties
    var chinIndex: Int
    var earIndex:  Int
    var browIndex: Int
    var glassIndex: Int
    var mouthIndex: Int
    var noseIndex:  Int
    var hairIndex:  Int
    var skinTone:   Int
    var hairColor:  Int
    var backgroundIndex: Int
    init(chinIndex:Int, earIndex: Int, browIndex: Int, glassIndex: Int , mouthIndex: Int, noseIndex: Int, hairIndex: Int, skinTone:  Int, hairColor: Int, backgroundIndex: Int) {
        self.chinIndex = chinIndex
        self.earIndex = earIndex
        self.browIndex = browIndex
        self.glassIndex = glassIndex
        self.mouthIndex = mouthIndex
        self.noseIndex = noseIndex
        self.hairIndex = hairIndex
        self.skinTone = skinTone
        self.hairColor = hairColor
        self.backgroundIndex = backgroundIndex
    }
    
    init() {
        self.init(chinIndex: 0, earIndex: 0, browIndex: 0, glassIndex: 0, mouthIndex: 0, noseIndex: 0, hairIndex: 8, skinTone: 0, hairColor: 0, backgroundIndex: 0)
    }
    
    init(randomized: Bool) {
        if randomized == false {
            self.init()
        }
        self.init(chinIndex: Int.random(in: 0..<AvatarConstants.chinOptions.count), earIndex: Int.random(in: 0..<AvatarConstants.earOptions.count), browIndex: Int.random(in: 0..<AvatarConstants.browOptions.count), glassIndex: Int.random(in: 0..<AvatarConstants.eyeOptions.count), mouthIndex: Int.random(in: 0..<AvatarConstants.mouthOptions.count), noseIndex: Int.random(in: 0..<AvatarConstants.noseOptions.count), hairIndex: Int.random(in: 0..<AvatarConstants.hairOptions.count), skinTone: Int.random(in: 0..<AppColors.skintoneArray.count), hairColor: Int.random(in: 0..<AvatarConstants.chinOptions.count), backgroundIndex: Int.random(in: 0..<AvatarConstants.chinOptions.count))
    }
    
    init(jsonValue: String) {
        let dataFromJsonString = jsonValue.data(using: .utf8)!
        self = try! JSONDecoder().decode(Avatar.self, from: dataFromJsonString)
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        return String(data: encodedData, encoding: .utf8)!
    }
    
    func toFacialFeatureOption() -> FacialFeatureOption {
        let facialFeatureOption = FacialFeatureOption.instanceFromNib()
        
        facialFeatureOption.chin.image = AvatarConstants.chinOptions[chinIndex].chin.image
        facialFeatureOption.beard.image = AvatarConstants.chinOptions[chinIndex].beard.image
        facialFeatureOption.ears.image = AvatarConstants.earOptions[earIndex].ears.image
        facialFeatureOption.brows.image = AvatarConstants.browOptions[browIndex].brows.image
        facialFeatureOption.eyes.image = AvatarConstants.eyeOptions[glassIndex].eyes.image
        facialFeatureOption.glasses.image = AvatarConstants.eyeOptions[glassIndex].glasses.image
        facialFeatureOption.mouth.image = AvatarConstants.mouthOptions[mouthIndex].mouth.image
        facialFeatureOption.nose.image = AvatarConstants.noseOptions[noseIndex].nose.image
        facialFeatureOption.hairFront.image = AvatarConstants.hairOptions[hairIndex].hairFront.image
        facialFeatureOption.hairBack.image = AvatarConstants.hairOptions[hairIndex].hairBack.image
        facialFeatureOption.hairMidFront.image = AvatarConstants.hairOptions[hairIndex].hairMidFront.image
        facialFeatureOption.hairMidBack.image = AvatarConstants.hairOptions[hairIndex].hairMidBack.image
        
        facialFeatureOption.face.tintColor = AppColors.skintoneArray[skinTone]
        facialFeatureOption.chin.tintColor = AppColors.skintoneArray[skinTone]
        facialFeatureOption.hairBack.tintColor = AppColors.hairColorArray[hairColor]
        facialFeatureOption.hairFront.tintColor = AppColors.hairColorArray[hairColor]
        facialFeatureOption.hairMidBack.tintColor = AppColors.hairColorArray[hairColor]
        facialFeatureOption.hairMidFront.tintColor = AppColors.hairColorArray[hairColor]
        facialFeatureOption.brows.tintColor = AppColors.hairColorArray[hairColor]
        facialFeatureOption.beard.tintColor = AppColors.hairColorArray[hairColor]
        
        facialFeatureOption.hairShiftConst = AvatarConstants.hairOptions[hairIndex].hairShiftConst
        facialFeatureOption.beardShiftConst = AvatarConstants.chinOptions[chinIndex].beardShiftConst
        
        return facialFeatureOption
    }
}
