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
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.widthAnchor.constraint(equalToConstant: 28).isActive = true
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let initials = UILabel(frame: CGRect(x: 14, y: 14, width: 28, height: 28))
        initials.font = .systemFont(ofSize: 11, weight: .bold)
        initials.text = "CN"
        initials.textColor = .white
        initials.textAlignment = .center
        self.addSubview(initials)
        
        initials.center.x = 14
        initials.center.y = 14
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = 14
    }
    
    static func configure(viewController: AppViewController) {
        self.viewController = viewController
    }
    
    @objc func onPressed() {
        let profileVC = ProfileButton.viewController.storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        ProfileButton.viewController.transitionToScreen(viewController: profileVC)
        if callback != nil {
            callback!()
        }
    }
}
