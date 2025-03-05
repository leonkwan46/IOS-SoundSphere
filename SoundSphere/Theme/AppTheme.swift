import SwiftUI

// MARK: - Theme Colors
enum AppTheme {
    // Base colors
    static let gold = Color(hex: "FFD700")
    static let darkGold = Color(hex: "B8860B")
    static let goldenRod = Color(hex: "DAA520")
    static let lemonChiffon = Color(hex: "FFFACD")
    
    // Background colors
    static let darkBackground = Color(hex: "1A1A1A")
    static let darkBackgroundSecondary = Color(hex: "2D2D2D")
    
    // Gradients
    static let goldGradient = LinearGradient(
        colors: [
            gold.opacity(0.8),
            darkGold.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let darkGradient = LinearGradient(
        colors: [
            darkBackground,
            darkBackgroundSecondary
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Text styles
    static let titleStyle = TextStyle(
        font: .system(size: 32, weight: .bold, design: .rounded),
        color: .white,
        shadow: gold.opacity(0.4)
    )
    
    static let subtitleStyle = TextStyle(
        font: .system(size: 16, weight: .medium),
        color: lemonChiffon.opacity(0.9)
    )
    
    // Button styles
    static let primaryButtonStyle = ButtonStyle(
        background: goldGradient,
        foregroundColor: .white,
        cornerRadius: 15,
        shadow: gold.opacity(0.3)
    )
    
    // Form field styles
    static let formFieldStyle = FormFieldStyle(
        background: Color.white.opacity(0.08),
        border: gold.opacity(0.2),
        cornerRadius: 12
    )
    
    // Animation durations
    static let transitionDuration: Double = 0.5
    static let springAnimation = Animation.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)
    static let easeOutAnimation = Animation.easeOut(duration: 0.5)
}

// MARK: - Supporting Types
struct TextStyle {
    let font: Font
    let color: Color
    let shadow: Color?
    
    init(font: Font, color: Color, shadow: Color? = nil) {
        self.font = font
        self.color = color
        self.shadow = shadow
    }
}

struct ButtonStyle {
    let background: LinearGradient
    let foregroundColor: Color
    let cornerRadius: CGFloat
    let shadow: Color
}

struct FormFieldStyle {
    let background: Color
    let border: Color
    let cornerRadius: CGFloat
}

// MARK: - View Modifiers
struct AppButtonStyle: ViewModifier {
    let style: ButtonStyle
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(style.background)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(color: style.shadow, radius: 8, x: 0, y: 3)
    }
}

struct AppFormFieldStyle: ViewModifier {
    let style: FormFieldStyle
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(style.border, lineWidth: 1)
                    )
            )
    }
}

// MARK: - View Extensions
extension View {
    func appButtonStyle(_ style: ButtonStyle) -> some View {
        modifier(AppButtonStyle(style: style))
    }
    
    func appFormFieldStyle(_ style: FormFieldStyle) -> some View {
        modifier(AppFormFieldStyle(style: style))
    }
}

// MARK: - Reusable Components
struct AppTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(AppTheme.gold)
                    .frame(width: 24)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.gold.opacity(0.7))
                    }
                }
            }
            .appFormFieldStyle(AppTheme.formFieldStyle)
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 12)
                    .transition(.opacity)
            }
        }
    }
}

struct AppSecureField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecured: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(AppTheme.gold)
                .frame(width: 24)
            
            if isSecured {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            
            Button(action: { isSecured.toggle() }) {
                Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(AppTheme.gold.opacity(0.7))
            }
        }
        .appFormFieldStyle(AppTheme.formFieldStyle)
    }
}

struct AppButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .imageScale(.medium)
                }
            }
        }
        .appButtonStyle(AppTheme.primaryButtonStyle)
    }
} 