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
    let inactiveColor: UIColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.31)
    var isActive: Bool = false
    
    private let label: UITextField = {
        let label = UITextField()
        label.textAlignment = .left
        label.textColor = .black
        label.isUserInteractionEnabled = false
        label.contentVerticalAlignment = .bottom
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //layer.borderWidth = 1
        backgroundColor = inactiveColor
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    func undoHighlight() {
        if isActive {
            backgroundColor = inactiveColor
            isActive = false
        }
    }
    
    func highlight() {
        if !isActive {
            backgroundColor = activeColor
            isActive = true
        }
    }
    
    func isHighlighted() -> Bool {
        return isActive
    }
}
