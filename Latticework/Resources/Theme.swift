import SwiftUI

/// Warm "paper & ink" design system. Apple HIG-native, content-first.
enum Theme {
    static let paper = Color("Paper", bundle: nil) // fallback below if asset missing
    static let accent = Color(red: 0.72, green: 0.52, blue: 0.04)   // muted brass/gold
    static let ink = Color(red: 0.11, green: 0.11, blue: 0.10)

    // Serif font for quotes — gives Munger's words gravitas.
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

extension Color {
    /// Warm cream background that adapts to dark mode.
    static let appBackground = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
}
