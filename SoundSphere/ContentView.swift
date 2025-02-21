//
//  ContentView.swift
//  SoundSphere
//
//  Created by Leon Kwan on 10/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        AppView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
