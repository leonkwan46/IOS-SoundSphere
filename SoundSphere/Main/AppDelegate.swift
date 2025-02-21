//
//  AppDelegate.swift
//  SoundSphere
//
//  Created by Leon Kwan on 01/01/2025.
//

import Foundation
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseConfigurable().configure()

        return true
    }
}
