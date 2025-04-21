//
//  ContactList.swift
//  SoundSphere
//
//  Created by Leon Kwan on 22/03/2025.
//

import SwiftUI

struct ContactList: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showAddContactSheet: Bool
    public var userViewModel: UserViewModel
    public var contactViewModel: ContactViewModel
    
    var body: some View {
        if contactViewModel.filteredContacts.isEmpty {
            VStack(spacing: 15) {
                Image(systemName: "person.3.sequence")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.gold.opacity(0.5))
                    .padding(.bottom, 10)
                
                Text("No Contacts Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                
                Text(userViewModel.user?.userType == .teacher ?
                     "Add students to your contact list to connect with them." :
                        "Add teachers to your contact list to connect with them.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.textColor(for: colorScheme).opacity(0.7))
                .padding(.horizontal, 40)
                
                Button(action: {
                    showAddContactSheet = true
                }) {
                    Image(systemName: "person.badge.plus")
                    Text("Add Your First Contact")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(AppTheme.gold)
                .cornerRadius(10)

            }
            .padding(.top, 60)
            .padding(.horizontal, 20)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(contactViewModel.filteredContacts, id: \.firebaseId) { contact in
                    ContactRow(contact: contact)
                        .environmentObject(userViewModel)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContactList(showAddContactSheet: .constant(false), userViewModel: UserViewModel(), contactViewModel: ContactViewModel())
}
