//
//  CreateMeetingCalendar.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/21/22.
//

import UIKit
import JTAppleCalendar

// calendar used for creating meetups
class CreateMeetingCalendar: UIViewController, ViewControllerWithIdentifier {
    static let storyboardIdentifier = "CreateMeetingCalendar"
    weak var delegate: AnyObject?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var arrowLeft: UIButton!
    @IBOutlet weak var arrowRight: UIButton!
    let arrowLeftIcon: ScaledIcon = ScaledIcon(name: "chevron-left-solid", width: 15, height: 15, color: .label)
    let arrowRightIcon: ScaledIcon = ScaledIcon(name: "chevron-right-solid", width: 15, height: 15, color: .label)
    
    let formatter = DateFormatter()
    
    var addDateCallback: (() -> Void)!
    var numRows: Int = 6
    
    // Set styling, images, and colors
    override func viewDidLoad() {
        configureCalendar()
        
        if numRows != 1 {
            configureArrowButtons()
        }
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: Date())
    }
    
    func configureCalendar() {
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
    }
    
    func configureArrowButtons() {
        arrowLeft.setImage(arrowLeftIcon.image, for: .normal)
        arrowRight.setImage(arrowRightIcon.image, for: .normal)
    }
    
    @IBAction func OnLeftArrow(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
    @IBAction func OnRightArrow(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.selectedViewLeft.backgroundColor = .clear
        cell.selectedViewRight.backgroundColor = .clear
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth && numRows != 1 {
          cell.dateLabel.textColor = UIColor.label
       } else {
          cell.dateLabel.textColor = UIColor.gray
       }
    }
    
    // make the cell link up with another cell when there are two or more cells selected that are adjacent to each other
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.selectedView.backgroundColor = cellState.isSelected ? AppColors.main : .clear
        cell.selectedView.layer.cornerRadius = 15
        switch cellState.selectedPosition() {
            case .left:
                cell.selectedViewRight.backgroundColor = AppColors.main
                cell.selectedViewLeft.backgroundColor = .clear
            case .middle:
                cell.selectedViewRight.backgroundColor = AppColors.main
                cell.selectedViewLeft.backgroundColor = AppColors.main
            case .right:
                cell.selectedViewRight.backgroundColor = .clear
                cell.selectedViewLeft.backgroundColor = AppColors.main
            case .full:
                cell.selectedViewRight.backgroundColor = .clear
                cell.selectedViewLeft.backgroundColor = .clear
            default: break
        }
    }
}

extension CreateMeetingCalendar: JTAppleCalendarViewDataSource {
    // define the min and max months displayed in the calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var dateComponent = DateComponents()
        dateComponent.month = 12
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)!
        if numRows == 1 {
            heightConstraint.constant = 38
            return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1, generateInDates: .forFirstMonthOnly, generateOutDates: .off, hasStrictBoundaries: false)
        }
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CreateMeetingCalendar: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
       return cell
    }
        
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        CollectiveSchedule.shared.addDate(date)
        addDateCallback()
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        CollectiveSchedule.shared.removeDate(date)
        addDateCallback()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth && numRows != 1 {
          return true
        }
        return false
    }
}
