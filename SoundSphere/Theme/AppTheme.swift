import SwiftUI

// MARK: - Theme Colors
enum AppTheme {
    // Base colors
    static let gold = Color(hex: "FFD700")
    static let darkGold = Color(hex: "B8860B")
    static let goldenRod = Color(hex: "DAA520")
    static let lemonChiffon = Color(hex: "FFFACD")
    
    // Light theme colors
    static let lightBackground = Color(hex: "F8F9FF")  // Soft blue-white
    static let lightBackgroundSecondary = Color(hex: "FFFFFF")  // Pure white
    static let lightAccent = Color(hex: "E8ECFF")  // Very light blue
    static let lightText = Color(hex: "2D3436")  // Dark gray
    static let lightTextSecondary = Color(hex: "636E72")  // Medium gray
    
    // Dark theme colors
    static let darkBackground = Color(hex: "1A1A1A")
    static let darkBackgroundSecondary = Color(hex: "2D2D2D")
    static let darkText = Color(hex: "FFFFFF")
    static let darkTextSecondary = Color(hex: "CCCCCC")
    
    // Dynamic colors based on color scheme
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkBackground : lightBackground
    }
    
    static func secondaryBackgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkBackgroundSecondary : lightBackgroundSecondary
    }
    
    static func textColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkText : lightText
    }
    
    static func secondaryTextColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkTextSecondary : lightTextSecondary
    }
    
    // Dynamic gradients based on color scheme
    static func backgroundGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    darkBackground,
                    darkBackgroundSecondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    lightBackground,
                    lightAccent,
                    lightBackgroundSecondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // Text styles
    static func titleStyle(for colorScheme: ColorScheme) -> TextStyle {
        TextStyle(
            font: .system(size: 32, weight: .bold, design: .rounded),
            color: textColor(for: colorScheme),
            shadow: colorScheme == .dark ? gold.opacity(0.4) : nil
        )
    }
    
    static func subtitleStyle(for colorScheme: ColorScheme) -> TextStyle {
        TextStyle(
            font: .system(size: 16, weight: .medium),
            color: secondaryTextColor(for: colorScheme)
        )
    }
    
    // Button styles
    static func primaryButtonStyle(for colorScheme: ColorScheme) -> ButtonStyle {
        ButtonStyle(
            background: LinearGradient(
                colors: [
                    gold.opacity(0.8),
                    darkGold.opacity(0.8)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            foregroundColor: .white,
            cornerRadius: 15,
            shadow: gold.opacity(0.3)
        )
    }
    
    // Form field styles
    static func formFieldStyle(for colorScheme: ColorScheme) -> FormFieldStyle {
        if colorScheme == .dark {
            return FormFieldStyle(
                background: Color.white.opacity(0.08),
                border: gold.opacity(0.2),
                cornerRadius: 12
            )
        } else {
            return FormFieldStyle(
                background: Color.white,
                border: lightAccent,
                cornerRadius: 12
            )
        }
    }
    
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
    
    func appSheetStyle(colorScheme: ColorScheme) -> some View {
        self
            .background(AppTheme.backgroundColor(for: colorScheme))
            .presentationBackground(AppTheme.backgroundColor(for: colorScheme))
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(20)
            .presentationBackgroundInteraction(.enabled)
    }
}

// MARK: - Reusable Components
struct AppTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var error: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(AppTheme.gold)
                    .frame(width: 24)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.gold.opacity(0.7))
                    }
                }
            }
            .appFormFieldStyle(AppTheme.formFieldStyle(for: colorScheme))
            
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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(AppTheme.gold)
                .frame(width: 24)
            
            if isSecured {
                SecureField(placeholder, text: $text)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(AppTheme.textColor(for: colorScheme))
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            
            Button(action: { isSecured.toggle() }) {
                Image(systemName: isSecured ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(AppTheme.gold.opacity(0.7))
            }
        }
        .appFormFieldStyle(AppTheme.formFieldStyle(for: colorScheme))
    }
}

struct AppButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
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
        .appButtonStyle(AppTheme.primaryButtonStyle(for: colorScheme))
    }
}

// MARK: - UIKit Extensions
extension UIColor {
    convenience init(_ color: Color) {
        let components = color.components()
        self.init(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
}

extension Color {
    func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 1.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
} 