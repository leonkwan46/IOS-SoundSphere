import SwiftUI

struct ContactView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var contactViewModel: ContactViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var searchText = ""
    @State private var showAddContactSheet = false

    var body: some View {
        VStack {
            // Top Nav Bar
            ContactTopNavBar(title: "", showTitle: true, showAddContactSheet: $showAddContactSheet, userViewModel: userViewModel, contactViewModel: contactViewModel)
            
            ScrollView {
                VStack {
                    // Header
                    ContactHeader()

                    // Contact List
                    ContactList(showAddContactSheet: $showAddContactSheet, userViewModel: userViewModel, contactViewModel: contactViewModel)
                }
                .padding(20)
            }
            .refreshable {
                await contactViewModel.fetchContacts(userType: userViewModel.user?.userType ?? .student)
            }
            .onAppear {
                Task {
                    await contactViewModel.fetchContacts(userType: userViewModel.user?.userType ?? .student)
                }
            }
        }
        .sheet(isPresented: $showAddContactSheet) {
            AddContactView(userViewModel: userViewModel, contactViewModel: contactViewModel)
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ContactView(contactViewModel: ContactViewModel(), userViewModel: UserViewModel())
}
