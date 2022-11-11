//
//  ProfileButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/14/22.
//

import UIKit

public class ProfileButton: UIView {
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var callback: (() -> Void)?
    static var viewController: AppViewController!
    static var initials: UILabel!
    
    // define the dimentions and styling of the profile button
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.widthAnchor.constraint(equalToConstant: 28).isActive = true
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        ProfileButton.initials = UILabel(frame: CGRect(x: 14, y: 14, width: 28, height: 28))
        ProfileButton.initials.font = .systemFont(ofSize: 11, weight: .bold)
        ProfileButton.initials.text = StoredValues.get(key: StoredValuesConstants.initials)
        ProfileButton.initials.textColor = .white
        ProfileButton.initials.textAlignment = .center
        self.addSubview(ProfileButton.initials)
        
        ProfileButton.initials.center.x = 14
        ProfileButton.initials.center.y = 14
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = 14
    }
    
    static func configure(viewController: AppViewController) {
        self.viewController = viewController
    }
    
    // transition to the profile screen when this button is pressed
    @objc func onPressed() {
        print("pressed")
        let profileVC = ProfileButton.viewController.storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        ProfileButton.viewController.transitionToScreen(viewController: profileVC)
        if callback != nil {
            callback!()
        }
    }
}
