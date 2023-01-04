//
//  AppColors.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/12/22.
//

import UIKit

struct AppColors {
    // main green color
    static let main: UIColor = UIColor.init(red: 143/255, green: 227/255, blue: 202/255, alpha: 1)
    
    // availability selection color in availability bars
    static let availability: UIColor = UIColor.init(red: 39/255, green: 175/255, blue: 134/255, alpha: 1)
    
    // used for borders
    static let offBlack: UIColor = UIColor.label.withAlphaComponent(0.8)
    
    // used to fill availability bars
    static let lightGrey: UIColor = UIColor.label.withAlphaComponent(0.07)
    
    static let backgroundBar: UIColor = UIColor.label.withAlphaComponent(0.03)
    
    // used for availability bar lines
    static let barLines: UIColor = UIColor.label.withAlphaComponent(0.1)
    
    static let shadowColor: UIColor = UIColor.label
    
    static let darkenedScreen: UIColor = UIColor.black.withAlphaComponent(0.4)
    
    
    // The following are progile background colors
    static let redBackground: UIColor = UIColor.init(red: 255/255, green: 169/255, blue: 165/255, alpha: 1)
}
