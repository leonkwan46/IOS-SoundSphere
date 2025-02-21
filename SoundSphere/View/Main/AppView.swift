//
//  AppView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 03/01/2025.
//

import Foundation
import SwiftUI

struct AppView: View {
    @StateObject var appViewModel = AppViewModel()

    // Bottom Nav after authentication
    @StateObject var appRouter = AppRouter()

    var body: some View {
        ZStack {
            VStack {
                switch appViewModel.state {
                    case .login:
                        AuthView()
                    case .extraDetails:
                        ExtraDetailsView()
                    case .home:
                        TabBarView()
                    case .splash:
                        Text("SPLASH SCREEN")
                }
            }
            if appViewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear() {
            // Auto-login feature
            // Show splash screen for 2 seconds (currently 1 seconds for Dev)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appViewModel.checkAuthentication()
            }
        }
        .environmentObject(appViewModel)
        .environmentObject(appRouter)
    }
}
