//
//  ProfileAvailabilityPreview.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 9/1/22.
//

import UIKit

class ProfileAvailabilityPreview: UIView {
    @IBOutlet weak var availabilityHorizontalList: UIStackView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        for _ in 0..<7 {
            let containerView = UIView()
            let view = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = AppColors.grey.cgColor
            view.layer.cornerRadius = 5
            containerView.addSubview(view)
            availabilityHorizontalList.addArrangedSubview(view)
        }
    }
}
