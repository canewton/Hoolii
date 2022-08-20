//
//  StoredValues.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/19/22.
//

import UIKit

struct StoredValuesConstants {
    static let userID: String = "userID"
    static let username: String = "username"
}

struct StoredValues {
    static let defaults = UserDefaults.standard
    
    static func get(key: String) -> String? {
        return defaults.string(forKey: "username")!
    }
    
    static func set(key: String, value: String) {
        defaults.set(value, forKey: key)
    }
    
    static func setIfEmpty(key: String, value: String) {
        if (self.get(key: key) == nil) {
            self.set(key: key, value: value)
        }
    }
}
