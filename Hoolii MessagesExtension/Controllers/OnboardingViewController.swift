//
//  OnboardingViewController.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 12/30/22.
//

import UIKit

class OnboardingViewController: AppViewController, ViewControllerWithIdentifier {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UILabel!
    @IBOutlet weak var backButton: UILabel!
    var profileViewController: AvatarCreatorViewController!
    static let storyboardIdentifier = "OnboardingViewController"
    weak var delegate: AnyObject?
    let numPages: Int = 3
    var currentPage = 0
    var loadedSubviews = false
    var prevController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.pageIndicatorTintColor = AppColors.lightGrey
        pageControl.currentPageIndicatorTintColor = AppColors.main
        pageControl.numberOfPages = numPages
        self.view.backgroundColor = AppColors.alert
        
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(onNext(gesture:)))
        nextTap.numberOfTapsRequired = 1
        nextTap.numberOfTouchesRequired = 1
        nextButton.addGestureRecognizer(nextTap)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(onBack(gesture:)))
        backTap.numberOfTapsRequired = 1
        backTap.numberOfTouchesRequired = 1
        backButton.addGestureRecognizer(backTap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !loadedSubviews {
            scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(numPages), height: scrollView.frame.size.height)
            
            let page1 = UINib(nibName: "OnboardingScreen1", bundle: nil).instantiate(withOwner: OnboardingViewController.self, options: nil)[0] as! UIView
            
            let page2 = UINib(nibName: "OnboardingScreen2", bundle: nil).instantiate(withOwner: OnboardingViewController.self, options: nil)[0] as! UIView
            
            let page3 = UINib(nibName: "OnboardingScreen3", bundle: nil).instantiate(withOwner: OnboardingViewController.self, options: nil)[0] as! UIView
            
            let page1container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            let page2container = UIView(frame: CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            let page3container = UIView(frame: CGRect(x: view.frame.size.width * 2, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            
            page1container.addSubview(page1)
            page2container.addSubview(page2)
            page3container.addSubview(page3)
            
            page1.translatesAutoresizingMaskIntoConstraints = false
            page1.topAnchor.constraint(equalTo: page1container.topAnchor).isActive = true
            page1.bottomAnchor.constraint(equalTo: page1container.bottomAnchor).isActive = true
            page1.leftAnchor.constraint(equalTo: page1container.leftAnchor).isActive = true
            page1.rightAnchor.constraint(equalTo: page1container.rightAnchor).isActive = true
            
            page2.translatesAutoresizingMaskIntoConstraints = false
            page2.topAnchor.constraint(equalTo: page2container.topAnchor).isActive = true
            page2.bottomAnchor.constraint(equalTo: page2container.bottomAnchor).isActive = true
            page2.leftAnchor.constraint(equalTo: page2container.leftAnchor).isActive = true
            page2.rightAnchor.constraint(equalTo: page2container.rightAnchor).isActive = true
            
            page3.translatesAutoresizingMaskIntoConstraints = false
            page3.topAnchor.constraint(equalTo: page3container.topAnchor).isActive = true
            page3.bottomAnchor.constraint(equalTo: page3container.bottomAnchor).isActive = true
            page3.leftAnchor.constraint(equalTo: page3container.leftAnchor).isActive = true
            page3.rightAnchor.constraint(equalTo: page3container.rightAnchor).isActive = true
            
            scrollView.addSubview(page1container)
            scrollView.addSubview(page2container)
            scrollView.addSubview(page3container)
            loadedSubviews = true
        }
    }
    
    @objc func onBack(gesture: UITapGestureRecognizer) {
        if currentPage == numPages - 1 {
            nextButton.text = "Next"
            nextButton.textColor = .label
            nextButtonWidth.constant = 65
        }
        if currentPage > 0 {
            currentPage -= 1
            scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(currentPage), y: 0), animated: true)
            pageControl.currentPage = currentPage
        }
    }
    
    @objc func onNext(gesture: UITapGestureRecognizer) {
        if currentPage == numPages - 1 {
            (delegate as? OnboardingViewControllerDelegate)?.transitonToProfile(self, callback: profileDismissCallback)
            profileViewController.prevController = self
            self.transitionToScreen(viewController: profileViewController)
        }
        if currentPage < numPages - 1 {
            currentPage += 1
            scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(currentPage), y: 0), animated: true)
            pageControl.currentPage = currentPage
        }
        if currentPage == numPages - 1 {
            nextButton.text = "Get Started"
            nextButton.textColor = AppColors.main
            nextButtonWidth.constant = 130
        }
    }
    
    func profileDismissCallback() {
        if let yourAvailVC = prevController as? YourAvailabilitiesViewController {
            AlertManager.yourAvailabilityAlert(controller: yourAvailVC)
        } else if let newMeetingVC = prevController as? NewMeetingViewController{
            AlertManager.createNewMeetingAlert(controller: newMeetingVC)
        }
    }
}

protocol OnboardingViewControllerDelegate: AnyObject {
    func transitonToProfile(_ controller: OnboardingViewController, callback: @escaping (() -> Void))
}

extension MessagesViewController: OnboardingViewControllerDelegate {
    // allow this controller to transition to the YourAvailabilities screen
    func transitonToProfile(_ controller: OnboardingViewController, callback: @escaping (() -> Void)) {
        let profileVC: AvatarCreatorViewController = instantiateController()
        profileVC.dismissCallback = callback
        controller.profileViewController = profileVC
    }
}
