//
//  TopNavBar.swift
//  SoundSphere
//
//  Created by Leon Kwan on 15/03/2025.
//

import SwiftUI

import SwiftUI

struct ContactTopNavBar: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var showTitle: Bool
    @Binding var showAddContactSheet: Bool
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var contactViewModel: ContactViewModel

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .opacity(showTitle ? 1 : 0)

            Spacer()
            
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .background(AppTheme.gold)
                .clipShape(Circle())
                .onTapGesture {
                    showAddContactSheet.toggle()
                }
        }
        .padding()
        .background(AppTheme.darkBackground)
    }
}

#Preview {
    ContactTopNavBar(title: "Contacts", showTitle: false, showAddContactSheet: .constant(false), userViewModel: UserViewModel(), contactViewModel: ContactViewModel())
}
