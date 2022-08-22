//
//  DateHeaderView.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/20/22.
//

import UIKit

class DateHeaderView: UIView {
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    class func instanceFromNib() -> DateHeaderView? {
        return UINib(nibName: "DateHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? DateHeaderView
    }
}
