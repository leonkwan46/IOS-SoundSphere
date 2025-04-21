//
//  File.swift
//  SoundSphere
//
//  Created by Leon Kwan on 22/03/2025.
//

import Foundation
import FirebaseAuth

class searchApi {
    func searchContacts(username: String) async throws -> [User] {
        guard let url = URL(string: "http://localhost:3000/search/search-username?username=\(username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            return []
        }
        
        let idToken = try await userApi().getIDToken()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            if (httpResponse.statusCode == 200) {
                return try JSONDecoder().decode([User].self, from: data)
            } else {
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorDescription = errorMessage["error"] {
                    print("Server error: \(errorDescription)")
                    throw CustomError.serverError(errorDescription)
                } else {
                    print("Unexpected error: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            }
            
        } catch {
            print("Request failed with error: \(error.localizedDescription)")
            throw URLError(.badServerResponse)
        }

    }
}
