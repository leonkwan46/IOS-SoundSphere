//
//  ExtraDetailsViewModel.swift
//  SoundSphere
//
//  Created by Leon Kwan on 18/01/2025.
//

import SwiftUI
import FirebaseAuth
import Combine

class ExtraDetailsViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int = 0
    @Published var gender: String = ""
    @Published var isUnique: Bool = false
    
    // Error states
    @Published var usernameError: String? = nil
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var ageError: String? = nil
    @Published var genderError: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        checkUsernameAvailability()
    }
        
    func updateUserDetails(username: String, firstName: String, lastName: String, age: Int, gender: String) async throws -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in"])
        }
        
        do {
            // Update user details
            let _ = try await userApi().updateUserDetails(username: username, firstName: firstName, lastName: lastName, age: age, gender: gender)
            
            // Update the Firebase display name
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.displayName = username
            try await changeRequest.commitChanges()
            
            return true
        } catch {
            throw error
        }
    }

    func validateFields() -> Bool {
        var isValid = true
        
        // Reset errors
        usernameError = nil
        firstNameError = nil
        lastNameError = nil
        ageError = nil
        genderError = nil
        
        // Validate each field and set error messages if needed
        if username.isEmpty {
            usernameError = "Username is required"
            isValid = false
        }
        if firstName.isEmpty {
            firstNameError = "First Name is required"
            isValid = false
        }
        if lastName.isEmpty {
            lastNameError = "Last Name is required"
            isValid = false
        }
        if age == 0 {
            ageError = "Age is required"
            isValid = false
        }
        if gender.isEmpty {
            genderError = "Gender is required"
            isValid = false
        }
        
        return isValid
    }
    
    private var usernameCheckTask: Task<Void, Never>?
    
    func checkUsernameAvailability() {
        $username
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] debouncedUsername in
                guard let self = self else { return }

                guard !self.username.isEmpty else {
                    return
                }
                
                usernameCheckTask?.cancel()
                
                usernameCheckTask = Task {
                    do {
                        let isAvailable = try await userApi().checkUsernameAvailability(username: debouncedUsername)
                        if !isAvailable {
                            self.usernameError = "Username is taken! Try another one."
                        } else {
                            self.usernameError = nil
                        }
                        self.isUnique = isAvailable
                    } catch {
                        if (error as? CancellationError) != nil {
                            print("Username check was cancelled.")
                        } else {
                            print("Error checking username availability: \(error)")
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
