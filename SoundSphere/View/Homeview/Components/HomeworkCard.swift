//
//  HomeworkCard.swift
//  SoundSphere
//
//  Created by Leon Kwan on 21/04/2025.
//

import SwiftUI

struct HomeworkCard: View {
    let title: String
    let description: String
    let dueDate: String
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(dueDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ProgressView(value: progress)
                .tint(AppTheme.gold)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeworkCard(title: "Title", description: "Description", dueDate: "dueDate", progress: 0.5)
}
