//
//  Item.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
