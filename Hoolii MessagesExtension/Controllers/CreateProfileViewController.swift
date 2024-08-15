//
//  CreateProfileViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation

import UIKit

class CreateProfileViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var screenContent: UIView!
    
    static let storyboardIdentifier = "CreateProfileViewController"
    var delegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onEditAvatar(_ sender: Any) {
        let avatarCreatorVC = self.storyboard?
            .instantiateViewController(withIdentifier: "AvatarCreatorViewController") as! AvatarCreatorViewController
        self.transitionToScreen(viewController: avatarCreatorVC)
    }
}
