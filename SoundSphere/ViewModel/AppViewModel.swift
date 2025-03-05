//
//  AppViewModel.swift
//  SoundSphere
//
//  Created by Leon Kwan on 03/01/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    enum AppState {
        case splash
        case login
        case home
        case extraDetails
    }

    @Published var state: AppState = .splash
    @Published var isLoading: Bool = false

    func checkAuthentication() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        Task {
            if let user = Auth.auth().currentUser {
                do {
                    // Reload the user to get the latest details
                    try await user.reload()
                    await MainActor.run {
                        // TODO: Should also fetch user details
                        if let displayName = user.displayName, !displayName.isEmpty {
                            self.state = .login
                        } else {
                            self.state = .extraDetails
                        }
                    }
                } catch {
                    print("Error reloading user: \(error)")
                    await MainActor.run {
                        self.state = .login
                    }
                }
            } else {
                await MainActor.run {
                    self.state = .login
                }
            }

            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
