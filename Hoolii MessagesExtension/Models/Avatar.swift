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
    
    init(jsonValue: String) {
        let dataFromJsonString = jsonValue.data(using: .utf8)!
        self = try! JSONDecoder().decode(Avatar.self, from: dataFromJsonString)
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        return String(data: encodedData, encoding: .utf8)!
    }
    
//    static func recreateAvatar(size: CGSize, avatarIndices: Avatar) -> UIImage {
//        // Create all of the images
//        let backHairImage = UIImage(named: AvatarConstants.backHairArray[avatarIndices.hairIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
//        let headImage = UIImage(named: "Ear 1 + Head")?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
//        let earImage = UIImage(named: AvatarConstants.earArray[avatarIndices.earIndex])
//        // Consider exceptions for beards
//        var chinImage = UIImage(named: AvatarConstants.chinArray[avatarIndices.chinIndex])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
//        var beardImage = UIImage(named: "transparent")
//        var mouthImage = UIImage(named: AvatarConstants.mouthArray[avatarIndices.mouthIndex])
//        if (avatarIndices.chinIndex > 2) {
//            chinImage = UIImage(named: AvatarConstants.chinArray[1])?.withTintColor(AppColors.skintoneArray[avatarIndices.skinTone])
//            beardImage = UIImage(named: AvatarConstants.chinArray[avatarIndices.chinIndex])
//            mouthImage = UIImage(named: AvatarConstants.mouthArray[0])
//        }
//        let noseImage = UIImage(named: AvatarConstants.noseArray[avatarIndices.noseIndex])
//        let eyeImage = UIImage(named: "Eyes 1")
//        let browImage = UIImage(named: AvatarConstants.browArray[avatarIndices.browIndex])
//        let lensImage = UIImage(named:AvatarConstants.lensArray[avatarIndices.glassIndex])
//        let sideHairImage = UIImage(named:AvatarConstants.hairSideArray[avatarIndices.hairIndex])
//        let frontHairImage = UIImage(named:AvatarConstants.frontHairArray[avatarIndices.hairIndex])
//        let hairTieImage = UIImage(named: AvatarConstants.hairTieArray[avatarIndices.hairIndex])
//        let frameImage = UIImage(named: AvatarConstants.frameArray[avatarIndices.glassIndex])
//
//        // create Image context offscreen
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//
//        // draw images into context
//        backHairImage?.draw(at: .zero)
//        headImage?.draw(at: .zero)
//        earImage?.draw(at: .zero)
//        chinImage?.draw(at: .zero)
//        beardImage?.draw(at: .zero)
//        noseImage?.draw(at: .zero)
//        mouthImage?.draw(at: .zero)
//        eyeImage?.draw(at: .zero)
//        browImage?.draw(at: .zero)
//        lensImage?.draw(at: .zero)
//        sideHairImage?.draw(at: .zero)
//        frontHairImage?.draw(at: .zero)
//        hairTieImage?.draw(at: .zero)
//        frameImage?.draw(at: .zero)
//
//        // Obtain image and end context
//        let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        // Return avatar image
//        return avatarImage!
//    }
}
