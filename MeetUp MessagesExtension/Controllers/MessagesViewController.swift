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
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
            // Show a list of previously created ice creams.
            controller = instantiatePreviewViewController()
        } else {
             // Parse a `Schedule` from the conversation's `selectedMessage` or create a new `Schedule`.
            let collectiveSchedule = CollectiveSchedule(message: conversation.selectedMessage) ?? CollectiveSchedule()
            print(collectiveSchedule)
            if(collectiveSchedule.allSchedules.count > 0) {
                 print(collectiveSchedule.allSchedules[0].schedule)
             }

            // Show either the in process construction process or the completed ice cream.
            if collectiveSchedule.dates == 1 {
                controller = instantiateScheduleInProgressViewController()
            } else {
                controller = instantiateScheduleFinishedViewController()
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
    // Transition styles include compact (inside keyboard area), expanded (fills most of screen) and
    // transcript (displayed in the input field)
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
    
    // MARK: Controller instantiation
    private func instantiatePreviewViewController() -> UIViewController {
        // Get the view controller from the storyboard
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SchedulePreviewViewController.storyboardIdentifier)
            as? SchedulePreviewViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    private func instantiateScheduleInProgressViewController() -> UIViewController {
        // Get the view controller from the storyboard
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ScheduleInProgressViewController.storyboardIdentifier)
            as? ScheduleInProgressViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    private func instantiateScheduleFinishedViewController() -> UIViewController {
        // Get the view controller from the storyboard
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ScheduleFinishedViewController.storyboardIdentifier)
            as? ScheduleFinishedViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    // MARK: Convenience
    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }

}

// MARK: implement the delegate for each screen

extension MessagesViewController: ScheduleInProgressViewControllerDelegate {
    func scheduleInProgressViewController(_ controller: ScheduleInProgressViewController) {
        var collectiveSchedule: CollectiveSchedule = CollectiveSchedule();
        collectiveSchedule.allSchedules = [ScheduleSendable(timesFree: 1, personName: "Caden", personId: "2"),
                                           ScheduleSendable(timesFree: 3, personName: "Alyssa", personId: "3")]
        collectiveSchedule.dates = 1
        SendMessage(collectiveSchedule, "When should we meet up?")
        dismiss()
    }
}

extension MessagesViewController: SchedulePreviewControllerDelegate {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController) {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: ScheduleFinishedViewControllerDelegate {
    func scheduleFininishedViewControllerDidSelectExpand(_ controller: ScheduleFinishedViewController) {
        print("sent2");
    }
}
