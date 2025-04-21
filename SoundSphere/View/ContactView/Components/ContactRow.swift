//
//  sdc.swift
//  SoundSphere
//
//  Created by Leon Kwan on 08/03/2025.
//

import SwiftUI

struct ContactRow: View {
    let contact: User
    @Environment(\.colorScheme) var colorScheme
    @State private var showOptions = false
    @EnvironmentObject private var userVM: UserViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            ProfileImageView(name: contact.profile.firstName)
            
            // Contact Info
            VStack(alignment: .leading, spacing: 4) {
                Text("\(contact.profile.firstName) \(contact.profile.lastName)")
                    .font(.headline)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                
                Text(contact.userType.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 15) {
                Button(action: {
                    // TODO: Implement message action
                }) {
                    Image(systemName: "message")
                        .foregroundColor(AppTheme.gold)
                }
                
                Button(action: {
                    showOptions = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(AppTheme.gold)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(AppTheme.secondaryBackgroundColor(for: colorScheme))
        .cornerRadius(10)
        .padding(.vertical, 4)
        .contextMenu {
            Button(role: .destructive, action: {
                // TODO: Implement remove contact
            }) {
                Label("Remove Contact", systemImage: "person.badge.minus")
            }
        }
    }
}

#Preview {
    let mockUser = User(
        firebaseId: "preview-id",
        email: "preview@example.com",
        username: "previewUser",
        userType: .student,
        profile: UserProfile(
            firstName: "Preview",
            lastName: "User",
            age: 25,
            gender: "Other"
        )
    )
    
    return ContactRow(contact: mockUser)
        .environmentObject(UserViewModel())
}
