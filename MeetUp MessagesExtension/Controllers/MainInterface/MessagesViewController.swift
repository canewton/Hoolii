//
//  MessagesViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit
import SwiftUI
import Messages
import Firebase

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
//        FirebaseApp.configure()
//        let uid = "test"
        print("Database:")
//        let db = Database.database()
//        print(db)
//
//        let databasePath: DatabaseReference! = Database.database().reference().child("users/\(uid)/thoughts")
//        databasePath.childByAutoId().setValue("{ 'hi': 'hi' }")
    }
    
    var allSchedules: [ScheduleSendable] = []
    
    // MARK: - Conversation Handling
    fileprivate func composeMessage(
        with collectiveSchedule: CollectiveSchedule,
        _ caption: String,
        _ session: MSSession? = nil
    ) -> MSMessage {
        
        // URLComponents are a structure that parses URLs into and constructs URLs from their constituent parts
        var components = URLComponents()
        components.queryItems = collectiveSchedule.queryItems
        
        // Configure the appearance of the message
        let layout = MSMessageTemplateLayout()
        layout.caption = caption
        layout.image = UIImage(named: "placeholder.png")
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    public func SendMessage(_ collectiveSchedule: CollectiveSchedule, _ caption: String) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        let message = composeMessage(with: collectiveSchedule, caption, conversation.selectedMessage?.session)
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
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: Determine active view controller
    private func presentViewController(for conversation: MSConversation, with presenentationStyle: MSMessagesAppPresentationStyle) {
        // Remove any child view controllers that have been presented
        removeAllChildViewControllers()
        
        let controller: UIViewController
        if presentationStyle == .compact {
            let schedulePreviewController: SchedulePreviewViewController = instantiateController()
            controller = schedulePreviewController
        } else {
             // Parse a `Schedule` from the conversation's `selectedMessage` or create a new `Schedule`.
            let collectiveSchedule = CollectiveSchedule(message: conversation.selectedMessage) ?? CollectiveSchedule()
            print(collectiveSchedule)
            
            allSchedules = collectiveSchedule.allSchedules
            
            getDaysAndTimesFree(allSchedules)
            
            if collectiveSchedule.allSchedules.count > 0 {
                 print(collectiveSchedule.allSchedules[0].schedule)
            }

            if collectiveSchedule.allSchedules.count > 0  {
                let yourAvailabilitiesController: YourAvailabilitiesViewController = instantiateController()
                controller = yourAvailabilitiesController
            } else {
                let newMeetingController: NewMeetingViewController = instantiateController()
                controller = newMeetingController
            }
        }
        
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
        
        // Hide child view controllers during the transition.
        removeAllChildViewControllers()
    }
    
    // Tells the view controller that the extenson has transitioned to a new presentation style
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        // Present the view controller appropriate for the conversation and presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        // Determine the view that is going to be shown based on the presentation style
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
        // Get the view controller from the storyboard
        guard var controller = storyboard?.instantiateViewController(withIdentifier: T.storyboardIdentifier)
                as? T
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
}
