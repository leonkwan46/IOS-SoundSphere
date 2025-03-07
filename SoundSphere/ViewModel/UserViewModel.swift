//
//  UserViewModel.swift
//  SoundSphere
//
//  Created by Leon Kwan on 23/12/2024.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    
    func fetchUser() async throws -> User {
        let user = try await userApi().fetchUserData()
        self.user = user
        return user
    }
}
