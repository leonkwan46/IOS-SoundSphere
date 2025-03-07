import SwiftUI

struct ContactView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(AppTheme.gold)
                        .shadow(color: AppTheme.gold.opacity(0.3), radius: 8, x: 0, y: 3)
                    
                    Text("Contacts")
                        .font(AppTheme.titleStyle(for: colorScheme).font)
                        .foregroundColor(AppTheme.titleStyle(for: colorScheme).color)
                }
                .padding(.top, 20)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.gold)
                    TextField("Search contacts", text: .constant(""))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(AppTheme.secondaryBackgroundColor(for: colorScheme))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Contact List
                VStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        ContactRow(name: "John Doe \(index + 1)", role: "Teacher")
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            // TODO: Refetch contacts
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}

struct ContactRow: View {
    let name: String
    let role: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            Circle()
                .fill(AppTheme.gold.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.gold)
                )
            
            // Contact Info
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                
                Text(role)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Action Button
            Button(action: {
                // TODO: Implement contact action
            }) {
                Image(systemName: "message")
                    .foregroundColor(AppTheme.gold)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(AppTheme.secondaryBackgroundColor(for: colorScheme))
        .cornerRadius(10)
        .padding(.vertical, 4)
    }
}

#Preview {
    ContactView()
} 