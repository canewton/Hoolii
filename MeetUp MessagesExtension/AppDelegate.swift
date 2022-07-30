//
//  AppDelegate.swift
//  MeetUp MessagesExtension
//
//  Created by Caden Newton on 7/30/22.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
    }
}
