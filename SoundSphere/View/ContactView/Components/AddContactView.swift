import SwiftUI

struct AddContactView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var contactViewModel: ContactViewModel

    var userType: UserType {
        userViewModel.user?.userType ?? .student
    }

    var body: some View {
        VStack(spacing: 20) {
            // Give space to the grabber bar
            Spacer().frame(height: 10)
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.gold)
                TextField(userType == .student ? "Search Teachers" : "Search Students", text: $contactViewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                    .autocapitalization(.none)
            }
            .padding()
            .background(AppTheme.secondaryBackgroundColor(for: colorScheme))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Search Result List
            if contactViewModel.isLoading {
                Spacer()
                ProgressView("Searching...")
                    .padding()
            } else if contactViewModel.filteredContacts.isEmpty {
                Spacer()
                Text("No results found")
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(contactViewModel.filteredContacts, id: \.firebaseId) { contact in
                        ContactRow(contact: contact)
                            .environmentObject(userViewModel)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddContactView(userViewModel: UserViewModel(), contactViewModel: ContactViewModel())
}
