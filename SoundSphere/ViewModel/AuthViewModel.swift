//
//  AuthViewModel.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @EnvironmentObject var AppViewModel: AppViewModel
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false

    @Published var userType: UserType = .student
    @Published var email: String = "admin@gmail.com"
    @Published var password: String = "admin123"
    @Published var confirmPassword: String = "admin123"
    @Published var isLogin: Bool = true
    
    func createAccount(email: String, password: String) async throws -> Bool {
        do {
            // Attempt Firebase registration
            let firstResult = try await authApi().registerWithFirebase(email: email, password: password)
            // If successful, proceed with backend registration
            let secondResult = try await authApi().register(email: email, userType: userType)
            
            self.isAuthenticated = true

            return firstResult && secondResult
        } catch {
            // Handle FirebaseAuthError
            if let firebaseError = error as? FirebaseAuthError {
                switch firebaseError {
                case .emailAlreadyInUse:
                    // Attempt backend registration if email is already in use
                    do {
                        let secondResult = try await authApi().register(email: email, userType: userType)
                        self.isAuthenticated = true

                        return secondResult
                    } catch {
                        // Handle backend registration error
                        self.errorMessage = "Registration failed: \(error.localizedDescription)"
                        throw error
                    }
                default:
                    // Set the error message for other Firebase errors
                    self.errorMessage = error.localizedDescription
                    throw error
                }
            } else {
                // Handle non-Firebase errors
                self.errorMessage = error.localizedDescription
                throw error
            }
        }
    }

    func loginAccount(email: String, password: String) async throws -> Bool {
        do {
            let result = try await authApi().loginWithFirebase(email: email, password: password)
            
            self.isAuthenticated = true
            return result
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
}
