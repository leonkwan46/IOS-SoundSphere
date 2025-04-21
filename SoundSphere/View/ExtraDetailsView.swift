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
    @FocusState private var focusedField: Field?
    @State private var isTransitioning = false
    @Environment(\.colorScheme) var colorScheme
    @State private var usernameDebounceTask: Task<Void, Never>?
    
    enum Field: Hashable {
        case username, firstName, lastName, age, gender
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            AppTheme.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()
            
            // Golden particles
            GoldenParticlesView(count: 30, isTransitioning: isTransitioning)
            
            // Content
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(AppTheme.gold)
                            .shadow(color: AppTheme.gold.opacity(0.3), radius: 8, x: 0, y: 3)
                        
                        Text("Complete Your Profile")
                            .font(AppTheme.titleStyle(for: colorScheme).font)
                            .foregroundColor(AppTheme.titleStyle(for: colorScheme).color)
                            .shadow(color: AppTheme.titleStyle(for: colorScheme).shadow ?? .clear, radius: 1, x: 0, y: 1)
                        
                        Text("Tell us a bit more about yourself")
                            .font(AppTheme.subtitleStyle(for: colorScheme).font)
                            .foregroundColor(AppTheme.subtitleStyle(for: colorScheme).color)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    
                    // Form fields
                    VStack(spacing: 16) {
                        // Username field with availability indicator
                        VStack(alignment: .leading, spacing: 4) {
                            AppTextField(
                                iconName: "person.fill",
                                placeholder: "Username",
                                text: $extraDetailsViewModel.username,
                                error: extraDetailsViewModel.usernameError
                            )
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .firstName
                            }
                            .onChange(of: extraDetailsViewModel.username) { oldValue, newValue in
                                // Cancel any existing debounce task
                                usernameDebounceTask?.cancel()
                                
                                // Create a new debounce task
                                usernameDebounceTask = Task {
                                    // Wait for 500ms of no typing
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    
                                    // Check if the task was cancelled
                                    if !Task.isCancelled {
                                        await MainActor.run {
                                            extraDetailsViewModel.checkUsernameAvailability()
                                        }
                                    }
                                }
                            }
                        }
                        
                        // First Name field
                        AppTextField(
                            iconName: "textformat.abc",
                            placeholder: "First Name",
                            text: $extraDetailsViewModel.firstName,
                            error: extraDetailsViewModel.firstNameError
                        )
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .lastName
                        }
                        
                        // Last Name field
                        AppTextField(
                            iconName: "textformat.abc",
                            placeholder: "Last Name",
                            text: $extraDetailsViewModel.lastName,
                            error: extraDetailsViewModel.lastNameError
                        )
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .age
                        }
                        
                        // Age field
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(AppTheme.gold)
                                .frame(width: 24)
                            
                            TextField("Age", value: $extraDetailsViewModel.age, formatter: NumberFormatter())
                                .foregroundColor(AppTheme.textColor(for: colorScheme))
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .age)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .gender
                                }
                            
                            Spacer()
                        }
                        .appFormFieldStyle(AppTheme.formFieldStyle(for: colorScheme))
                        
                        if let ageError = extraDetailsViewModel.ageError {
                            Text(ageError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 12)
                                .transition(.opacity)
                        }
                        
                        // Gender field with picker
                        Menu {
                            Button("Male") { extraDetailsViewModel.gender = "Male" }
                            Button("Female") { extraDetailsViewModel.gender = "Female" }
                            Button("Non-binary") { extraDetailsViewModel.gender = "Non-binary" }
                            Button("Prefer not to say") { extraDetailsViewModel.gender = "Prefer not to say" }
                        } label: {
                            HStack {
                                Image(systemName: "person.fill.questionmark")
                                    .foregroundColor(AppTheme.gold)
                                    .frame(width: 24)
                                
                                Text(extraDetailsViewModel.gender.isEmpty ? "Select Gender" : extraDetailsViewModel.gender)
                                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(AppTheme.gold.opacity(0.7))
                            }
                            .appFormFieldStyle(AppTheme.formFieldStyle(for: colorScheme))
                        }
                        
                        if let genderError = extraDetailsViewModel.genderError {
                            Text(genderError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading, 12)
                                .transition(.opacity)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Submit button
                    AppButton(
                        title: "Complete Profile",
                        icon: "checkmark.circle.fill"
                    ) {
                        focusedField = nil
                        Task {
                            await validateAndSubmit()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding()
            }
        }
        .opacity(isTransitioning ? 0 : 1)
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func validateAndSubmit() async {
        // Validate fields
        let isValid = extraDetailsViewModel.validateFields()
        
        // Proceed with submission only if valid
        if isValid {
            appViewModel.isLoading = true
            
            do {
                let result = try await extraDetailsViewModel.updateUserDetails(
                    username: extraDetailsViewModel.username,
                    firstName: extraDetailsViewModel.firstName,
                    lastName: extraDetailsViewModel.lastName,
                    age: extraDetailsViewModel.age,
                    gender: extraDetailsViewModel.gender
                )
                
                if result {
                    withAnimation(AppTheme.easeOutAnimation) {
                        isTransitioning = true
                    }
                    
                    // Small delay to allow transition animation to complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.transitionDuration) {
                        appViewModel.state = .home
                    }
                }
            } catch {
                // Handle any other errors that might arise during the update
                print("Failed to update user details: \(error.localizedDescription)")
            }
            
            appViewModel.isLoading = false
        }
    }
}

#Preview {
    ExtraDetailsView()
        .environmentObject(AppViewModel())
}
