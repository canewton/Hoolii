//
//  UserAvatar.swift
//  Hoolii MessagesExtension
//
//  Created by Aadam Mirza on 1/7/23.
//

import Foundation
import UIKit

let encodingChars: KeyValuePairs<Int, Character> = [0: "0", 1:"1", 2:"2", 3:"3", 4:"4", 5:"5", 6:"6", 7:"7", 8:"8", 9:"9", 10:"a", 11:"b", 12:"c", 13:"d", 14:"e", 15:"f", 16:"g", 17:"h", 18:"i", 19:"j", 20:"k", 21:"l", 22:"m", 23:"n", 24:"o", 25:"p", 26:"q", 27:"r", 28:"t", 29:"u", 30:"v", 31:"w", 32:"x", 33:"y", 34:"z"]

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
    
    init(avatarEncoded: String) {
        let avatarEncodedArr = Array(avatarEncoded)
        
        self.init(chinIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[0] })!].0, earIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[1] })!].0, browIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[2] })!].0, glassIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[3] })!].0, mouthIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[4] })!].0, noseIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[5] })!].0, hairIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[6] })!].0, skinTone: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[7] })!].0, hairColor: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[8] })!].0, backgroundIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[9] })!].0)
    }
    
    init(randomized: Bool) {
        if randomized == false {
            self.init()
        }
        self.init(chinIndex: Int.random(in: 0..<AvatarConstants.chinOptions.count), earIndex: Int.random(in: 0..<AvatarConstants.earOptions.count), browIndex: Int.random(in: 0..<AvatarConstants.browOptions.count), glassIndex: Int.random(in: 0..<AvatarConstants.eyeOptions.count), mouthIndex: Int.random(in: 0..<AvatarConstants.mouthOptions.count), noseIndex: Int.random(in: 0..<AvatarConstants.noseOptions.count), hairIndex: Int.random(in: 0..<AvatarConstants.hairOptions.count), skinTone: Int.random(in: 0..<AppColors.skintoneArray.count), hairColor: Int.random(in: 0..<AvatarConstants.chinOptions.count), backgroundIndex: Int.random(in: 0..<AvatarConstants.chinOptions.count))
    }
    
    init(jsonValue: String) {
        if jsonValue != "" {
            let dataFromJsonString = jsonValue.data(using: .utf8)!
            self = try! JSONDecoder().decode(Avatar.self, from: dataFromJsonString)
        } else {
            self.init()
        }
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        return String(data: encodedData, encoding: .utf8)!
    }
    
    func encodeAvatar() -> String {
        return "\( encodingChars[chinIndex].1 )\( encodingChars[earIndex].1 )\( encodingChars[browIndex].1 )\( encodingChars[glassIndex].1 )\( encodingChars[mouthIndex].1 )\( encodingChars[noseIndex].1 )\( encodingChars[hairIndex].1 )\( encodingChars[skinTone].1 )\( encodingChars[hairColor].1 )\( encodingChars[backgroundIndex].1 )"
    }
    
    func getShiftConst() -> CGFloat {
        let hairShiftConst = AvatarConstants.hairOptions[hairIndex].hairShift
        let beardShiftConst = AvatarConstants.chinOptions[chinIndex].beardShift
        if hairShiftConst >= 0 && beardShiftConst >= 0 {
            return hairShiftConst > beardShiftConst ? hairShiftConst : beardShiftConst
        } else if hairShiftConst <= 0 && beardShiftConst >= 0 {
            return hairShiftConst + beardShiftConst
        }
        return 0
    }
    
    func toImage(size: CGSize) -> UIImage {
        
        let hairColor = AppColors.hairColorArray[hairColor]
        let skinColor = AppColors.skintoneArray[skinTone]
        
        // create Image context offscreen
        UIGraphicsBeginImageContext(size)

        let areaSize1 = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // draw images into context
        UIImage(named: AvatarConstants.hairOptions[hairIndex].hairBack)?.withTintColor(hairColor).draw(in: areaSize1)
        UIImage(named: "Ear 1 + Head")?.withTintColor(skinColor).draw(in: areaSize1)
        UIImage(named: AvatarConstants.hairOptions[hairIndex].hairMidBack)?.withTintColor(hairColor).draw(in: areaSize1)
        UIImage(named: AvatarConstants.hairOptions[hairIndex].hairMidFront)?.withTintColor(hairColor).draw(in: areaSize1)
        
        let avatarImage1 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let areaSize2 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        avatarImage1?.draw(in: areaSize2)
        UIImage(named: AvatarConstants.browOptions[browIndex].brows)?.draw(in: areaSize2)
        UIImage(named: AvatarConstants.chinOptions[chinIndex].chin)?.withTintColor(skinColor).draw(in: areaSize2)
        UIImage(named: AvatarConstants.eyeOptions[glassIndex].eyes)?.draw(in: areaSize2)
        
        let avatarImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let areaSize3 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        avatarImage2?.draw(in: areaSize3)
        UIImage(named: AvatarConstants.noseOptions[noseIndex].nose)?.draw(in: areaSize3)
        UIImage(named: AvatarConstants.hairOptions[hairIndex].hairFront)?.withTintColor(hairColor).draw(in: areaSize3)
        UIImage(named: AvatarConstants.chinOptions[chinIndex].beard)?.withTintColor(hairColor).draw(in: areaSize3)
        
        let avatarImage3 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let areaSize4 = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        avatarImage3?.draw(in: areaSize4)
        UIImage(named: AvatarConstants.earOptions[earIndex].ears)?.draw(in: areaSize4)
        UIImage(named: AvatarConstants.eyeOptions[glassIndex].glasses)?.draw(in: areaSize4)
        UIImage(named: AvatarConstants.mouthOptions[mouthIndex].mouth)?.draw(in: areaSize4)
        
        let avatarImage4 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return avatar image
        return avatarImage4!
    }
}
