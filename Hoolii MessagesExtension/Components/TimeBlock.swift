//
//  TimeBlock.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class TimeBlock: UIView {
    let activeColor: UIColor = AppColors.availability
    let inactiveColor: UIColor = UIColor.clear
    var isActive: Bool = false
    let minHeight: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = inactiveColor
        heightAnchor.constraint(equalToConstant: CGFloat(AvailabilityConstants.blockHeight)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func undoHighlight() {
        backgroundColor = inactiveColor
        isActive = false
    }
    
    // highlight the time block for the user view
    func highlight() {
        backgroundColor = activeColor
        isActive = true
    }
    
    // highlight the time block for the group view
    func highlight(numPeople: Int, totalPeople: Int) {
        backgroundColor = activeColor.withAlphaComponent((CGFloat(numPeople))/(CGFloat(totalPeople)))
    }
    
    func isHighlighted() -> Bool {
        return isActive
    }
}
