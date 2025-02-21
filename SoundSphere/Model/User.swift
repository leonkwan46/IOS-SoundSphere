//
//  User.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//
import Foundation
import FirebaseAuth

enum UserRole: String, Decodable {
    case student = "student"
    case teacher = "teacher"
    case admin = "admin"
}

struct User: Decodable {
    let id: Int
    let email: String
    let role: UserRole
    let isActive: Bool
    let isDeleted: Bool
}

struct AuthTokenResult: Decodable {
    let authToken: String
}
