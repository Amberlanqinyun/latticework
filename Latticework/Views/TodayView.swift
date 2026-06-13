import SwiftUI

struct TodayView: View {
    @Environment(ContentStore.self) private var content
    @Environment(StreakStore.self) private var streaks

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    streakRow

                    if let model = content.modelOfTheDay {
                        NavigationLink(value: model) {
                            DailyCard(model: model)
                        }
                        .buttonStyle(.plain)

                        applyPrompt(for: model)
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Today")
            .navigationDestination(for: MentalModel.self) { ModelDetailView(model: $0) }
        }
    }

    private var streakRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .foregroundStyle(Theme.accent)
                .font(.title2)
            Text("\(streaks.count)-day streak")
                .font(.headline)
            Spacer()
            if streaks.completedToday {
                Label("Done", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 16))
    }

    private func applyPrompt(for model: MentalModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Apply it today")
                .font(.headline)
            Text(model.whenToUse)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button {
                withAnimation(.snappy) { streaks.markTodayComplete() }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } label: {
                Label(streaks.completedToday ? "Completed" : "Mark complete",
                      systemImage: streaks.completedToday ? "checkmark" : "circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
            .disabled(streaks.completedToday)
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 16))
    }
}

struct DailyCard: View {
    let model: MentalModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(model.discipline.rawValue, systemImage: model.discipline.symbol)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.accent)

            Text(model.title)
                .font(.system(.largeTitle, design: .serif, weight: .bold))

            Text("\u{201C}\(model.quote)\u{201D}")
                .font(Theme.serif(18))
                .foregroundStyle(.secondary)
                .italic()

            Text("— Charlie Munger")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(Color.card, in: .rect(cornerRadius: 20))
    }
}
