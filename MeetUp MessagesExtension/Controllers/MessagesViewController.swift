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
        FirebaseApp.configure()
        
        let uid = "test"
        
        print("Database:")
        let db = Database.database()
        print(db)
        
        let databasePath: DatabaseReference! = Database.database().reference().child("users/\(uid)/thoughts")
        databasePath.childByAutoId().setValue("{ 'hi': 'hi' }")
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
            // Show a list of previously created ice creams.
            controller = instantiatePreviewViewController()
        } else {
             // Parse a `Schedule` from the conversation's `selectedMessage` or create a new `Schedule`.
            let collectiveSchedule = CollectiveSchedule(message: conversation.selectedMessage) ?? CollectiveSchedule()
            print(collectiveSchedule)
            
            allSchedules = collectiveSchedule.allSchedules
            
            getDaysAndTimesFree(allSchedules)
            
            if(collectiveSchedule.allSchedules.count > 0) {
                 print(collectiveSchedule.allSchedules[0].schedule)
            }

            // Show either the in process construction process or the completed ice cream.
            if true {
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
}

// MARK: implement the delegate for each screen

extension MessagesViewController: ScheduleInProgressViewControllerDelegate {
    func addDataToMessage(schedule: ScheduleSendable) {
        var collectiveSchedule: CollectiveSchedule = CollectiveSchedule();
        
//        var userScheduleIndex: Int = -1
//        for i in 0..<allSchedules.count {
//            if self.allSchedules[i].schedule.user.id == schedule.schedule.user.id {
//                userScheduleIndex = i
//            }
//        }
        
//        if userScheduleIndex >= 0 {
//            // edit the user if the user already replied
//            self.allSchedules[userScheduleIndex] = schedule
//        } else {
//            // append the user if the user has not replied
//            self.allSchedules.append(schedule)
//        }
        
        self.allSchedules = [ScheduleSendable(datesFree: [Day(dateString: "07-16-2022", timesFree: [TimeRange(from: 8, to: 10), TimeRange(from: 13, to: 18), TimeRange(from: 20, to: 22)])], user: User(id: "1", name: "Caden")),
                             ScheduleSendable(datesFree: [Day(dateString: "07-16-2022", timesFree: [TimeRange(from: 8, to: 10), TimeRange(from: 14, to: 18), TimeRange(from: 20, to: 21)])], user: User(id: "2", name: "Alyssa")),
                             ScheduleSendable(datesFree: [Day(dateString: "07-16-2022", timesFree: [TimeRange(from: 8, to: 11), TimeRange(from: 15, to: 18), TimeRange(from: 19, to: 23)])], user: User(id: "3", name: "Colin"))]
        
        collectiveSchedule.allSchedules = self.allSchedules
        collectiveSchedule.expirationDateString = "09-04-2022"
        SendMessage(collectiveSchedule, "When should we meet up?")
        dismiss()
    }
}

extension MessagesViewController: SchedulePreviewControllerDelegate {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController) {
        if let url = URL(string: "http://localhost:8080/schedule"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            task.resume()
        }
        requestPresentationStyle(.expanded)
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let safeData = data {
            let dataString: String = String(data: safeData, encoding: .utf8)!
            print(dataString)
        }
    }
}

extension MessagesViewController: ScheduleFinishedViewControllerDelegate {
    func scheduleFininishedViewControllerDidSelectExpand(_ controller: ScheduleFinishedViewController) {
        print("sent2");
    }
}
