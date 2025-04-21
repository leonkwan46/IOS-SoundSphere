//
//  MainPages.swift
//  SoundSphere
//
//  Created by Leon Kwan on 23/12/2024.
//

import SwiftUI
import FirebaseAuth

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var userViewModel = UserViewModel()
    @StateObject var contactViewModel = ContactViewModel()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $appRouter.selectedTabTag) {
                Group {
                    // Contact tab
                    ContactView(contactViewModel: contactViewModel, userViewModel: userViewModel)
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "person.2")
                                Text("CONTACTS")
                            }
                        }
                        .tag(AppRouter.TabTag.profile)
                    
                    // Home tab
                    HomeView(userViewModel: userViewModel)
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "house")
                                Text("HOME")
                            }
                        }
                        .tag(AppRouter.TabTag.home)
                    
                    // Notifications tab
                    Text("Notifications")
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "bell")
                                Text("NOTIFICATIONS")
                            }
                        }
                        .tag(AppRouter.TabTag.notifications)
                    
                    // Settings tab
                    SettingsView()
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "gear")
                                Text("SETTINGS")
                            }
                        }
                        .tag(AppRouter.TabTag.settings)
                }
            }
        }.onAppear() {
            Task {
                let _ = try await userViewModel.fetchUser()
            }
        }.background() {
            AppTheme.backgroundColor(for: colorScheme)
        }
    }
}
