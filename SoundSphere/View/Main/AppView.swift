//
//  AppView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 03/01/2025.
//

import Foundation
import SwiftUI

struct AppView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var appViewModel = AppViewModel()
    // Bottom Nav after authentication
    @StateObject var appRouter = AppRouter()
    @State private var isTransitioning = false

    var body: some View {
        ZStack {
            AppTheme.backgroundColor(for: colorScheme)
                .ignoresSafeArea()

            VStack {
                switch appViewModel.state {
                    case .login:
                        AuthView()
                            .transition(.opacity)
                    case .extraDetails:
                        ExtraDetailsView()
                            .transition(.opacity)
                    case .home:
                        TabBarView()
                            .transition(.opacity)
                    case .splash:
                        SplashView()
                            .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appViewModel.state)
            
            if appViewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear() {
            // Auto-login feature
            // Show splash screen for 3 seconds to allow animations to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isTransitioning = true
                }
                
                // Small delay to allow transition animation to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appViewModel.checkAuthentication()
                }
            }
        }
        .environmentObject(appViewModel)
        .environmentObject(appRouter)
    }
}

#Preview {
    AppView()
}
