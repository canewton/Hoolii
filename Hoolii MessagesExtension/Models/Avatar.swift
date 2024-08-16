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
}
