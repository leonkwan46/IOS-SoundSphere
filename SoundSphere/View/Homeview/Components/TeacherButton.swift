//
//  TeacherButton.swift
//  SoundSphere
//
//  Created by Leon Kwan on 21/04/2025.
//

import SwiftUI

struct TeacherButton: View {
    let name: String
    let role: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(AppTheme.gold.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.gold)
                )
            
            VStack(spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(role)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    TeacherButton(name: "John Doe", role: "Piano Teacher")
}
