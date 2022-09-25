//
//  TimeIndicatorView.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/21/22.
//

import UIKit

class TimeIndicatorView: UIView {
    @IBOutlet weak var time: UILabel!
    
    class func instanceFromNib() -> TimeIndicatorView? {
        return UINib(nibName: "TimeIndicatorView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? TimeIndicatorView
    }
}
