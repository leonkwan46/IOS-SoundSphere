import SwiftUI

struct GoldenParticlesView: View {
    let count: Int
    let isTransitioning: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ForEach(0..<count) { index in
            Circle()
                .fill(AppTheme.gold.opacity(colorScheme == .dark ? 
                    Double.random(in: 0.05...0.15) : 
                    Double.random(in: 0.15...0.35)))
                .frame(width: CGFloat.random(in: colorScheme == .dark ? 2...5 : 4...7))
                .shadow(color: AppTheme.gold.opacity(colorScheme == .dark ? 0.3 : 0.5), radius: colorScheme == .dark ? 2 : 3)
                .position(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
                .opacity(isTransitioning ? 0 : 1)
        }
    }
}

#Preview {
    ZStack {
        AppTheme.backgroundGradient(for: .light)
        GoldenParticlesView(count: 30, isTransitioning: false)
    }
} 