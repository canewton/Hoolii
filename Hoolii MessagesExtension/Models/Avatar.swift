//
//  UserAvatar.swift
//  Hoolii MessagesExtension
//
//  Created by Aadam Mirza on 1/7/23.
//

import Foundation
import UIKit

let encodingChars: KeyValuePairs<Int, Character> = [0: "0", 1:"1", 2:"2", 3:"3", 4:"4", 5:"5", 6:"6", 7:"7", 8:"8", 9:"9", 10:"a", 11:"b", 12:"c", 13:"d", 14:"e", 15:"f", 16:"g", 17:"h", 18:"i", 19:"j", 20:"k", 21:"l", 22:"m", 23:"n", 24:"o", 25:"p", 26:"q", 27:"r", 28:"t", 29:"u", 30:"v", 31:"w", 32:"x", 33:"y", 34:"z", 35:"A", 36:"B", 37:"C", 38:"D", 39:"E", 40:"F", 41:"G", 42:"H", 43:"I", 44:"J", 45:"K", 46:"L", 47:"M", 48:"N", 49:"O"]

struct Avatar: Codable, Equatable {
    // MARK: Properties
    var avatarIndex: Int
    var backgroundIndex: Int
    
    init(avatarIndex: Int, backgroundIndex: Int) {
        self.avatarIndex = avatarIndex
        self.backgroundIndex = backgroundIndex
    }
    
    init() {
        self.init(avatarIndex: Int.random(in: 0..<AvatarConstants.avatarOptions.count), backgroundIndex: Int.random(in: 0..<AppColors.backgroundColorArray.count))
    }
    
    init(avatarEncoded: String) {
        let avatarEncodedArr = Array(avatarEncoded)
        
        self.init(avatarIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[0] })!].0, backgroundIndex: encodingChars[encodingChars.firstIndex(where: { $0.1 == avatarEncodedArr[1] })!].0)
    }
    
    init(jsonValue: String) {
        if jsonValue != "" {
            let dataFromJsonString = jsonValue.data(using: .utf8)!
            self = try! JSONDecoder().decode(Avatar.self, from: dataFromJsonString)
        } else {
            self.init()
        }
    }
    
    func getJsonValue() -> String {
        let encodedData = try! JSONEncoder().encode(self)
        return String(data: encodedData, encoding: .utf8)!
    }
    
    func encodeAvatar() -> String {
        return "\( encodingChars[avatarIndex].1 )\( encodingChars[backgroundIndex].1 )"
    }
    
    func toImage(size: CGSize) -> UIImage {
        // create Image context offscreen
        UIGraphicsBeginImageContext(size)

        let areaSize1 = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // draw images into context
        let avatarPath = Bundle.main.path(forResource: AvatarConstants.avatarOptions[avatarIndex].avatar, ofType: "png")!
        UIImage(contentsOfFile: avatarPath)?.draw(in: areaSize1)
        
        let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return avatarImage!
    }
}
