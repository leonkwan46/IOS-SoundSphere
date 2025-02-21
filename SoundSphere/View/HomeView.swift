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
                Text("You've got \(userViewModel.user?.id ?? 0) tasks to do!")
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
            // TODO: Refetch user details
            // Mocking API call: Delay for 2 seconds
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
    
    // Maybe we should do it in TabBarView instead (NO, each screen might have different API call)
//    private func refreshPage() async {
//        let idToken = Auth.auth().currentUser?.uid ?? ""
//        do {
//            let user = try await userViewModel.fetchUser(idToken: idToken)
//            print(user)
//        } catch {
//            print(error)
//        }
//    }
}
