//
//  User.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//
import Foundation
import FirebaseAuth

enum UserType: String, Decodable {
    case student = "student"
    case teacher = "teacher"
    case admin = "admin"
}

struct User: Decodable {
    let firebaseId: String
    let email: String
    let username: String
    let userType: UserType
    let firstName: String
    let lastName: String
    let age: Int
    let gender: String
}

struct AuthTokenResult: Decodable {
    let authToken: String
}
