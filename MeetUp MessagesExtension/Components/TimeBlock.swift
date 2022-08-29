//
//  TimeBlock.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class TimeBlock: UIView {
    let activeColor: UIColor = AppColors.main
    let inactiveColor: UIColor = UIColor.clear
    var isActive: Bool = false
    let minHeight: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = inactiveColor
        heightAnchor.constraint(equalToConstant: minHeight).isActive = true
        addBorders(edges: .top, color: AppColors.offBlack)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func undoHighlight() {
        backgroundColor = inactiveColor
        isActive = false
    }
    
    func highlight() {
        backgroundColor = activeColor
        isActive = true
    }
    
    func highlight(numPeople: Int, totalPeople: Int) {
        backgroundColor = activeColor.withAlphaComponent((CGFloat(numPeople))/(CGFloat(totalPeople)))
    }
    
    func isHighlighted() -> Bool {
        return isActive
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
}
