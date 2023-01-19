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
}
