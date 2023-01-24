//
//  FacialFeatureSelection.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import Foundation

struct FacialFeatureSelection {
    var iconName: String
    var options: [AvatarImageCollection]
    
    init(iconName: String, options: [AvatarImageCollection]) {
        self.iconName = iconName
        self.options = options
    }
}
