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

    var body: some View {
        ScrollView {
            VStack {
                Text("Hello, \(userViewModel.user?.email ?? "Leon") 👋")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("You've got \(userViewModel.user?.firebaseId ?? "") tasks to do!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                if userViewModel.user?.userType == .teacher {
                    NavigationLink(destination: TeacherHomeView()) {
                        Text("Teacher Home")
                    }
                } else if userViewModel.user?.userType == .student {
                    NavigationLink(destination: StudentHomeView()) {
                        Text("Student Home")
                    }
                } else {
                    Text("Unknown Role")
                }
            }
            .padding()
        }
        .refreshable {
            await refreshPage()
        }
    }
    
   private func refreshPage() async {
       Task {
           let _ = try await userViewModel.fetchUser()
       }
   }
}

#Preview {
    HomeView(userViewModel: UserViewModel())
}
