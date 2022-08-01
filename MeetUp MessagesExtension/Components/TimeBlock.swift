//
//  TimeBlock.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class TimeBlock: UIView {
    let activeColor: UIColor = UIColor.systemRed
    let inactiveColor: UIColor = UIColor.clear
    var isActive: Bool = false
    var hover: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //layer.borderWidth = 1
        backgroundColor = inactiveColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func highlight() {
        print(isActive)
        if isActive && !hover {
            backgroundColor = inactiveColor
            isActive = false
        } else if !hover {
            backgroundColor = activeColor
            isActive = true
        }
        hover = true
    }
    
    func resetHoverValue() {
        hover = false
    }
}
