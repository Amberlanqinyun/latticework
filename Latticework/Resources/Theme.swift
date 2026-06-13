import SwiftUI

/// Notion-clean design system. Open Sans only; restrained monochrome palette.
/// Tokens mirror `skills/latticework/references/design-system.md`.
enum Theme {
    // MARK: Color tokens
    static let page  = Color(hex: 0xF7F6F3)   // app canvas
    static let bg    = Color(hex: 0xFFFFFF)   // surfaces
    static let ink   = Color(hex: 0x37352F)   // primary text / primary button / active
    static let ink2  = Color(hex: 0x787774)   // secondary text
    static let faint = Color(hex: 0x9B9A97)   // tertiary / labels / inactive
    static let line  = Color(hex: 0x37352F).opacity(0.09)
    static let line2 = Color(hex: 0x37352F).opacity(0.15)
    static let tag   = Color(hex: 0xF1F0EE)
    static let tint  = Color(hex: 0xFBFBFA)
    static let green = Color(hex: 0x448361)
    static let red   = Color(hex: 0xC4554D)
    static let body  = Color(hex: 0x4B4943)

    // MARK: Type — Open Sans only.
    // Bundle OpenSans-*.ttf and register via Info.plist `UIAppFonts`.
    // Falls back to the system font if the family isn't installed.
    static func font(_ size: CGFloat, _ weight: OpenSansWeight = .regular, italic: Bool = false) -> Font {
        let name = italic ? weight.italicPostScript : weight.postScript
        return .custom(name, size: size)
    }

    enum OpenSansWeight {
        case light, regular, medium, semibold, bold
        var postScript: String {
            switch self {
            case .light: return "OpenSans-Light"
            case .regular: return "OpenSans-Regular"
            case .medium: return "OpenSans-Medium"
            case .semibold: return "OpenSans-SemiBold"
            case .bold: return "OpenSans-Bold"
            }
        }
        var italicPostScript: String {
            switch self {
            case .light: return "OpenSans-LightItalic"
            default: return "OpenSans-Italic"
            }
        }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}

// MARK: - Reusable surfaces

/// A flat Notion-style "block": white surface, hairline border, soft radius.
struct Block<Content: View>: View {
    var tinted: Bool = false
    var emphasized: Bool = false
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(tinted ? Theme.tint : Theme.bg, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(emphasized ? Theme.line2 : Theme.line, lineWidth: 1)
            )
    }
}

/// Square Notion-style tag/pill with an optional bespoke icon.
struct Pill: View {
    var icon: AppIcon.Glyph? = nil
    var text: String
    var body: some View {
        HStack(spacing: 6) {
            if let icon { AppIcon(icon, size: 13).foregroundStyle(Theme.ink2) }
            Text(text).font(Theme.font(12, .semibold))
        }
        .foregroundStyle(Theme.ink2)
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(Theme.tag, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

/// Primary (ink) / ghost button label in the Notion style.
struct PrimaryButtonLabel: View {
    var title: String
    var icon: AppIcon.Glyph? = nil
    var ghost: Bool = false
    var body: some View {
        HStack(spacing: 8) {
            if let icon { AppIcon(icon, size: 17) }
            Text(title).font(Theme.font(14.5, .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .foregroundStyle(ghost ? Theme.ink2 : Color.white)
        .background(ghost ? Color.clear : Theme.ink, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .stroke(ghost ? Theme.line2 : Color.clear, lineWidth: 1)
        )
    }
}
