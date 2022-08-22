//
//  AvailabilityBar.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/31/22.
//

import Foundation
import UIKit

final class AvailabilityBar: UIView {
    @IBOutlet weak var verticalStack: UIStackView!
    var performHighlightAction: Bool = true
    
    let hourDivisions: Int = 1
    let startTime: Int = 9
    let endTime: Int = 21
    
    var day: Day = Day(date: CalendarDate("08-15-2022").date, timesFree: [])
    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        nibSetup()
    }
    
    func nibSetup() {
        verticalStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let numberOfBlocks: Int = (hourDivisions * (endTime - startTime))
        
        for i in 0..<numberOfBlocks {
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
            if i == numberOfBlocks - 1 {
                block.addBorders(edges: .bottom, color: AppColors.offBlack)
            }
            block.configure(with: blockString)
            verticalStack.addArrangedSubview(block)
        }
        
        clipsToBounds = true
        layer.cornerRadius = 6
        isUserInteractionEnabled = true
        
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(longPress)
        self.addGestureRecognizer(tap)
    }
    
    class func instanceFromNib() -> AvailabilityBar? {
        return UINib(nibName: "AvailabilityBar", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvailabilityBar
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
