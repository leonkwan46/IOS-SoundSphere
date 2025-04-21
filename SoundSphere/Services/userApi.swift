//
//  WebServices.swift
//  SoundSphere
//
//  Created by Leon Kwan on 15/12/2024.
//

import Foundation
import FirebaseAuth

enum NetworkError: Error {
    case responseError
    case decodingError
    case invalidURL
}

enum UserError: Error {
    case decodingError
}

class userApi {
    func getIDToken() async throws -> String {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in"])
        }
        return try await currentUser.getIDToken()
    }
    
    func fetchUserData() async throws -> User {
        let idToken = try await getIDToken()

        guard let url = URL(string: "http://localhost:3000/users/get-user-data") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print(data)
            print(response)
                        
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            if httpResponse.statusCode == 200 {
                // Handle success
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } else {
                // Parse the error response body
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                let errorDescription = errorMessage["error"] {
                    print("Server error: \(errorDescription)")
                    throw CustomError.serverError(errorDescription)
                } else {
                    print("Unexpected error: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            }
        }
    }

    func updateUserDetails(username: String, firstName: String, lastName: String, age: Int, gender: String) async throws -> Bool {
        let idToken = try await getIDToken()

        guard let url = URL(string: "http://localhost:3000/users/update-user-profile") else {
            throw URLError(.badURL)
        }
        
        let requestBody = ["username": username, "firstName": firstName, "lastName": lastName, "age": age, "gender": gender] as [String : Any]
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            if httpResponse.statusCode == 200 {
                return true
            } else {
                // Parse the error response body
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorDescription = errorMessage["error"] {
                    print("Server error: \(errorDescription)")
                    throw CustomError.serverError(errorDescription)
                } else {
                    print("Unexpected error: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
            }
        }
    }
    
    func checkUsernameAvailability(username: String) async throws -> Bool {
        guard let url = URL(string: "http://localhost:3000/users/check-username-availability") else {
            return false
        }
        
        let requestBody = ["username": username]
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        let idToken = try await getIDToken()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let errorMessage = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorDescription = errorMessage["error"] {
                    throw CustomError.serverError(errorDescription)
                }
                throw URLError(.badServerResponse)
            }
    
            let result = try JSONDecoder().decode([String: Bool].self, from: data)
            return result["isAvailable"] ?? false
        } catch {
            return false
        }
    }
}
