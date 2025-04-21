//
//  ContactHeader.swift
//  SoundSphere
//
//  Created by Leon Kwan on 22/03/2025.
//

import SwiftUI

struct ContactHeader: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Text("Contacts")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                    .font(AppTheme.titleStyle(for: colorScheme).font)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)        
    }
}

#Preview {
    ContactHeader()
}
