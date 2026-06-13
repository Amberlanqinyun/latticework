import SwiftUI
import LatticeworkKit

struct TodayView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TitleHeader(glyph: .today, title: "Today")

                    Block(tinted: true) {
                        HStack(spacing: 16) {
                            StreakRing(count: app.streaks.count)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(app.streaks.count)-day streak").font(Theme.font(15, .semibold))
                                Text("Keep the latticework growing")
                                    .font(Theme.font(13)).foregroundStyle(Theme.ink2)
                            }
                        }
                    }

                    if let model = app.content.modelOfTheDay {
                        NavigationLink(value: model.id) {
                            Block {
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack(spacing: 8) {
                                        AppIcon(.discipline(model.discipline.rawValue), size: 14)
                                            .foregroundStyle(Theme.ink2)
                                        Text("\(model.title) · model of the day".uppercased())
                                            .font(Theme.font(11, .semibold)).tracking(0.5)
                                            .foregroundStyle(Theme.faint)
                                    }
                                    Text(model.title).font(Theme.font(30, .light)).foregroundStyle(Theme.ink)
                                    QuoteText(quote: model.quote)
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        Block {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Apply it today").font(Theme.font(14.5, .semibold))
                                Text(model.whenToUse).font(Theme.font(13)).foregroundStyle(Theme.ink2).lineSpacing(3)
                                Button {
                                    if app.streaks.markTodayComplete() {
                                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    }
                                } label: {
                                    PrimaryButtonLabel(
                                        title: app.streaks.completedToday ? "Completed" : "Mark complete",
                                        icon: app.streaks.completedToday ? .seal : nil)
                                }
                                .buttonStyle(.plain)
                                .disabled(app.streaks.completedToday)
                                .opacity(app.streaks.completedToday ? 0.6 : 1)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.page)
            .navigationDestination(for: String.self) { id in ModelDetailView(modelID: id) }
        }
    }
}
