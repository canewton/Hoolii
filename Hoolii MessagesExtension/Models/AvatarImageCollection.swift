//
//  AvatarImageCollection.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/23/23.
//

import Foundation
import UIKit

class AvatarImageCollection {
    var avatar: String
    
    init(avatar: String) {
        self.avatar = avatar
    }
    
    init(avatar: Avatar) {
        self.avatar = AvatarConstants.avatarOptions[avatar.avatarIndex].avatar
    }
    
    init() {
        self.avatar = AvatarConstants.avatarOptions[Int.random(in: 0..<AvatarConstants.avatarOptions.count)].avatar
    }
}
