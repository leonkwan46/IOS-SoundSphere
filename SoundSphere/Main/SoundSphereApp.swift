//
//  SoundSphereApp.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//

import Foundation
import SwiftUI

@main
struct SoundSphereApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var contactViewModel = ContactViewModel()
    @StateObject var userViewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
