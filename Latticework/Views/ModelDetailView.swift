import SwiftUI
import SwiftData

struct ModelDetailView: View {
    let model: MentalModel
    @Environment(\.modelContext) private var context
    @State private var showDrill = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("\u{201C}\(model.quote)\u{201D}")
                    .font(Theme.serif(22))
                    .italic()
                Text("— Charlie Munger")
                    .font(.caption).foregroundStyle(.secondary)

                section("What it is", model.definition)
                section("Example", model.example)
                section("When to use it", model.whenToUse)
                section("The trap it prevents", model.trap)

                Button {
                    showDrill = true
                } label: {
                    Label("Start drill", systemImage: "target")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .padding(.top, 4)
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDrill) {
            DrillView(model: model) { markLearned() }
        }
    }

    private func section(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline).foregroundStyle(Theme.accent)
            Text(body).font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func markLearned() {
        let id = model.id
        let descriptor = FetchDescriptor<ModelProgress>(predicate: #Predicate { $0.modelID == id })
        let existing = (try? context.fetch(descriptor))?.first
        if let p = existing {
            p.status = "learning"
            p.lastReviewed = .now
            p.drillsCompleted += 1
        } else {
            context.insert(ModelProgress(modelID: id, status: "learning", lastReviewed: .now, drillsCompleted: 1))
        }
    }
}
