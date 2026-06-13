import SwiftUI
import LatticeworkKit

struct ModelDetailView: View {
    let modelID: String
    @Environment(AppState.self) private var app
    @State private var showDrill = false

    private var model: MentalModel? { app.content.model(id: modelID) }

    var body: some View {
        ScrollView {
            if let model {
                VStack(alignment: .leading, spacing: 18) {
                    Text(model.title).font(Theme.font(26, .light)).foregroundStyle(Theme.ink)

                    HStack(spacing: 8) {
                        Pill(icon: .discipline(model.discipline.rawValue), text: model.discipline.rawValue)
                        Pill(icon: .drills, text: statusLabel)
                    }

                    QuoteText(quote: model.quote, size: 19)

                    section("What it is", model.definition)
                    section("Example", model.example)
                    section("When to use it", model.whenToUse)
                    section("The trap it prevents", model.trap)

                    Button { showDrill = true } label: {
                        PrimaryButtonLabel(title: "Start drill", icon: .drills)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(20)
            } else {
                Text("Model not found.").font(Theme.font(15)).foregroundStyle(Theme.ink2).padding(40)
            }
        }
        .background(Theme.page)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDrill) {
            if let model { DrillView(model: model) { app.recordDrill(modelID: model.id) } }
        }
    }

    private var statusLabel: String {
        switch app.status(for: modelID) {
        case .new: return "New"; case .learning: return "Learning"; case .mastered: return "Mastered"
        }
    }

    private func section(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title.uppercased()).font(Theme.font(11, .bold)).tracking(0.7).foregroundStyle(Theme.faint)
            Text(text).font(Theme.font(13.5)).foregroundStyle(Theme.body).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
