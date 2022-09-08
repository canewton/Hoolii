//
//  ProfileAvailabilityPreview.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/1/22.
//

import UIKit

class ProfileAvailabilityPreview: UIView {
    @IBOutlet weak var availabilityHorizontalList: UIStackView!
    var schedule: Schedule!
    var userHasEmptySchedule: Bool!
    var previewContainerHeight: CGFloat!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        if userHasEmptySchedule {
            for _ in 0..<7 {
                let containerView = UIView()
                let view = UIView()
                view.layer.borderWidth = 1
                view.layer.borderColor = AppColors.grey.cgColor
                view.layer.cornerRadius = 3
                containerView.addSubview(view)
                availabilityHorizontalList.addArrangedSubview(view)
            }
        } else {
            let timeBlockHeight: CGFloat = previewContainerHeight/(CGFloat(24))
            for i in 0..<7 {
                let containerView = UIView()
                let view = UIView()
                
                for j in 0..<schedule.datesFree[i].timesFree.count {
                    let timeRange: TimeRange = schedule.datesFree[i].timesFree[j]
                    let availabilityView = UIView()
                    view.addSubview(availabilityView)
                    availabilityView.backgroundColor = AppColors.availability
                    availabilityView.translatesAutoresizingMaskIntoConstraints = false
                    availabilityView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(timeRange.from) * timeBlockHeight).isActive = true
                    availabilityView.heightAnchor.constraint(equalToConstant: CGFloat((timeRange.to - timeRange.from)) * timeBlockHeight).isActive = true
                    availabilityView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                    availabilityView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                    availabilityView.layer.cornerRadius = 3
                    
                    let fromLabel: UILabel = UILabel()
                    let toLabel: UILabel = UILabel()
                    fromLabel.text = getTime(timeRange.from)
                    fromLabel.font = .systemFont(ofSize: 8)
                    toLabel.text = getTime(timeRange.to)
                    toLabel.font = .systemFont(ofSize: 8)
                    availabilityView.addSubview(fromLabel)
                    availabilityView.addSubview(toLabel)
                    fromLabel.translatesAutoresizingMaskIntoConstraints = false
                    toLabel.translatesAutoresizingMaskIntoConstraints = false
                    fromLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 4).isActive = true
                    fromLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                    fromLabel.topAnchor.constraint(equalTo: availabilityView.topAnchor, constant: 4).isActive = true
                    toLabel.leftAnchor.constraint(equalTo: availabilityView.leftAnchor, constant: 4).isActive = true
                    toLabel.rightAnchor.constraint(equalTo: availabilityView.rightAnchor).isActive = true
                    toLabel.bottomAnchor.constraint(equalTo: availabilityView.bottomAnchor, constant: -4).isActive = true
                }
                
                containerView.addSubview(view)
                availabilityHorizontalList.addArrangedSubview(view)
            }
        }
        
        func getTime(_ timeInput: Int) -> String {
            var timeString: String = ""
            if timeInput == 0 || timeInput == 24 {
                timeString = "12 AM"
            } else if timeInput < 12 {
                timeString = "\(timeInput) AM"
            } else if timeInput == 12 {
                timeString = "\(timeInput) PM"
            } else {
                timeString = "\(timeInput - 12) PM"
            }
            return timeString
        }
    }
    
    class func instanceFromNib(schedule: Schedule, userHasEmptySchedule: Bool, previewContainerHeight: CGFloat) -> ProfileAvailabilityPreview? {
        let profileAvailabilityPreview: ProfileAvailabilityPreview? = UINib(nibName: "ProfileAvailabilityPreview", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileAvailabilityPreview
        profileAvailabilityPreview?.schedule = schedule
        profileAvailabilityPreview?.userHasEmptySchedule = userHasEmptySchedule
        profileAvailabilityPreview?.previewContainerHeight = previewContainerHeight
        profileAvailabilityPreview?.setUp()
        return profileAvailabilityPreview
    }
}
