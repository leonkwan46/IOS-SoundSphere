//
//  Contact.swift
//  SoundSphere
//
//  Created by Leon Kwan on 15/03/2025.
//

import Foundation

struct Contact: Identifiable {
    let id = UUID()
    let firebaseId: String
    let email: String
    let note: String
    let userType: UserType
}
