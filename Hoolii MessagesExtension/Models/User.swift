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
    var avatar: String?
    var backgroundColor: Int
    init(id: String, firstName: String, lastName: String, avatar: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
        self.backgroundColor = Int.random(in: 0..<AppColors.backgroundColorArray.count)
        
        if avatar != nil {
            var imageStorage = ImageStorage(userID: id, avatarImage: Avatar(avatarEncoded: avatar!).toImage(size: CGSize(width: 100, height: 100)))
            ImageStorage.avatarImages.append(imageStorage)
        }
    }
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.backgroundColor = Int.random(in: 0..<AppColors.backgroundColorArray.count)
    }
    
    func getInitials() -> String {
        return "\(firstName.prefix(1))\(lastName.prefix(1))"
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
