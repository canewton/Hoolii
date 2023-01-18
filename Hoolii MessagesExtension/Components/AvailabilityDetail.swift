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
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var sizeIcon: UIImageView!
    @IBOutlet weak var sizeButton: UIView!
    @IBOutlet weak var closeButton: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userListContainer: UIView!
    @IBOutlet weak var bottomHeader: UILabel!
    @IBOutlet weak var numberAvailable: UILabel!
    @IBOutlet weak var bottomHeaderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeaderBottomConstraint: NSLayoutConstraint!
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
        
        layer.shadowColor = AppColors.shadowColor.cgColor
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
    
    func configureTimeRange(timeRange: TimeRange, date: ScheduleDate) {
        timeRangeText.text = "\(timeRange.from.toStringHourMinute()) - \(timeRange.to.toStringHourMinute())"
        
        let calendarDate: CalendarDate = CalendarDate(date.date!)
        dateText.text = "\(calendarDate.getWeekdayAbr()). \(calendarDate.getMonthName()) \(calendarDate.day)"
    }
    
    func createUserIcon(user: User) -> UIView {
        let userContainer: UIView = UIView()
        userContainer.translatesAutoresizingMaskIntoConstraints = false
        
        var profileIcon = ProfileIcon(initials: user.getInitials(), color: AppColors.backgroundColorArray[user.backgroundColor])
        
        if user.avatar != nil {
            profileIcon = ProfileIcon(avatar: user.avatar!)
        }
        
        userContainer.addSubview(profileIcon)
        
        profileIcon.topAnchor.constraint(equalTo: userContainer.topAnchor).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: userContainer.bottomAnchor).isActive = true
        profileIcon.leftAnchor.constraint(equalTo: userContainer.leftAnchor).isActive = true
        profileIcon.rightAnchor.constraint(equalTo: userContainer.rightAnchor).isActive = true
        
        userContainer.layer.cornerRadius = profileIcon.width/2
        userContainer.layer.shadowColor = AppColors.shadowColor.cgColor
        userContainer.layer.shadowOpacity = 0.3
        userContainer.layer.shadowOffset = .zero
        userContainer.layer.shadowRadius = 1
        
        return userContainer
    }
    
    func createIcon(text: String, color: UIColor) -> UIView {
        let iconContainer: UIView = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = ProfileIcon(initials: text, color: color)
        
        iconContainer.addSubview(icon)
        
        icon.topAnchor.constraint(equalTo: iconContainer.topAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: iconContainer.leftAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: iconContainer.rightAnchor).isActive = true
        
        iconContainer.layer.cornerRadius = icon.width/2
        iconContainer.layer.shadowColor = AppColors.shadowColor.cgColor
        iconContainer.layer.shadowOpacity = 0.3
        iconContainer.layer.shadowOffset = .zero
        iconContainer.layer.shadowRadius = 1
        
        return iconContainer
    }
    
    func configureUsers(users: [User]) {
        userList = users
        
        if isCollapsed {
            bottomHeader.text = "\(userList.count)/\(CollectiveSchedule.shared.allSchedules.count) Availabile"
        }
        
        for v in userListContainer.subviews {
            v.removeFromSuperview()
        }
        
        if isCollapsed {
            let maxNumberUsers = 6
            let numIcons = users.count > maxNumberUsers ? maxNumberUsers : users.count
            for i in 0..<numIcons {
                if i == maxNumberUsers - 1 && users.count > maxNumberUsers {
                    let iconContainer: UIView = createIcon(text: "+\(users.count - (maxNumberUsers - 1))", color: .systemGray4)
                    
                    userListContainer.addSubview(iconContainer)
                    
                    iconContainer.topAnchor.constraint(equalTo: userListContainer.topAnchor, constant: 0).isActive = true
                    iconContainer.leftAnchor.constraint(equalTo: userListContainer.leftAnchor, constant: 28.5 * CGFloat(i)).isActive = true
                } else {
                    let userContainer: UIView = createUserIcon(user: users[i])
                    
                    userListContainer.addSubview(userContainer)
                    
                    userContainer.topAnchor.constraint(equalTo: userListContainer.topAnchor, constant: 0).isActive = true
                    userContainer.leftAnchor.constraint(equalTo: userListContainer.leftAnchor, constant: 28.5 * CGFloat(i)).isActive = true
                }
            }
        } else {
            let scrollView: UIScrollView = UIScrollView()
            let userStackList: UIStackView = UIStackView()
            scrollView.addSubview(userStackList)
            userListContainer.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.topAnchor.constraint(equalTo: userListContainer.topAnchor).isActive = true
            scrollView.leftAnchor.constraint(equalTo: userListContainer.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: userListContainer.rightAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: userListContainer.bottomAnchor).isActive = true
            scrollView.isScrollEnabled = true
            scrollView.isUserInteractionEnabled = true
            userStackList.translatesAutoresizingMaskIntoConstraints = false
            userStackList.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            userStackList.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            userStackList.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
            userStackList.distribution = .equalSpacing
            userStackList.spacing = 10
            userStackList.axis = .vertical

            var scrollHeight: CGFloat = 0
            
            for i in 0..<users.count {
                scrollHeight += 60

                let listElem = AvalabilityDetailListElement.instanceFromNib(icon: createUserIcon(user: users[i]), text: "\(users[i].firstName) \(users[i].lastName)")
                listElem.translatesAutoresizingMaskIntoConstraints = false
                listElem.heightAnchor.constraint(equalToConstant: 50).isActive = true

                userStackList.addArrangedSubview(listElem)

                listElem.leftAnchor.constraint(equalTo: userStackList.leftAnchor).isActive = true
                listElem.rightAnchor.constraint(equalTo: userStackList.rightAnchor).isActive = true
            
                self.layoutIfNeeded()
            }
            
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollHeight)
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
            sizeIcon.image = UIImage(systemName: "arrow.down.right.and.arrow.up.left")
            bottomHeader.text = "Who's coming?"
            bottomHeader.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            bottomHeaderTopConstraint.constant = 15
            bottomHeaderBottomConstraint.constant = 15
            numberAvailable.text = "\(userList.count)/\(CollectiveSchedule.shared.allSchedules.count) Available"
        } else {
            heightConstraint.isActive = true
            widthConstraint.isActive = true
            collapseAvailabilityDetail()
            isCollapsed = true
            sizeIcon.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
            bottomHeader.text = "\(userList.count)/\(CollectiveSchedule.shared.allSchedules.count) Available"
            bottomHeader.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            bottomHeaderTopConstraint.constant = 10
            bottomHeaderBottomConstraint.constant = 10
            numberAvailable.text = ""
        }
        configureUsers(users: userList)
    }
}
