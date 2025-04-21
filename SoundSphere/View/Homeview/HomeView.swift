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
                        
                        Text("You've got \(MockData.taskCount) tasks to do!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 12) {
                        ProgressCard(
                            title: "Overall Progress",
                            count: "\(MockData.tasksDone)",
                            total: "\(MockData.taskCount)",
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
                                ForEach(MockData.teachers, id: \.name) { teacher in
                                    TeacherButton(name: teacher.name, role: teacher.role)
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
                            ForEach(MockData.homework, id: \.title) { item in
                                HomeworkCard(
                                    title: item.title,
                                    description: item.description,
                                    dueDate: item.dueDate,
                                    progress: item.progress
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

// MARK: - Dummy Data
struct MockData {
    static let taskCount = 9
    static let tasksDone = 4
    
    struct Teacher {
        let name: String
        let role: String
    }
    
    static let teachers: [Teacher] = [
        Teacher(name: "John Doe 1", role: "Piano Teacher"),
        Teacher(name: "John Doe 2", role: "Violin Teacher"),
        Teacher(name: "John Doe 3", role: "Vocal Coach"),
        Teacher(name: "John Doe 4", role: "Guitar Teacher"),
        Teacher(name: "John Doe 5", role: "Drums Teacher")
    ]
    
    struct Homework {
        let title: String
        let description: String
        let dueDate: String
        let progress: Double
    }
    
    static let homework: [Homework] = [
        Homework(title: "Piano Practice", description: "Practice scales and arpeggios", dueDate: "Due in 2 days", progress: 0.7),
        Homework(title: "Sight Reading", description: "Read two new pieces", dueDate: "Due in 3 days", progress: 0.4),
        Homework(title: "Theory Exercise", description: "Complete workbook page 12", dueDate: "Due in 5 days", progress: 0.9)
    ]
}

#Preview {
    HomeView(userViewModel: UserViewModel())
}
