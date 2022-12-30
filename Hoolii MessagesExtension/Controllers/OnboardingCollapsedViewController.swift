//
//  OnboardingCollapsedViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/30/22.
//

import UIKit

class OnboardingCollapsedViewController: AppViewController, ViewControllerWithIdentifier {
    static let storyboardIdentifier = "OnboardingCollapsedViewController"
    weak var delegate: AnyObject?
    
    @IBAction func onPressStart(_ sender: Any) {
        expandView()
    }
    
    func expandView() {
        (delegate as? OnboardingCollapsedViewControllerDelegate)?.onboardingCollapsedViewControllerDidSelectExpand(self)
    }
}

protocol OnboardingCollapsedViewControllerDelegate: AnyObject {
    func onboardingCollapsedViewControllerDidSelectExpand(_ controller: OnboardingCollapsedViewController)
}

extension MessagesViewController: OnboardingCollapsedViewControllerDelegate {
    // allow the compact preview controller to be expanded
    func onboardingCollapsedViewControllerDidSelectExpand(_ controller: OnboardingCollapsedViewController) {
        requestPresentationStyle(.expanded)
    }
}
