//
//  StoredValues.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 8/19/22.
//

import UIKit

// all of the storage keys
struct StoredValuesConstants {
    static let userID: String = "userID"
    static let firstName: String = "firstName"
    static let lastName: String = "lastName"
    static let initials: String = "initials"
    static let userSchedule: String = "userSchedule"
    static let hasBeenOnboarded: String = "hasBeenOnboarded"
}

struct StoredValues {
    static let defaults = UserDefaults.standard
    
    static func get(key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    static func set(key: String, value: String) {
        defaults.set(value, forKey: key)
    }
    
    // set the value of the key if there is currently no value for the key passed in
    static func setIfEmpty(key: String, value: String) {
        if (self.get(key: key) == nil) {
            self.set(key: key, value: value)
        }
    }
    
    static func deleteKey(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    static func isKeyNil(key: String) -> Bool {
        return self.get(key: key) == nil
    }
}
