//
//  MessagesViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit
import Messages
import Alamofire

class MessagesViewController: MSMessagesAppViewController {
    
    static var currViewController: UIViewController!
    
    override func viewDidLoad() {
        print("loaded")
        StoredValues.deleteKey(key: StoredValuesConstants.newMeetingOnboarding)
        StoredValues.deleteKey(key: StoredValuesConstants.yourAvailabilityOnboarding)
        StoredValues.deleteKey(key: StoredValuesConstants.hasBeenOnboarded)
        StoredValues.deleteKey(key: StoredValuesConstants.firstName)
        StoredValues.deleteKey(key: StoredValuesConstants.lastName)
        StoredValues.deleteKey(key: StoredValuesConstants.userAvatar)
//        AF.request("https://hoolii.fly.dev/collective-schedule", method: .get).validate().responseJSON(completionHandler: handleResponse)
    }
    
    func handleResponse(_ response: AFDataResponse<Any>) {
        switch (response.result) {
            case .success(let successRes):
            
            print("success")
            print(successRes)

            do {
//                let users = try JSONDecoder().decode([User].self, from: response.data!)
//                print(users)
                debugPrint(response.data!)

            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Conversation Handling
    fileprivate func composeMessage(_ collectiveSchedule: CollectiveSchedule, _ caption: String, _ session: MSSession? = nil) -> MSMessage {
        
        // URLComponents are a structure that parses URLs into and constructs URLs from their constituent parts
        var components = URLComponents()
        components.queryItems = HooliiMessage(collectiveSchedule: CollectiveSchedule.shared).queryItems
        print(components.queryItems)
        
        let layout = MSMessageTemplateLayout()
        layout.caption = caption
        layout.image = (MessageGraphic.instanceFromNib()!).convertToImage()
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    public func SendMessage() {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        let message = composeMessage(CollectiveSchedule.shared, CollectiveSchedule.shared.meetingName, conversation.selectedMessage?.session)
        
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        conversation.insertText("https://www.when2meet.com/ ")
    }
    
    // MARK: Determine active view controller before extension becomes active
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: Determine active view controller
    private func presentViewController(for conversation: MSConversation, with presenentationStyle: MSMessagesAppPresentationStyle) {
        // Parse a `Schedule` from the conversation's `selectedMessage` or create a new `Schedule`.
        CollectiveSchedule.shared = HooliiMessage(message: conversation.selectedMessage)?.getCollectiveSchedule() ?? CollectiveSchedule()
                
        let controller: AppViewController
        if presentationStyle == .compact {
            if CollectiveSchedule.shared.endTime == HourMinuteTime(hour: 0, minute: 0) {
                let onboardingCollapsedController: OnboardingCollapsedViewController = instantiateController()
                controller = onboardingCollapsedController
            } else {
                let yourAvailController: YourAvailabilitiesViewController = instantiateController()
                controller = yourAvailController
            }
            
            if let currVC = MessagesViewController.currViewController as? AvatarCreatorViewController {
                currVC.collectionViewBottomConstraint.isActive = false
            }
        } else {
            if CollectiveSchedule.shared.allSchedules.count > 0 {
                let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
                controller = yourAvailabilitiesController
            } else {
                let newMeetingController: NewMeetingViewController = instantiateController()
                controller = newMeetingController
            }
            
            if let currVC = MessagesViewController.currViewController as? AvatarCreatorViewController {
                currVC.collectionViewBottomConstraint = currVC.elemCollectionView.bottomAnchor.constraint(equalTo: currVC.bottomBar.topAnchor)
                currVC.collectionViewBottomConstraint.isActive = true
            }
        }
        
        // when adding the view controller, make it fill up all available space
        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if presentationStyle == .expanded && (StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded)) {
            let onboardingController: OnboardingViewController = instantiateController()
            onboardingController.prevController = controller
            controller.transitionToScreen(viewController: onboardingController)
        }
        
        controller.didMove(toParent: self)
    }
    
    // MARK: Switch view controller
    // Tells the view controller that the extension is about to transition to a new presentation style
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // when a new view controller is transitioned to, remove the view controller that is currently on the screen
        removeAllChildViewControllers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if(size.width > self.view.frame.size.width){
            // screen is horizontal
            self.dismiss(animated: false, completion: nil)
            let horizontalOrientationController: HorizontalOrientationViewController = instantiateController()
            addChild(horizontalOrientationController)
            view.addSubview(horizontalOrientationController.view)
            horizontalOrientationController.view.translatesAutoresizingMaskIntoConstraints = false
            horizontalOrientationController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            horizontalOrientationController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            horizontalOrientationController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            horizontalOrientationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            // screen is vertical
            for child in children {
                if let controller = child as? HorizontalOrientationViewController {
                    controller.willMove(toParent: nil)
                    controller.view.removeFromSuperview()
                    controller.removeFromParent()
                }
            }
        }
    }
    
    // Tells the view controller that the extenson has transitioned to a new presentation style -> compact or exmpanded
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: Convenience
    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func instantiateController<T: ViewControllerWithIdentifier>() -> T {
        guard var controller = storyboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier)
                as? T
            else { fatalError("Unable to instantiate controller from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
}
