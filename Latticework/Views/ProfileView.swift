import SwiftUI
import LatticeworkKit

struct ProfileView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    TitleHeader(glyph: .profile, title: "Profile")

                    Block {
                        VStack(spacing: 0) {
                            statRow(.flame, "Current streak", "\(app.streaks.count) days")
                            Divider().background(Theme.line)
                            statRow(.journal, "Models learning", "\(app.learningCount())")
                            Divider().background(Theme.line)
                            statRow(.seal, "Models mastered", "\(app.masteredCount()) / \(app.content.all.count)")
                        }
                    }

                    SectionLabel(text: "Subscription")
                    Block(emphasized: true) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Latticework Premium").font(Theme.font(19, .light)).foregroundStyle(Theme.ink)
                            Text("Full library, advanced drills, and iCloud sync across your devices.")
                                .font(Theme.font(13)).foregroundStyle(Theme.ink2).lineSpacing(3)
                            Button { } label: { PrimaryButtonLabel(title: "Upgrade · $49.99/yr") }
                                .buttonStyle(.plain)
                            Button { } label: { PrimaryButtonLabel(title: "Restore purchase", ghost: true) }
                                .buttonStyle(.plain)
                        }
                    }

                    SectionLabel(text: "About")
                    Block(tinted: true) {
                        Text("Built on the worldly wisdom of Charlie Munger. Quotes are short, attributed excerpts used for educational commentary.")
                            .font(Theme.font(11.5)).foregroundStyle(Theme.ink2).lineSpacing(4)
                    }
                }
                .padding(20)
            }
            .background(Theme.page)
        }
    }

    private func statRow(_ glyph: AppIcon.Glyph, _ label: String, _ value: String) -> some View {
        HStack(spacing: 11) {
            AppIcon(glyph, size: 18).foregroundStyle(Theme.ink)
            Text(label).font(Theme.font(14)).foregroundStyle(Theme.ink)
            Spacer()
            Text(value).font(Theme.font(14, .semibold)).monospacedDigit().foregroundStyle(Theme.ink)
        }
        .padding(.vertical, 13)
    }
}
