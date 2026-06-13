import SwiftUI

/// Bespoke icon set drawn as native SwiftUI paths on a 24×24 grid.
/// No SF Symbols / stock libraries for brand glyphs. Mirrors the canonical set
/// in `skills/latticework/references/icons.md` (path data from build_mockups.py).
struct AppIcon: View {
    enum Glyph {
        case today, library, drills, journal, profile, lattice
        case psychology, economics, math, inversion, shield, people, circle, eye
        case flame, seal, search, pencil, back, x, spark
    }

    let glyph: Glyph
    var size: CGFloat

    init(_ glyph: Glyph, size: CGFloat = 22) {
        self.glyph = glyph
        self.size = size
    }

    var body: some View {
        IconShape(glyph: glyph)
            .stroke(style: StrokeStyle(lineWidth: 1.55 * size / 24,
                                       lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

/// Maps a discipline to its bespoke glyph in one place.
extension AppIcon.Glyph {
    static func discipline(_ raw: String) -> AppIcon.Glyph {
        switch raw {
        case "Psychology": return .psychology
        case "Economics": return .economics
        case "Math & Probability": return .math
        case "Physics & Engineering": return .shield
        case "Biology": return .people
        case "Inversion": return .inversion
        default: return .lattice
        }
    }
}

private struct IconShape: Shape {
    let glyph: AppIcon.Glyph

    func path(in rect: CGRect) -> Path {
        let s = rect.width / 24
        func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: y * s) }
        func circle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, into p: inout Path) {
            p.addEllipse(in: CGRect(x: (cx - r) * s, y: (cy - r) * s, width: 2 * r * s, height: 2 * r * s))
        }
        func line(_ pts: [(CGFloat, CGFloat)], into p: inout Path) {
            guard let f = pts.first else { return }
            p.move(to: P(f.0, f.1))
            for pt in pts.dropFirst() { p.addLine(to: P(pt.0, pt.1)) }
        }
        func arc(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ start: Double, _ end: Double, into p: inout Path) {
            p.addArc(center: P(cx, cy), radius: r * s,
                     startAngle: .degrees(start), endAngle: .degrees(end), clockwise: false)
        }

        var p = Path()
        switch glyph {
        case .today:
            line([(3.5, 18), (20.5, 18)], into: &p)
            arc(12, 18, 4.8, 180, 360, into: &p)          // half sun
            line([(12, 4.2), (12, 6.6)], into: &p)        // rays
            line([(5.3, 9.1), (6.9, 10.6)], into: &p)
            line([(18.7, 9.1), (17.1, 10.6)], into: &p)

        case .library:
            line([(12, 3.2), (3.6, 7), (12, 10.8), (20.4, 7), (12, 3.2)], into: &p)
            line([(3.6, 12.1), (12, 15.9), (20.4, 12.1)], into: &p)
            line([(3.6, 16.7), (12, 20.5), (20.4, 16.7)], into: &p)

        case .drills:
            circle(12, 12, 8.2, into: &p)
            circle(12, 12, 4.4, into: &p)
            circle(12, 12, 0.9, into: &p)

        case .journal:
            line([(6.4, 3.6), (19, 3.6), (19, 20.4), (6.4, 20.4)], into: &p)
            line([(6.4, 20.4), (5, 19), (5, 5), (6.4, 3.6)], into: &p)
            line([(9, 3.6), (9, 17)], into: &p)

        case .profile:
            circle(12, 8.4, 3.4, into: &p)
            arc(12, 19.6, 6.1, 200, 340, into: &p)

        case .lattice:
            for (x, y) in [(6.0, 6.0), (18.0, 6.0), (6.0, 18.0), (18.0, 18.0), (12.0, 12.0)] {
                circle(x, y, 1.5, into: &p)
            }
            line([(7.5, 7.5), (10.5, 10.5)], into: &p)
            line([(16.5, 7.5), (13.5, 10.5)], into: &p)
            line([(7.5, 16.5), (10.5, 13.5)], into: &p)
            line([(16.5, 16.5), (13.5, 13.5)], into: &p)

        case .psychology:
            arc(12, 12, 8.5, 140, 400, into: &p)
            arc(12, 12, 3.5, 150, 380, into: &p)
            circle(12, 12, 0.8, into: &p)

        case .economics:
            line([(4, 16.5), (9.2, 11), (12, 13.8), (20, 6)], into: &p)
            line([(15.5, 6), (20, 6), (20, 10.5)], into: &p)

        case .math:
            circle(9.3, 12, 5.4, into: &p)
            circle(14.7, 12, 5.4, into: &p)

        case .inversion:
            line([(7, 8), (16.5, 8), (13.5, 5)], into: &p)
            line([(17, 16), (7.5, 16), (10.5, 19)], into: &p)

        case .shield:
            line([(12, 3.4), (5.4, 6), (5.4, 11.2)], into: &p)
            arc(12, 11.4, 8.0, 35, 90, into: &p)          // lower curve hint
            line([(12, 3.4), (18.6, 6), (18.6, 11.2)], into: &p)
            line([(5.4, 11.2), (12, 19.6), (18.6, 11.2)], into: &p)

        case .people:
            circle(9, 9.2, 3, into: &p)
            arc(9, 19, 5.4, 200, 340, into: &p)
            arc(15.5, 9.5, 3, 300, 420, into: &p)
            arc(16.5, 19, 5.4, 250, 320, into: &p)

        case .circle:
            circle(12, 12, 8.3, into: &p)
            circle(12, 12, 3.4, into: &p)

        case .eye:
            arc(12, 16, 9.2, 230, 310, into: &p)          // lower lid
            arc(12, 8, 9.2, 50, 130, into: &p)            // upper lid
            circle(12, 12, 2.5, into: &p)

        case .flame:
            line([(12, 3.5), (14.5, 7.5), (15, 12)], into: &p)
            arc(12, 13, 5, 320, 400, into: &p)
            line([(9, 7.5), (8, 11)], into: &p)

        case .seal:
            circle(12, 12, 8.4, into: &p)
            line([(8.4, 12), (11, 14.6), (15.6, 9.4)], into: &p)

        case .search:
            circle(11, 11, 6.6, into: &p)
            line([(15.7, 15.7), (20, 20)], into: &p)

        case .pencil:
            line([(14.5, 5.5), (18.5, 9.5)], into: &p)
            line([(4, 20), (5, 16), (16, 5), (19, 8), (8, 19), (4, 20)], into: &p)

        case .back:
            line([(14.5, 6), (9, 12), (14.5, 18)], into: &p)

        case .x:
            line([(6.5, 6.5), (17.5, 17.5)], into: &p)
            line([(17.5, 6.5), (6.5, 17.5)], into: &p)

        case .spark:
            line([(12, 3.5), (12, 7.5)], into: &p)
            line([(12, 16.5), (12, 20.5)], into: &p)
            line([(3.5, 12), (7.5, 12)], into: &p)
            line([(16.5, 12), (20.5, 12)], into: &p)
            circle(12, 12, 2.4, into: &p)
        }
        return p
    }
}
