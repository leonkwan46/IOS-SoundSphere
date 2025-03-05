import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var rotationAngle: Double = 0
    @State private var waveOffset: CGFloat = 0
    @State private var showAppName = false
    @State private var showTagline = false
    @State private var musicBars: [CGFloat] = [0.2, 0.4, 0.6, 0.8, 0.6, 0.4, 0.2]
    @State private var isTransitioning = false
    
    var body: some View {
        ZStack {
            // Background gradient
            AppTheme.darkGradient
                .ignoresSafeArea()
            
            // Golden particles (small dots)
            ForEach(0..<30) { index in
                Circle()
                    .fill(AppTheme.gold.opacity(Double.random(in: 0.1...0.3)))
                    .frame(width: CGFloat.random(in: 2...5))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(isTransitioning ? 0 : 1)
            }
            
            // Sound waves animation
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(AppTheme.gold.opacity(0.3), lineWidth: 2)
                        .scaleEffect(logoScale + CGFloat(index) * 0.4 + waveOffset)
                        .opacity(max(0, 0.8 - Double(index) * 0.3 - Double(waveOffset)))
                }
            }
            .animation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: false),
                value: waveOffset
            )
            .onAppear {
                waveOffset = 0.5
            }
            
            // Logo and text
            VStack(spacing: 20) {
                // Logo
                ZStack {
                    // Outer circle with golden gradient
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppTheme.gold,
                                    AppTheme.darkGold
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: AppTheme.gold.opacity(0.5), radius: 15, x: 0, y: 5)
                    
                    // Inner circle for depth
                    Circle()
                        .fill(AppTheme.darkBackgroundSecondary)
                        .frame(width: 100, height: 100)
                    
                    // Music equalizer bars
                    HStack(spacing: 4) {
                        ForEach(0..<7) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.gold, AppTheme.darkGold],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 4, height: 40 * musicBars[index])
                                .animation(
                                    Animation.easeInOut(duration: 0.5)
                                        .repeatForever()
                                        .delay(Double(index) * 0.1),
                                    value: musicBars[index]
                                )
                        }
                    }
                    
                    // Music note
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(rotationAngle))
                        .opacity(0.9)
                        .shadow(color: AppTheme.gold.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .scaleEffect(isTransitioning ? 1.5 : 1.0)
                .opacity(isTransitioning ? 0 : 1.0)
                
                // App name
                Text("SoundSphere")
                    .font(AppTheme.titleStyle.font)
                    .foregroundColor(AppTheme.titleStyle.color)
                    .shadow(color: AppTheme.titleStyle.shadow ?? .clear, radius: 2, x: 0, y: 1)
                    .opacity(showAppName ? (isTransitioning ? 0 : 1) : 0)
                    .offset(y: showAppName ? 0 : 20)
                
                // Tagline
                Text("Your musical journey begins here")
                    .font(AppTheme.subtitleStyle.font)
                    .foregroundColor(AppTheme.subtitleStyle.color)
                    .opacity(showTagline ? (isTransitioning ? 0 : 1) : 0)
                    .offset(y: showTagline ? 0 : 10)
                
                // Animated music bars at the bottom
                if showTagline {
                    HStack(spacing: 6) {
                        ForEach(0..<5) { index in
                            GoldenMusicBar(delay: Double(index) * 0.2, isTransitioning: isTransitioning)
                        }
                    }
                    .padding(.top, 30)
                    .transition(.opacity)
                }
            }
            .opacity(isTransitioning ? 0 : 1)
        }
        .onAppear {
            // Sequence of animations
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            // Animate music bars
            animateMusicBars()
            
            // Delayed animations for text
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showAppName = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.8)) {
                        showTagline = true
                    }
                }
            }
            
            // Start transition animation before the view is removed
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isTransitioning = true
                }
            }
        }
    }
    
    private func animateMusicBars() {
        // Create a repeating animation for the music bars
        let newValues: [CGFloat] = [0.6, 0.8, 1.0, 0.5, 0.7, 0.9, 0.4]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                musicBars = newValues
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateMusicBars()
            }
        }
    }
}

// MARK: - Supporting Views

struct GoldenMusicBar: View {
    let delay: Double
    let isTransitioning: Bool
    @State private var height: CGFloat = 0.1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [AppTheme.gold, AppTheme.darkGold],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 4, height: 30 * height)
            .opacity(isTransitioning ? 0 : 1)
            .shadow(color: AppTheme.gold.opacity(0.5), radius: 2, x: 0, y: 0)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever()
                        .delay(delay)
                ) {
                    height = CGFloat.random(in: 0.4...1.0)
                }
                
                // Keep changing the height randomly
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        height = CGFloat.random(in: 0.4...1.0)
                    }
                }
            }
    }
}

// MARK: - Helper Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    SplashView()
} 