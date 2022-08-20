//
//  NewMeetingViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit
import JTAppleCalendar

class NewMeetingViewController: AdaptsToKeyboard, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "NewMeetingViewController"
    weak var delegate: AnyObject?
    var yourAvailabiliesViewController: YourAvailabilitiesViewController?
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var arrowLeft: UIButton!
    @IBOutlet weak var arrowRight: UIButton!
    @IBOutlet weak var fromDropDown: AppDropDown!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopContraint: NSLayoutConstraint!
    let arrowLeftIcon: ScaledIcon = ScaledIcon(name: "chevron-left-solid", width: 15, height: 15)
    let arrowRightIcon: ScaledIcon = ScaledIcon(name: "chevron-right-solid", width: 15, height: 15)
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    let formatter = DateFormatter()
    var collectiveSchedule: CollectiveSchedule!
    var userSchedule: ScheduleSendable!
    
    @IBAction func sliderChange(_ sender: Any) {
        slider.setValue(slider.value.rounded(.down), animated: false)
        sliderLabel.text = slider.value.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserSchedule()
        configureCalendar()
        configureArrowButtons()
        configureMainViewConstraints()
        fromDropDown.configure(options: ["hi", "bye"])
    }
    
    @IBAction func OnSetTimeframe(_ sender: Any) {
        (delegate as? NewMeetingViewControllerDelegate)?.transitonToYourAvailabilities(self)
        print(userSchedule!.schedule.datesFree)
        self.transitionToScreen(viewController: yourAvailabiliesViewController!)
    }
    
    
    @IBAction func OnLeftArrow(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
    @IBAction func OnRightArrow(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }
    
    func configureUserSchedule() {
        let username: String = StoredValues.get(key: StoredValuesConstants.username)!
        let userID: String = StoredValues.get(key: StoredValuesConstants.userID)!
        let user: User = User(id: userID, name: username)
        userSchedule = ScheduleSendable(datesFree: [], user: user)
    }
    
    func configureCalendar() {
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
    }
    
    func configureMainViewConstraints() {
        mainViewBottomConstraint.isActive = true
        super.configure(bottomConstraint: mainViewBottomConstraint, topConstraint: mainViewTopContraint)
    }
    
    func configureArrowButtons() {
        arrowLeft.setImage(arrowLeftIcon.image, for: .normal)
        arrowRight.setImage(arrowRightIcon.image, for: .normal)
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
        formatter.dateFormat = "yyyyMMdd"
        let dateWithoutTime = formatter.date(from: formatter.string(from: Date()))!
        
        if cellState.dateBelongsTo == .thisMonth && cellState.date >= dateWithoutTime {
          cell.dateLabel.textColor = UIColor.black
       } else {
          cell.dateLabel.textColor = UIColor.gray
       }
    }
    
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

extension NewMeetingViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var dateComponent = DateComponents()
        dateComponent.month = 12
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension NewMeetingViewController: JTAppleCalendarViewDelegate {
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
        userSchedule.schedule.addDate(date)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        userSchedule.schedule.removeDate(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        formatter.dateFormat = "yyyyMMdd"
        let dateWithoutTime = formatter.date(from: formatter.string(from: Date()))!
        
        if cellState.dateBelongsTo == .thisMonth && cellState.date >= dateWithoutTime {
          return true
        }
        return false
    }
}



protocol NewMeetingViewControllerDelegate: AnyObject {
    func transitonToYourAvailabilities(_ controller: NewMeetingViewController)
}

extension MessagesViewController: NewMeetingViewControllerDelegate {
    func transitonToYourAvailabilities(_ controller: NewMeetingViewController) {
        let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
        controller.yourAvailabiliesViewController = yourAvailabilitiesController
    }
}
