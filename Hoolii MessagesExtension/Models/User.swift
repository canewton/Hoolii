//
//  User.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/16/22.
//

import Foundation


struct User: Codable, Equatable {
    
    // MARK: Properties
    var id: String
    var firstName: String
    var lastName: String
    var avatar: Avatar?
    init(id: String, firstName: String, lastName: String, avatar: Avatar?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
    
    func getInitials() -> String {
        return "\(firstName.prefix(1))\(lastName.prefix(1))"
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
