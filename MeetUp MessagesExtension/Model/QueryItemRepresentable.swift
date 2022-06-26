//
//  QueryItemRepresentable.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 6/26/22.
//

import Foundation

protocol QueryItemRepresentable {

    var queryItem: URLQueryItem { get }
    
    static var queryItemKey: String { get }
    
}

