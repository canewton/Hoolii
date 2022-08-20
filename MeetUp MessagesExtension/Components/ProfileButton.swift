//
//  ProfileButton.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/14/22.
//

import UIKit

public class ProfileButton: UIView {
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var viewController: UIViewController!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        tap = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = 14
    }
    
    func configure(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    @objc func onPressed() {
        let profileVC = viewController.storyboard?
            .instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.modalTransitionStyle = .coverVertical
        viewController.present(profileVC, animated:true, completion:nil)
    }
}
