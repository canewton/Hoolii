//
//  AvailabilityBar.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class AvailabilityBar: UIView {
    var verticalStack: UIStackView = UIStackView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalStack = UIStackView(frame: self.bounds)
        verticalStack.distribution = .fillEqually
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        verticalStack.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.31)
        
        for _ in 0..<18 {
            verticalStack.addArrangedSubview(TimeBlock())
        }
        
        addSubview(verticalStack)
        clipsToBounds = true
        layer.cornerRadius = 8
        isUserInteractionEnabled = true
        
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(highlightBlock(gesture:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(highlightBlock(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(longPress)
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    @objc func highlightBlock(gesture: UIGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .ended {
            // get the location of the gesture
            let loc = gesture.location(in: self)
            // loop through each label to see if its frame contains the gesture point
            verticalStack.arrangedSubviews.forEach { block in
                if block.frame.contains(loc) && block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    timeBlock!.highlight()
                } else if block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    timeBlock!.resetHoverValue()
                }
            }
        }
    }
}
