//
//  MessagesViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        print("loaded")
    }
    
    // MARK: - Conversation Handling
    fileprivate func composeMessage(_ collectiveSchedule: CollectiveSchedule, _ caption: String, _ session: MSSession? = nil) -> MSMessage {
        
        // URLComponents are a structure that parses URLs into and constructs URLs from their constituent parts
        var components = URLComponents()
        components.queryItems = collectiveSchedule.queryItems
        
        let layout = MSMessageTemplateLayout()
        layout.caption = caption
        layout.image = UIImage(named: "message-graphic.png")
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    public func SendMessage(_ collectiveSchedule: CollectiveSchedule, _ caption: String) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        let message = composeMessage(collectiveSchedule, caption, conversation.selectedMessage?.session)
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        //conversation.insertText("https://www.when2meet.com/ ")
    }
    
    // MARK: Determine active view controller before extension becomes active
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: Determine active view controller
    private func presentViewController(for conversation: MSConversation, with presenentationStyle: MSMessagesAppPresentationStyle) {
        // Parse a `Schedule` from the conversation's `selectedMessage` or create a new `Schedule`.
        let collectiveSchedule = CollectiveSchedule(message: conversation.selectedMessage) ?? CollectiveSchedule()
                
        let controller: AppViewController
        if presentationStyle == .compact {
            if StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) {
                let onboardingCollapsedController: OnboardingCollapsedViewController = instantiateController()
                controller = onboardingCollapsedController
            } else if collectiveSchedule.endTime == HourMinuteTime(hour: 0, minute: 0) {
                let schedulePreviewController: CreateMeetingPreviewViewController = instantiateController()
                controller = schedulePreviewController
            } else {
                let yourAvailController: YourAvailabilitiesViewController = instantiateController()
                controller = yourAvailController
            }
        } else {
            if StoredValues.isKeyNil(key: StoredValuesConstants.hasBeenOnboarded) {
                let onboardingController: OnboardingViewController = instantiateController()
                controller = onboardingController
            } else if collectiveSchedule.allSchedules.count > 0 {
                let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
                controller = yourAvailabilitiesController
                yourAvailabilitiesController.collectiveSchedule = collectiveSchedule
            } else {
                let newMeetingController: NewMeetingViewController = instantiateController()
                controller = newMeetingController
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
        
        controller.didMove(toParent: self)
    }
    
    // MARK: Switch view controller
    // Tells the view controller that the extension is about to transition to a new presentation style
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // when a new view controller is transitioned to, remove the view controller that is currently on the screen
        removeAllChildViewControllers()
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
