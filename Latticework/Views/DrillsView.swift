import SwiftUI
import LatticeworkKit

struct DrillsView: View {
    @Environment(AppState.self) private var app
    @State private var active: MentalModel?
    private let engine = DrillEngine()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TitleHeader(glyph: .drills, title: "Drills")
                    Spacer(minLength: 40)
                    AppIcon(.drills, size: 56).foregroundStyle(Theme.ink)
                    Text("Test your recall").font(Theme.font(20, .semibold))
                    Text("Spot the bias. Invert the problem. Sharpen the latticework.")
                        .font(Theme.font(14)).foregroundStyle(Theme.ink2)
                        .multilineTextAlignment(.center).padding(.horizontal, 20)
                    Button {
                        active = engine.next(from: app.content.all)
                    } label: { PrimaryButtonLabel(title: "Start a drill", icon: .drills) }
                    .buttonStyle(.plain).padding(.horizontal, 40)
                }
                .padding(20)
            }
            .background(Theme.page)
            .sheet(item: $active) { model in
                DrillView(model: model) { app.recordDrill(modelID: model.id) }
            }
        }
    }
}

struct DrillView: View {
    let model: MentalModel
    var onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selected: Int?
    private let engine = DrillEngine()

    private var drill: MentalModel.Drill { model.drill }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(drill.scenario).font(Theme.font(20, .light)).foregroundStyle(Theme.ink).lineSpacing(4)

                    ForEach(Array(drill.options.enumerated()), id: \.offset) { idx, option in
                        Button { answer(idx) } label: { optionRow(idx, option) }
                            .buttonStyle(.plain)
                            .disabled(selected != nil)
                    }

                    if selected != nil {
                        Block(tinted: true) {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("WHY").font(Theme.font(11, .bold)).tracking(0.7).foregroundStyle(Theme.faint)
                                Text(drill.explanation).font(Theme.font(13.5)).foregroundStyle(Theme.body).lineSpacing(4)
                            }
                        }
                        Button { onComplete(); dismiss() } label: { PrimaryButtonLabel(title: "Done") }
                            .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(Theme.page)
            .navigationTitle(model.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() }.tint(Theme.ink2) } }
        }
    }

    private func answer(_ idx: Int) {
        guard selected == nil else { return }
        selected = idx
        let r = engine.score(drill, choice: idx)
        UINotificationFeedbackGenerator().notificationOccurred(r.isCorrect ? .success : .error)
    }

    @ViewBuilder
    private func optionRow(_ idx: Int, _ option: String) -> some View {
        let isCorrect = idx == drill.correctIndex
        let isChosen = idx == selected
        HStack {
            Text(option).font(Theme.font(14)).foregroundStyle(Theme.ink)
            Spacer()
            if selected != nil {
                if isCorrect { AppIcon(.seal, size: 16).foregroundStyle(Theme.green) }
                else if isChosen { AppIcon(.x, size: 16).foregroundStyle(Theme.red) }
            }
        }
        .padding(.horizontal, 15).padding(.vertical, 14)
        .background(rowBackground(isCorrect, isChosen), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous).stroke(rowStroke(isCorrect, isChosen), lineWidth: 1))
    }

    private func rowBackground(_ correct: Bool, _ chosen: Bool) -> Color {
        guard selected != nil else { return Theme.bg }
        if correct { return Theme.green.opacity(0.10) }
        if chosen { return Theme.red.opacity(0.10) }
        return Theme.bg
    }
    private func rowStroke(_ correct: Bool, _ chosen: Bool) -> Color {
        guard selected != nil else { return Theme.line2 }
        if correct { return Theme.green }
        if chosen { return Theme.red }
        return Theme.line2
    }
}
