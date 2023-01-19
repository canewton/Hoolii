//
//  FacialFeatureSelection.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/15/23.
//

import Foundation

struct FacialFeatureSelection {
    var iconName: String
    var options: [FacialFeatureOption]
    
    init(iconName: String, options: [FacialFeatureOption]) {
        self.iconName = iconName
        self.options = options
    }
}
