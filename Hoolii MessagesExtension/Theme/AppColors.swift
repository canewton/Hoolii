//
//  AppColors.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/12/22.
//

import UIKit

struct AppColors {
    // main green color
    static let main: UIColor = UIColor(named: "main")!
    
    // availability selection color in availability bars
    static let availability: UIColor = UIColor.init(red: 39/255, green: 175/255, blue: 134/255, alpha: 1)
    
    // used for borders
    static let offBlack: UIColor = UIColor.label.withAlphaComponent(0.8)
    
    static let lightGrey: UIColor = UIColor(named: "lightGrey")!
    
    static let backgroundBar: UIColor = UIColor(named: "backgroundBar")!
    
    static let availabilityBar: UIColor = UIColor(named: "availabilityBar")!
    
    // used for availability bar lines
    static let barLines: UIColor = UIColor.label.withAlphaComponent(0.1)
    
    static let shadowColor: UIColor = UIColor.label
    
    static let darkenedScreen: UIColor = UIColor.black.withAlphaComponent(0.4)
    
    static let alert: UIColor = UIColor(named: "alert")!
    
    // The following are profile background colors
    static let redBackground: UIColor = UIColor.init(red: 255/255, green: 169/255, blue: 165/255, alpha: 1)
    
    static let backgroundColorArray = [
        UIColor(red: 255/255.0, green: 169/255.0, blue: 165/255.0, alpha: 1.0),
        UIColor(red: 254/255.0, green: 215/255.0, blue: 160/255.0, alpha: 1.0),
        UIColor(red: 254/255.0, green: 232/255.0, blue: 158/255.0, alpha: 1.0),
        UIColor(red: 187/255.0, green: 238/255.0, blue: 195/255.0, alpha: 1.0),
        UIColor(red: 179/255.0, green: 215/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 202/255.0, green: 187/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 227/255.0, green: 190/255.0, blue: 246/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 215/255.0, blue: 225/255.0, alpha: 1.0),
        UIColor(red: 162/255.0, green: 226/255.0, blue: 207/255.0, alpha: 1.0),
        UIColor(red: 163/255.0, green: 225/255.0, blue: 233/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 227/255.0, blue: 194/255.0, alpha: 1.0),
        UIColor(red: 247/255.0, green: 196/255.0, blue: 227/255.0, alpha: 1.0)
    ]
    
    
}
