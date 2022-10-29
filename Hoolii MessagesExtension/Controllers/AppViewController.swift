//
//  AppViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/19/22.
//

import UIKit

// make a class that view controllers inherit from to get the transition to screen function
class AppViewController: UIViewController {
    func transitionToScreen(viewController: UIViewController) {
        let secondVC = viewController
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .coverVertical
        self.present(secondVC, animated:true, completion:nil)
    }
}
