//
//  SchedulePreviewViewController.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/19/22.
//

import UIKit

class SchedulePreviewViewController: AppViewController, ViewControllerWithIdentifier {
    
    // MARK: Properties
    static let storyboardIdentifier = "SchedulePreviewViewController"
    weak var delegate: AnyObject?
    
    @IBAction func ExpandButton(_ sender: Any) {
        (delegate as? SchedulePreviewControllerDelegate)?.schedulePreviewViewControllerDidSelectExpand(self)
    }
}

protocol SchedulePreviewControllerDelegate: AnyObject {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController)
}

extension MessagesViewController: SchedulePreviewControllerDelegate {
    func schedulePreviewViewControllerDidSelectExpand(_ controller: SchedulePreviewViewController) {
//        if let url = URL(string: "http://localhost:8080/schedule"){
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
//            task.resume()
//        }
        requestPresentationStyle(.expanded)
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let safeData = data {
            let dataString: String = String(data: safeData, encoding: .utf8)!
            print(dataString)
        }
    }
}
