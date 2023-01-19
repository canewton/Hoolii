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
    
    static let hairColorArray = [
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
        UIColor(red: 63/255.0, green: 39/255.0, blue: 27/255.0, alpha: 1.0),
        UIColor(red: 83/255.0, green: 56/255.0, blue: 26/255.0, alpha: 1.0),
        UIColor(red: 110/255.0, green: 62/255.0, blue: 24/255.0, alpha: 1.0),
        UIColor(red: 90/255.0, green: 56/255.0, blue: 37/255.0, alpha: 1.0),
        UIColor(red: 134/255.0, green: 68/255.0, blue: 56/255.0, alpha: 1.0),
        UIColor(red: 117/255.0, green: 37/255.0, blue: 10/255.0, alpha: 1.0),
        UIColor(red: 172/255.0, green: 66/255.0, blue: 42/255.0, alpha: 1.0),
        UIColor(red: 205/255.0, green: 130/255.0, blue: 60/255.0, alpha: 1.0),
        UIColor(red: 205/255.0, green: 154/255.0, blue: 80/255.0, alpha: 1.0),
        UIColor(red: 242/255.0, green: 176/255.0, blue: 98/255.0, alpha: 1.0),
        UIColor(red: 251/255.0, green: 231/255.0, blue: 161/255.0, alpha: 1.0),
        UIColor(red: 241/255.0, green: 204/255.0, blue: 143/255.0, alpha: 1.0),
        UIColor(red: 217/255.0, green: 179/255.0, blue: 128/255.0, alpha: 1.0),
        UIColor(red: 200/255.0, green: 159/255.0, blue: 115/255.0, alpha: 1.0),
        UIColor(red: 225/255.0, green: 185/255.0, blue: 134/255.0, alpha: 1.0),
        UIColor(red: 211/255.0, green: 188/255.0, blue: 154/255.0, alpha: 1.0),
        UIColor(red: 152/255.0, green: 136/255.0, blue: 128/255.0, alpha: 1.0),
        UIColor(red: 228/255.0, green: 225/255.0, blue: 206/255.0, alpha: 1.0)
    ]
    
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
