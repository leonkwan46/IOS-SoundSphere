//
//  SwiftUIView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 08/03/2025.
//

import SwiftUI

struct ProfileImageView: View {
    let name: String
    
    var body: some View {
        Circle()
            .fill(AppTheme.gold.opacity(0.2))
            .frame(width: 50, height: 50)
            .overlay(
                Text(String(name.prefix(1)))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.gold)
            )
    }
}

#Preview {
    ProfileImageView(name: "John")
}
