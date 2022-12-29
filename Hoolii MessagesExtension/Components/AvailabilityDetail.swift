//
//  AvailabilityDetail.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/28/22.
//

import UIKit

// info block on who is available at a certain time for the group view
class AvailabilityDetail: UIView {
    @IBOutlet weak var timeRangeText: UILabel!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var sizeButton: UIImageView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userListContainer: UIView!
    var closeAvailabilityDetail: (() -> Void)!
    var expandAvailabilityDetail: (() -> Void)!
    var collapseAvailabilityDetail: (() -> Void)!
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var isCollapsed: Bool = true
    var userList: [User]!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        heightConstraint = heightAnchor.constraint(equalToConstant: 160)
        widthConstraint = widthAnchor.constraint(equalToConstant: 200)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        header.backgroundColor = AppColors.main
        header.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        header.layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(handleCloseTapGesture(gesture:)))
        closeTap.numberOfTapsRequired = 1
        closeTap.numberOfTouchesRequired = 1
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(closeTap)
        
        let sizeTap = UITapGestureRecognizer(target: self, action: #selector(handleSizeTapGesture(gesture:)))
        sizeTap.numberOfTapsRequired = 1
        sizeTap.numberOfTouchesRequired = 1
        sizeButton.isUserInteractionEnabled = true
        sizeButton.addGestureRecognizer(sizeTap)
    }
    
    class func instanceFromNib(closeDetail: @escaping (() -> Void), expandDetail: @escaping (() -> Void), collapseDetail: @escaping (() -> Void)) -> AvailabilityDetail? {
        let availabilityDetail = UINib(nibName: "AvailabilityDetail", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? AvailabilityDetail
        availabilityDetail?.closeAvailabilityDetail = closeDetail
        availabilityDetail?.expandAvailabilityDetail = expandDetail
        availabilityDetail?.collapseAvailabilityDetail = collapseDetail
        return availabilityDetail
    }
    
    func configureTimeRange(startTime: HourMinuteTime, endTime: HourMinuteTime) {
        let startTimeHour = "\(startTime.hour % 12 == 0 ? 12 : startTime.hour % 12)"
        let startTimeMinute = String(format: "%02d", startTime.minute)
        let startTimeMeridiam = startTime.hour / 12 == 0 ? "AM" : "PM"
        let endTimeHour = "\(endTime.hour % 12 == 0 ? 12 : endTime.hour % 12)"
        let endTimeMinute = String(format: "%02d", endTime.minute)
        let endTimeMeridiam = endTime.hour / 12 == 0 ? "AM" : "PM"
        timeRangeText.text = "\(startTimeHour):\(startTimeMinute) \(startTimeMeridiam) - \(endTimeHour):\(endTimeMinute) \(endTimeMeridiam)"
    }
    
    func createUserIcon(user: User) -> UIView {
        let userContainer: UIView = UIView()
        let initials: UILabel = UILabel(frame: CGRect(x: 14, y: 14, width: 28, height: 28))
        initials.text = user.getInitials()
        
        userContainer.translatesAutoresizingMaskIntoConstraints = false
        userContainer.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userContainer.layer.cornerRadius = 15
        userContainer.layer.shadowColor = UIColor.black.cgColor
        userContainer.layer.shadowOpacity = 0.3
        userContainer.layer.shadowOffset = .zero
        userContainer.layer.shadowRadius = 1
        userContainer.backgroundColor = AppColors.redBackground
        
        userContainer.addSubview(initials)
        initials.font = .systemFont(ofSize: 11, weight: .bold)
        initials.textColor = .white
        initials.textAlignment = .center
        initials.center.x = 15
        initials.center.y = 15
        
        return userContainer
    }
    
    func configureUsers(users: [User]) {
        userList = users
        
        for v in userListContainer.subviews {
            v.removeFromSuperview()
        }
        
        if isCollapsed {
            for i in 0..<users.count {
                let userContainer: UIView = createUserIcon(user: users[i])
                
                userListContainer.addSubview(userContainer)
                
                userContainer.topAnchor.constraint(equalTo: userListContainer.topAnchor, constant: 0).isActive = true
                userContainer.leftAnchor.constraint(equalTo: userListContainer.leftAnchor, constant: CGFloat(25 * i)).isActive = true
            }
        } else {
            let userStackList: UIStackView = UIStackView()
            userListContainer.addSubview(userStackList)
            userStackList.translatesAutoresizingMaskIntoConstraints = false
            userStackList.topAnchor.constraint(equalTo: userListContainer.topAnchor).isActive = true
            userStackList.leftAnchor.constraint(equalTo: userListContainer.leftAnchor).isActive = true
            userStackList.rightAnchor.constraint(equalTo: userListContainer.rightAnchor).isActive = true
            userStackList.distribution = .equalSpacing
            userStackList.spacing = 10
            userStackList.axis = .vertical
            
            for i in 0..<users.count {
                let userContainer: UIView = createUserIcon(user: users[i])
                let userIconAndNameContainer: UIView = UIView()
                let userFullName: UILabel = UILabel(frame: CGRect(x: 45, y: 0, width: 300, height: 30))
                userFullName.text = "\(users[i].firstName) \(users[i].lastName)"
                print("\(users[i].firstName) \(users[i].lastName)")
                
                userIconAndNameContainer.addSubview(userContainer)
                userIconAndNameContainer.addSubview(userFullName)
                userIconAndNameContainer.backgroundColor = AppColors.lightGrey
                userIconAndNameContainer.layer.cornerRadius = 5
                
                userContainer.topAnchor.constraint(equalTo: userIconAndNameContainer.topAnchor, constant: 8).isActive = true
                userContainer.bottomAnchor.constraint(equalTo: userIconAndNameContainer.bottomAnchor, constant: -8).isActive = true
                userContainer.leftAnchor.constraint(equalTo: userIconAndNameContainer.leftAnchor, constant: 8).isActive = true
                
                userFullName.center.y = 23
                
                userStackList.addArrangedSubview(userIconAndNameContainer)
                
                UIView.animate(withDuration: 0.3, animations: {
                   self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func handleCloseTapGesture(gesture: UITapGestureRecognizer) {
        closeAvailabilityDetail()
    }
    
    @objc func handleSizeTapGesture(gesture: UITapGestureRecognizer) {
        if isCollapsed {
            heightConstraint.isActive = false
            widthConstraint.isActive = false
            expandAvailabilityDetail()
            isCollapsed = false
        } else {
            heightConstraint.isActive = true
            widthConstraint.isActive = true
            collapseAvailabilityDetail()
            isCollapsed = true
        }
        configureUsers(users: userList)
    }
}
