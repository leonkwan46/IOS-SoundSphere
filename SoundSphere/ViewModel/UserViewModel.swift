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
    
    func fetchUser(idToken: String) async throws -> User {
        return try await userApi().getUserData()
    }
}
