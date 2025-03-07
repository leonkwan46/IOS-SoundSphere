//
//  HomePage.swift
//  SoundSphere
//
//  Created by Leon Kwan on 08/12/2024.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Greeting Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello, \(userViewModel.user?.email ?? "Leon") 👋")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        Text("You've got \(userViewModel.user?.firebaseId ?? "") tasks to do!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 12) {
                        ProgressCard(
                            title: "Overall Progress",
                            count: "4",
                            total: "7",
                            color: AppTheme.gold
                        )
                    }
                    .padding(.horizontal)
                    
                    // My Teachers Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My Teachers")
                            .font(.headline)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<5) { index in
                                    TeacherButton(
                                        name: "John Doe \(index + 1)",
                                        role: "Piano Teacher"
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Ongoing Homework Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ongoing Homework")
                            .font(.headline)
                            .foregroundColor(AppTheme.textColor(for: colorScheme))
                        
                        VStack(spacing: 12) {
                            ForEach(0..<3) { index in
                                HomeworkCard(
                                    title: "Piano Practice",
                                    description: "Practice scales and arpeggios",
                                    dueDate: "Due in 2 days",
                                    progress: 0.7
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                // TODO: Refetch user details
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }
}

// MARK: - Supporting Views

struct ProgressCard: View {
    let title: String
    let count: String
    let total: String
    let color: Color
    
    private var percentage: Double {
        guard let countNum = Double(count),
              let totalNum = Double(total) else { return 0 }
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
                    .stroke(AppTheme.gold, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(percentage * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.gold)
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
                            .foregroundColor(AppTheme.gold)
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
    HomeView(userViewModel: UserViewModel())
}
