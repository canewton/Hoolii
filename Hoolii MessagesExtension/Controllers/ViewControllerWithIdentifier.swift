//
//  ViewControllerWithIdentifier.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/6/22.
//

import UIKit

protocol ViewControllerWithIdentifier {
    static var storyboardIdentifier: String { get }
    var delegate: AnyObject? { get set }
}

