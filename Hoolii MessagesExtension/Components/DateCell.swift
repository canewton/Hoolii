//
//  DateCell.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/7/22.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var selectedViewLeft: UIView!
    @IBOutlet var selectedViewRight: UIView!
}
