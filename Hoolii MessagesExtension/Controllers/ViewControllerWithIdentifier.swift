//
//  ViewControllerWithIdentifier.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

// make a protocol that classes implement to require them to have the following properties
protocol ViewControllerWithIdentifier {
    static var storyboardIdentifier: String { get }
    var delegate: AnyObject? { get set }
}

