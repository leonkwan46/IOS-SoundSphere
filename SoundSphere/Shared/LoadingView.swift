//
//  LoadingScreen.swift
//  SoundSphere
//
//  Created by Leon Kwan on 03/01/2025.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        Color.black.opacity(0.5)  // Semi-transparent black overlay
            .edgesIgnoringSafeArea(.all)  // Fill the entire screen
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(3.5)
            .padding()
    }
}
