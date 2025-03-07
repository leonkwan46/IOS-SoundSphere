//
//  MainPages.swift
//  SoundSphere
//
//  Created by Leon Kwan on 23/12/2024.
//

import SwiftUI
import FirebaseAuth

struct TabBarView: View {
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var userViewModel = UserViewModel()
    
    init () {
        _userViewModel = StateObject(wrappedValue: UserViewModel())
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $appRouter.selectedTabTag) {
                Group {
                    // Profile tab
                    ScrollView {
                        Text("Profile")
                            .padding()
                        
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .padding()
                        }
                    }
                    .refreshable {
                        // TODO: Refetch user details
                        // Mocking API call: Delay for 2 seconds
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                    }
                    .tabItem {
                        VStack(spacing: 10) {
                            Image(systemName: "person")
                            Text("PROFILE")
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
            // TODO: Fetch user details
        }
    }
}
