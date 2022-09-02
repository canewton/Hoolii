//
//  AvailabilityDetail.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/28/22.
//

import UIKit

class AvailabilityDetail: UIView {
    @IBOutlet weak var timeRangeText: UILabel!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var horizontalUsersList: UIStackView!
    @IBOutlet weak var header: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 15
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        widthAnchor.constraint(equalToConstant: 160).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        header.backgroundColor = AppColors.main
        header.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        header.layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
    }
    
    class func instanceFromNib() -> AvailabilityDetail? {
        return UINib(nibName: "AvailabilityDetail", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvailabilityDetail
    }
}
