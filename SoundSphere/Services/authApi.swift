//
//  authApi.swift
//  SoundSphere
//
//  Created by Leon Kwan on 15/12/2024.
//

import Foundation
import FirebaseAuth

enum FirebaseAuthError: Error, LocalizedError {
    case invalidCredential
    case userDisabled
    case operationNotAllowed
    case emailAlreadyInUse
    case weakPassword
    case invalidEmail
    case unknown(String)
    
    init?(userInfoNameKey: String) {
        switch userInfoNameKey {
        case "ERROR_INVALID_CREDENTIAL":
            self = .invalidCredential
        case "ERROR_USER_DISABLED":
            self = .userDisabled
        case "ERROR_OPERATION_NOT_ALLOWED":
            self = .operationNotAllowed
        case "ERROR_EMAIL_ALREADY_IN_USE":
            self = .emailAlreadyInUse
        case "ERROR_WEAK_PASSWORD":
            self = .weakPassword
        case "ERROR_INVALID_EMAIL":
            self = .invalidEmail
        default:
            self = .unknown(userInfoNameKey)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid credentials. Please Try again."
        case .userDisabled:
            return "This account has been disabled."
        case .operationNotAllowed:
            return "Operation not allowed. Check Firebase settings."
        case .emailAlreadyInUse:
            return "Email already in use. Try logging in."
        // This should be updated when more password validations are added
        case .weakPassword:
            return "Password is too weak. Use at least 6 characters."
        case .invalidEmail:
            return "Invalid email format."
        case .unknown(let key):
            return "An error occurred: \(key)."
        }
    }
}

func handleFirebaseError(error: Error) -> FirebaseAuthError {
    let nsError = error as NSError
    if let userInfoNameKey = nsError.userInfo[AuthErrorUserInfoNameKey] as? String,
       let firebaseError = FirebaseAuthError(userInfoNameKey: userInfoNameKey) {
        return firebaseError
    }
    return .unknown(nsError.localizedDescription)
}

class authApi {
    func loginWithFirebase(email: String, password: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let firebaseError = handleFirebaseError(error: error)
                    print("Firebase error: \(firebaseError)")
                    continuation.resume(throwing: firebaseError)
                    return
                }

                if let authResult = authResult {
                    print("User logged in: \(authResult.user.email ?? "Unknown")")
                    continuation.resume(returning: true)
                } else {
                    print("Unexpected error: No authResult returned.")
                    continuation.resume(throwing: FirebaseAuthError.unknown("Unexpected error: No authResult returned."))
                }
            }
        }
    }
    
    func registerWithFirebase(email: String, password: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let firebaseError = handleFirebaseError(error: error)
                    print("Firebase error: \(firebaseError)")
                    continuation.resume(throwing: firebaseError)
                    return
                }
                if let authResult = authResult {
                    print("User signed up: \(authResult.user.email ?? "Unknown")")
                    continuation.resume(returning: true)
                } else {
                    print("Unexpected error: No authResult returned.")
                    continuation.resume(throwing: FirebaseAuthError.unknown("Unexpected error: No authResult returned."))
                }
            }
        }
    }
    
    func register(email: String, userType: UserType) async throws -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            throw FirebaseAuthError.unknown("No current user")
        }
        
        guard let url = URL(string: "http://localhost:3000/auth/register-with-firebase") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["email": email, "firebaseUserId": currentUser.uid, "userType": userType.rawValue])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            if httpResponse.statusCode == 200 {
                return true
            } else {
                // Parse the error response body
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorDescription = errorMessage["error"] {
                    print("Server error: \(errorDescription)")
                } else {
                    print("Unexpected error: \(httpResponse.statusCode)")
                }
                
                throw URLError(.badServerResponse)
            }
        } catch {
            print("Request failed with error: \(error.localizedDescription)")
        }
        return false
    }

    // MARK: - LEGACY CODE
    func login(email: String, password: String) async throws -> AuthTokenResult {
        guard let url = URL(string: "http://localhost:3000/auth/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["email": email, "password": password])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }

            if httpResponse.statusCode == 200 {
                // Handle success
                return try JSONDecoder().decode(AuthTokenResult.self, from: data)
            } else {
                // Parse the error response body
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorDescription = errorMessage["error"] {
                    print("Server error: \(errorDescription)")
                    throw CustomError.serverError(errorDescription)
                } else {
                    print("Unexpected error: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            }
        } catch {
            print("Request failed with error: \(error.localizedDescription)")
            throw error
        }
    }

}

// MARK: - LEGACY CODE
enum authApiError: Error {
    case invalidURL
}

enum CustomError: Error, LocalizedError {
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        }
    }
}
