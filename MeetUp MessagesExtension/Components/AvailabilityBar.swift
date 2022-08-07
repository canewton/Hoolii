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
    var performHighlightAction: Bool = true
    
    let hourDivisions: Int = 1
    let startTime: Int = 9
    let endTime: Int = 21
    
    var day: Day = Day(dateString: "08-03-2022", timesFree: [])
    
    public func getDay() -> Day {
        return day
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private func indexToTime(index: Int) -> Int {
        return index/hourDivisions + startTime
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalStack = UIStackView(frame: self.bounds)
        verticalStack.distribution = .fillEqually
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.spacing = 1
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        verticalStack.backgroundColor = UIColor.clear
        
        for i in 0..<(hourDivisions * (endTime - startTime)) {
            let block: TimeBlock = TimeBlock()
            var blockString: String = ""
            if i % hourDivisions == 0 {
                let time: Int = indexToTime(index: i) + 1
                if time < 12 {
                    blockString = "  \(time)am"
                } else if time == 12 {
                    blockString = "  \(time)pm"
                } else {
                    blockString = "  \(time - 12)pm"
                }
            }
            block.configure(with: blockString)
            verticalStack.addArrangedSubview(block)
        }
        
        addSubview(verticalStack)
        clipsToBounds = true
        layer.cornerRadius = 8
        isUserInteractionEnabled = true
        
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
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
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let loc = gesture.location(in: self)
            for i in 0..<verticalStack.arrangedSubviews.count {
                let block: UIView = verticalStack.arrangedSubviews[i]
                if block.frame.contains(loc) && block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    
                    if !timeBlock!.isHighlighted() {
                        timeBlock!.highlight()
                        day.addAvailability(indexToTime(index: i))
                    } else {
                        timeBlock!.undoHighlight()
                        day.removeAvailability(indexToTime(index: i))
                    }
                }
            }
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .ended || gesture.state == .began {
            // get the location of the gesture
            let loc = gesture.location(in: self)
            // loop through each label to see if its frame contains the gesture point
            for i in 0..<verticalStack.arrangedSubviews.count {
                let block: UIView = verticalStack.arrangedSubviews[i]
                if block is TimeBlock {
                    let timeBlock = block as? TimeBlock
                    
                    if block.frame.contains(loc) {
                        if gesture.state == .began && timeBlock!.isHighlighted(){
                            performHighlightAction = false
                        } else if gesture.state == .began && !timeBlock!.isHighlighted() {
                            performHighlightAction = true
                        }
                        
                        if performHighlightAction {
                            timeBlock!.highlight()
                            day.addAvailability(indexToTime(index: i))
                        } else {
                            timeBlock!.undoHighlight()
                            day.removeAvailability(indexToTime(index: i))
                        }
                    }
                }
            }
        }
    }
}
