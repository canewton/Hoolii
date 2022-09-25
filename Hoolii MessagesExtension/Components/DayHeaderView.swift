//
//  DayHeaderView.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/7/22.
//

import UIKit

class DayHeaderView: UIView {
    @IBOutlet weak var weekdayLabel: UILabel!
    
    class func instanceFromNib() -> DayHeaderView? {
        return UINib(nibName: "DayHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? DayHeaderView
    }
}
