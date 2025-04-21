//
//  SwiftUIView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 21/04/2025.
//

import SwiftUI

struct ProgressCard: View {
    let title: String
    let count: String
    let total: String
    let color: Color
    
    private var percentage: Double {
        guard let countNum = Double(count),
              let totalNum = Double(total),
              totalNum > 0 else { return 0 }
        return countNum / totalNum
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Circular Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(percentage * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Almost there!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("\(count)/\(total) tasks done")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Share Button
            Button(action: {
                // Share functionality to be implemented
            }) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(color)
                    )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ProgressCard(title: "Title", count: "count", total: "Totlal", color: Color.green)
}
