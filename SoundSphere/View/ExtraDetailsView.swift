//
//  ExtraDetailsView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 18/01/2025.
//

import SwiftUI

struct ExtraDetailsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var extraDetailsViewModel = ExtraDetailsViewModel()
    
    var body: some View {
        VStack {
            TextField("Username", text: $extraDetailsViewModel.username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onChange(of: extraDetailsViewModel.username) { oldValue, newValue in
                     Task {
                         extraDetailsViewModel.checkUsernameAvailability()
                     }
                    
                }
            if let usernameError = extraDetailsViewModel.usernameError {
                Text(usernameError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            TextField("First Name", text: $extraDetailsViewModel.firstName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            if let firstNameError = extraDetailsViewModel.firstNameError {
                Text(firstNameError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            TextField("Last Name", text: $extraDetailsViewModel.lastName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            if let lastNameError = extraDetailsViewModel.lastNameError {
                Text(lastNameError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            TextField("Age", value: $extraDetailsViewModel.age, formatter: NumberFormatter())
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            if let ageError = extraDetailsViewModel.ageError {
                Text(ageError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            TextField("Gender", text: $extraDetailsViewModel.gender)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            if let genderError = extraDetailsViewModel.genderError {
                Text(genderError)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Update") {
                Task {
                    await validateAndSubmit()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()

    }
    
    private func validateAndSubmit() async {
        // Validate fields
        let isValid = extraDetailsViewModel.validateFields()
        
        // Proceed with submission only if valid
        if isValid {
            do {
                let result = try await extraDetailsViewModel.updateUserDetails(username: extraDetailsViewModel.username, firstName: extraDetailsViewModel.firstName, lastName: extraDetailsViewModel.lastName, age: extraDetailsViewModel.age, gender: extraDetailsViewModel.gender)
                
                print("User details updated: \(result)")
                if result {
                    appViewModel.state = .home
                }
            } catch {
                // Handle any other errors that might arise during the update
                print("Failed to update user details: \(error.localizedDescription)")
            }
        }
    }
}
