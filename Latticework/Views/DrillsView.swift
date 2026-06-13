import SwiftUI

/// Tab-level entry: pick a random model to drill on.
struct DrillsView: View {
    @Environment(ContentStore.self) private var content
    @State private var active: MentalModel?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "target")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
                Text("Test your recall")
                    .font(.title2.weight(.semibold))
                Text("Spot the bias. Invert the problem. Sharpen the latticework.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button {
                    active = content.models.randomElement()
                } label: {
                    Label("Start a drill", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
            }
            .padding(32)
            .navigationTitle("Drills")
            .sheet(item: $active) { model in
                DrillView(model: model) { }
            }
        }
    }
}

/// The actual drill flow — scenario, options, feedback.
struct DrillView: View {
    let model: MentalModel
    var onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selected: Int?

    private var drill: MentalModel.Drill { model.drill }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(drill.scenario)
                        .font(.system(.title3, design: .serif))

                    ForEach(Array(drill.options.enumerated()), id: \.offset) { idx, option in
                        Button {
                            guard selected == nil else { return }
                            withAnimation(.snappy) { selected = idx }
                            let correct = idx == drill.correctIndex
                            UINotificationFeedbackGenerator()
                                .notificationOccurred(correct ? .success : .error)
                        } label: {
                            HStack {
                                Text(option).multilineTextAlignment(.leading)
                                Spacer()
                                if let s = selected {
                                    if idx == drill.correctIndex {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                                    } else if idx == s {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(background(for: idx), in: .rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .disabled(selected != nil)
                    }

                    if selected != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why").font(.headline).foregroundStyle(Theme.accent)
                            Text(drill.explanation).font(.body)
                        }
                        .padding()
                        .background(Color.card, in: .rect(cornerRadius: 12))

                        Button("Done") {
                            onComplete()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.accent)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle(model.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }

    private func background(for idx: Int) -> Color {
        guard let s = selected else { return Color.card }
        if idx == drill.correctIndex { return .green.opacity(0.18) }
        if idx == s { return .red.opacity(0.18) }
        return Color.card
    }
}
