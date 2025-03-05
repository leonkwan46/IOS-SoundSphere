import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @EnvironmentObject var AppViewModel: AppViewModel
    @StateObject var authViewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    @State private var isTransitioning = false
    @Environment(\.colorScheme) var colorScheme
    
    enum Field: Hashable {
        case email, password, confirmPassword
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
                    // Logo and title
                    VStack(spacing: 10) {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(AppTheme.gold)
                            .shadow(color: AppTheme.gold.opacity(0.3), radius: 8, x: 0, y: 3)
                        
                        Text("SoundSphere")
                            .font(AppTheme.titleStyle(for: colorScheme).font)
                            .foregroundColor(AppTheme.titleStyle(for: colorScheme).color)
                            .shadow(color: AppTheme.titleStyle(for: colorScheme).shadow ?? .clear, radius: 1, x: 0, y: 1)
                        
                        Text(authViewModel.isLogin ? "Welcome back!" : "Create your account")
                            .font(AppTheme.subtitleStyle(for: colorScheme).font)
                            .foregroundColor(AppTheme.subtitleStyle(for: colorScheme).color)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // User type selection (only for signup)
                    if !authViewModel.isLogin {
                        HStack(spacing: 15) {
                            UserTypeButton(
                                title: "Student",
                                systemImage: "person.fill",
                                isSelected: authViewModel.userType == .student,
                                action: { authViewModel.userType = .student }
                            )
                            
                            UserTypeButton(
                                title: "Teacher",
                                systemImage: "person.2.fill",
                                isSelected: authViewModel.userType == .teacher,
                                action: { authViewModel.userType = .teacher }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Form fields
                    VStack(spacing: 16) {
                        // Email field
                        AppTextField(
                            iconName: "envelope.fill",
                            placeholder: "Email",
                            text: $authViewModel.email,
                            error: authViewModel.errorMessage.isEmpty ? nil : authViewModel.errorMessage
                        )
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        
                        // Password field
                        AppSecureField(
                            iconName: "lock.fill",
                            placeholder: "Password",
                            text: $authViewModel.password
                        )
                        .focused($focusedField, equals: .password)
                        .submitLabel(authViewModel.isLogin ? .done : .next)
                        .onSubmit {
                            if authViewModel.isLogin {
                                focusedField = nil
                                login()
                            } else {
                                focusedField = .confirmPassword
                            }
                        }
                        
                        // Confirm password field (only for signup)
                        if !authViewModel.isLogin {
                            AppSecureField(
                                iconName: "lock.shield.fill",
                                placeholder: "Confirm Password",
                                text: $authViewModel.confirmPassword
                            )
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                                signup()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action button
                    AppButton(
                        title: authViewModel.isLogin ? "Sign In" : "Create Account",
                        icon: "arrow.right.circle.fill"
                    ) {
                        focusedField = nil
                        if authViewModel.isLogin {
                            login()
                        } else {
                            signup()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Toggle between login and signup
                    HStack {
                        Text(authViewModel.isLogin ? "Don't have an account?" : "Already have an account?")
                            .foregroundColor(AppTheme.subtitleStyle(for: colorScheme).color)
                        
                        Button(action: {
                            withAnimation {
                                authViewModel.isLogin.toggle()
                                authViewModel.errorMessage = ""
                            }
                        }) {
                            Text(authViewModel.isLogin ? "Sign Up" : "Sign In")
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.gold)
                        }
                    }
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
    
    private func login() {
        Task {
            try await loginAccount()
            let currentUser = Auth.auth().currentUser
            if authViewModel.isAuthenticated {
                withAnimation(AppTheme.easeOutAnimation) {
                    isTransitioning = true
                }
                
                // Small delay to allow transition animation to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.transitionDuration) {
                    AppViewModel.state = (currentUser?.displayName == nil) ? .extraDetails : .home
                }
            } else {
                AppViewModel.state = .login
            }
        }
    }
    
    private func signup() {
        Task {
            try await createAccount()
            let currentUser = Auth.auth().currentUser
            if authViewModel.isAuthenticated {
                withAnimation(AppTheme.easeOutAnimation) {
                    isTransitioning = true
                }
                
                // Small delay to allow transition animation to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.transitionDuration) {
                    AppViewModel.state = (currentUser?.displayName == nil) ? .extraDetails : .home
                }
            } else {
                AppViewModel.state = .login
            }
        }
    }

    func createAccount() async throws {
        AppViewModel.isLoading = true
        
        defer {
            AppViewModel.isLoading = false
        }
        
        guard !authViewModel.email.isEmpty, !authViewModel.password.isEmpty else {
            authViewModel.errorMessage = "Please enter both email and password."
            return
        }
        
        guard authViewModel.password == authViewModel.confirmPassword else {
            authViewModel.errorMessage = "Passwords do not match."
            return
        }
        
        let result = try await authViewModel.createAccount(email: authViewModel.email, password: authViewModel.password)
        if (!result) {
            authViewModel.errorMessage = "Something went wrong."
            authViewModel.isAuthenticated = false
            return
        } else {
            authViewModel.isAuthenticated = true
        }
    }
    
    func loginAccount() async throws {
        AppViewModel.isLoading = true
        
        defer {
            AppViewModel.isLoading = false
        }

        guard !authViewModel.email.isEmpty, !authViewModel.password.isEmpty else {
            authViewModel.errorMessage = "Please enter both email and password."
            return
        }
        let result = try await authViewModel.loginAccount(email: authViewModel.email, password: authViewModel.password)
        if (!result) {
            authViewModel.errorMessage = "Something went wrong."
            return
        }
        authViewModel.isAuthenticated = true
    }
}

// MARK: - Supporting Views

struct UserTypeButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(isSelected ? AppTheme.gold : AppTheme.secondaryBackgroundColor(for: colorScheme))
            .foregroundColor(isSelected ? .white : AppTheme.textColor(for: colorScheme))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppTheme.gold : AppTheme.gold.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
