//
//  ImageStorage.swift
//  Hoolii MessagesExtension
//
//  Created by Caden Newton on 1/18/23.
//

import Foundation
import UIKit

struct ImageStorage {
    static var avatarImages: [ImageStorage] = []
    var userID: String
    var avatarImage: UIImage
    
    init(userID: String, avatarImage: UIImage) {
        self.userID = userID
        self.avatarImage = avatarImage
    }
    
    static func addImages(users: [User]) {
        for i in 0..<users.count {
            avatarImages.append(ImageStorage(userID: users[i].id, avatarImage: Avatar(avatarEncoded: users[i].avatar!).toImage(size: CGSize(width: 100, height: 100))))
        }
    }
    
    static func clearImages() {
        avatarImages = []
    }
}
