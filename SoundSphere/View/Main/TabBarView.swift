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
                    // TODO: Add more tabs
                    ScrollView {
                        Text("Profile")
                            .padding()
                        
                        Text("Settings")
                            .padding()
                    }
                    .refreshable {
                        // TODO: Refetch user details
                        // Mocking API call: Delay for 2 seconds
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                    }
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "person")
                                Text("CONTACT")
                            }
                        }
                        .tag(AppRouter.TabTag.profile)
                    HomeView(userViewModel: userViewModel)
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "house")
                                Text("HOME")
                            }
                        }
                        .tag(AppRouter.TabTag.home)
                    // TODO: Add more tabs
                    ScrollView {
                        Text("ANOTHER PAGE")
                            .padding()
                    }
                    .refreshable {
                        // TODO: Refetch user details
                        // Mocking API call: Delay for 2 seconds
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                    }
                        .tabItem {
                            VStack(spacing: 10) {
                                Image(systemName: "bell")
                                Text("ANOTHER")
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
