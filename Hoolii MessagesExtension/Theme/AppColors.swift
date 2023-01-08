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
    
    
    // The following are progile background colors
    static let redBackground: UIColor = UIColor.init(red: 255/255, green: 169/255, blue: 165/255, alpha: 1)
    
    static let skintoneArray = [
        UIColor(red: 63/255.0, green: 39/255.0, blue: 27/255.0, alpha: 1.0),
        
        UIColor(red: 103/255.0, green: 70/255.0, blue: 51/255.0, alpha: 1.0),
        
        UIColor(red: 121/255.0, green: 78/255.0, blue: 69/255.0, alpha: 1.0),
        
        UIColor(red: 122/255.0, green: 82/255.0, blue: 56/255.0, alpha: 1.0),
        
        UIColor(red: 131/255.0, green: 90/255.0, blue: 68/255.0, alpha: 1.0),
        
        UIColor(red: 214/255.0, green: 160/255.0, blue: 122/255.0, alpha: 1.0),
        
        UIColor(red: 214/255.0, green: 163/255.0, blue: 132/255.0, alpha: 1.0),
        
        UIColor(red: 240/255.0, green: 194/255.0, blue: 168/255.0, alpha: 1.0),
        
        UIColor(red: 230/255.0, green: 186/255.0, blue: 157/255.0, alpha: 1.0),
        
        UIColor(red: 245/255.0, green: 211/255.0, blue: 183/255.0, alpha: 1.0),
        
        UIColor(red: 247/255.0, green: 217/255.0, blue: 189/255.0, alpha: 1.0),
        
        UIColor(red: 253/255.0, green: 225/255.0, blue: 204/255.0, alpha: 1.0),
    ]
    
    static let featureColorArray = [
        // Feature deselected:
        UIColor(red: 239/255.0, green: 248/253.0, blue: 245/255.0, alpha: 1.0),
        // Feature Selected
        UIColor(red: 142/255.0, green: 227/255.0, blue: 202/255.0, alpha: 1.0)
    ]
    
}
