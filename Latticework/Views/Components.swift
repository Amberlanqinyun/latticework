import SwiftUI
import LatticeworkKit

/// Large page title with a bespoke icon chip beside it (Notion style).
struct TitleHeader: View {
    var glyph: AppIcon.Glyph
    var title: String
    var trailing: AnyView? = nil

    var body: some View {
        HStack(spacing: 13) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Theme.line2, lineWidth: 1)
                AppIcon(glyph, size: 19).foregroundStyle(Theme.ink)
            }
            .frame(width: 34, height: 34)
            Text(title).font(Theme.font(27, .bold)).foregroundStyle(Theme.ink)
            Spacer()
            if let trailing { trailing }
        }
        .padding(.bottom, 24)
    }
}

/// Uppercase faint section label with an optional bespoke icon.
struct SectionLabel: View {
    var glyph: AppIcon.Glyph? = nil
    var text: String
    var body: some View {
        HStack(spacing: 8) {
            if let glyph { AppIcon(glyph, size: 14).foregroundStyle(Theme.faint) }
            Text(text.uppercased()).font(Theme.font(11, .bold)).tracking(0.7)
        }
        .foregroundStyle(Theme.faint)
        .padding(.horizontal, 6).padding(.top, 8).padding(.bottom, 8)
    }
}

/// Monochrome streak ring with a number in the center.
struct StreakRing: View {
    var count: Int
    var fraction: Double = 0.7
    var body: some View {
        ZStack {
            Circle().stroke(Theme.line2, lineWidth: 4)
            Circle().trim(from: 0, to: fraction)
                .stroke(Theme.ink, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(count)").font(Theme.font(14, .semibold)).foregroundStyle(Theme.ink)
        }
        .frame(width: 50, height: 50)
    }
}

/// A short attributed quote rendered in Open Sans light italic.
struct QuoteText: View {
    var quote: String
    var size: CGFloat = 17
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\u{201C}\(quote)\u{201D}")
                .font(Theme.font(size, .light, italic: true))
                .foregroundStyle(Theme.ink)
                .lineSpacing(4)
            Text("Charlie Munger")
                .font(Theme.font(12, .semibold)).foregroundStyle(Theme.faint)
        }
    }
}
