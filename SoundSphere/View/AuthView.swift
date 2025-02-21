import SwiftUI
import FirebaseAuth

enum Role: String, CaseIterable, Identifiable {
    case teacher = "Teacher"
    case student = "Student"

    var id: String { self.rawValue }
}

struct AuthView: View {
    @EnvironmentObject var AppViewModel: AppViewModel
    @StateObject var authViewModel = AuthViewModel()
        
    var body: some View {
        VStack {
            Spacer()
            
            if !authViewModel.isLogin {
                HStack {
                    Button(action: {
                        authViewModel.role = .teacher
                    }) {
                        Text("Teacher")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(authViewModel.role == .teacher ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(authViewModel.role == .teacher ? .white : .black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        authViewModel.role = .student
                    }) {
                        Text("Student")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(authViewModel.role == .student ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(authViewModel.role == .student ? .white : .black)
                            .cornerRadius(10)
                    }
                }
                .frame(height: 50)
                .padding()
            }


            TextField("Email", text: $authViewModel.email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $authViewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !authViewModel.isLogin {
                SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(authViewModel.isLogin ? "Login" : "Create Account") {
                Task {
                    try await authViewModel.isLogin ? loginAccount() : createAccount()
                    let currentUser = Auth.auth().currentUser
                    if authViewModel.isAuthenticated {
                        AppViewModel.state = (currentUser?.displayName == nil) ? .extraDetails : .home
                    } else {
                        AppViewModel.state = .login
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text(authViewModel.errorMessage)
                .foregroundColor(.red)
            Spacer()

            Text(authViewModel.isLogin ? "Don't have an account?" : "Already have an account?")
                .onTapGesture {
                    authViewModel.isLogin.toggle()
                }
            Text(authViewModel.isLogin ? "Create Account" : "Login")
                .onTapGesture {
                    authViewModel.isLogin.toggle()
                }
                .foregroundColor(.blue)
            Spacer()
        }
        .padding()
    }

    func createAccount() async throws {
        AppViewModel.isLoading = true
        
        // print out all the properties
        print(authViewModel.email)
        print(authViewModel.password)
        print(authViewModel.role)
                
        defer {
            AppViewModel.isLoading = false
        }
        guard !authViewModel.email.isEmpty, !authViewModel.password.isEmpty else {
            authViewModel.errorMessage = "Please enter both email and password."
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
