import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                }
                
                // Account & Preferences Section
                Section {
                    NavigationLink {
                        Text("Account Settings")
                    } label: {
                        Label("Account", systemImage: "person.circle")
                    }
                    
                    NavigationLink {
                        Text("Privacy")
                    } label: {
                        Label("Privacy", systemImage: "lock.shield")
                    }
                    
                    NavigationLink {
                        Text("Help & Support")
                    } label: {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }
                
                // Version Info Section
                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive, action: logout)
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            appViewModel.checkAuthentication()
        } catch {
            print("⚠️ Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppViewModel())
}
