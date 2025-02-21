//
//  AppRouterViewModel.swift
//  SoundSphere
//
//  Created by Leon Kwan on 03/01/2025.
//

import Foundation

final class AppRouter: ObservableObject {
    enum TabTag {
        case home, profile, notifications, settings
    }

    @Published var selectedTabTag: TabTag = .home
    
}
