import SwiftUI
import Combine

class ContactViewModel: ObservableObject {
    @Published var contacts: [User] = []
    @Published var filteredContacts: [User] = []
    @Published var searchText = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearchListener()
    }

    func fetchContacts(userType: UserType) async {
        contacts = []
        filteredContacts = []
    }

    private func setupSearchListener() {
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] debouncedSearchText in
                guard let self = self else { return }
                Task {
                    await self.performSearch(debouncedSearchText)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func performSearch(_ username: String) async {
        guard !username.isEmpty else {
            filteredContacts = contacts
            return
        }

        isLoading = true
        do {
            // Find username that match the search query
            let contacts = try await searchApi().searchContacts(username: username)
            print(contacts)
            filteredContacts = contacts.filter { contact in
                let fullName = "\(contact.profile.firstName) \(contact.profile.lastName)".lowercased()
                return fullName.contains(username.lowercased())
            }
            print(filteredContacts)
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch search results."
            isLoading = false
        }
    }
}
