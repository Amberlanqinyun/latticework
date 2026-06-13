import SwiftUI
import SwiftData
import LatticeworkKit

struct JournalView: View {
    @Environment(AppState.self) private var app
    @Query(sort: \StoredDecision.createdAt, order: .reverse) private var stored: [StoredDecision]
    @State private var composing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    TitleHeader(glyph: .journal, title: "Journal",
                                trailing: AnyView(
                                    Button { composing = true } label: {
                                        AppIcon(.pencil, size: 18).foregroundStyle(Theme.ink2)
                                    }.buttonStyle(.plain)))

                    if stored.isEmpty {
                        emptyState
                    } else {
                        ForEach(stored) { d in
                            NavigationLink(value: DecisionRoute(id: d.id)) { entryCard(d) }
                                .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.page)
            .navigationDestination(for: DecisionRoute.self) { route in
                DecisionDetailView(decisionID: route.id)
            }
            .sheet(isPresented: $composing) { DecisionComposer() }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            AppIcon(.journal, size: 44).foregroundStyle(Theme.faint)
            Text("No decisions yet").font(Theme.font(17, .semibold))
            Text("Log a real decision and the models you used. Review the outcome later to calibrate your judgment.")
                .font(Theme.font(13)).foregroundStyle(Theme.ink2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.top, 60).padding(.horizontal, 20)
    }

    private func entryCard(_ d: StoredDecision) -> some View {
        Block {
            VStack(alignment: .leading, spacing: 6) {
                Text(d.title).font(Theme.font(14.5, .semibold)).foregroundStyle(Theme.ink)
                HStack(spacing: 6) {
                    Text(d.createdAt, format: .dateTime.month().day())
                    Text("· \(d.confidence)% confident")
                    if d.reviewedOutcome != nil {
                        HStack(spacing: 4) { AppIcon(.seal, size: 12); Text("Reviewed") }
                            .foregroundStyle(Theme.green)
                    }
                }
                .font(Theme.font(11.5)).foregroundStyle(Theme.ink2)
                if !d.modelsUsed.isEmpty {
                    HStack(spacing: 7) {
                        ForEach(d.modelsUsed.prefix(2), id: \.self) { Pill(text: $0) }
                    }
                    .padding(.top, 5)
                }
            }
        }
    }
}

struct DecisionRoute: Hashable { let id: UUID }

struct DecisionComposer: View {
    @Environment(AppState.self) private var app
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var decision = ""
    @State private var expected = ""
    @State private var confidence = 50.0

    var body: some View {
        NavigationStack {
            Form {
                Section("Decision") {
                    TextField("Title", text: $title)
                    TextField("What did you decide?", text: $decision, axis: .vertical).lineLimit(3...6)
                }
                Section("Expected outcome") {
                    TextField("What do you expect to happen?", text: $expected, axis: .vertical).lineLimit(2...5)
                }
                Section("Confidence: \(Int(confidence))%") {
                    Slider(value: $confidence, in: 0...100, step: 5).tint(Theme.ink)
                }
            }
            .navigationTitle("New Decision")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        app.journal.create(title: title, decision: decision,
                                           expectedOutcome: expected, confidence: Int(confidence), now: .now)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct DecisionDetailView: View {
    let decisionID: UUID
    @Environment(AppState.self) private var app
    @Query private var matches: [StoredDecision]
    @State private var review = ""

    init(decisionID: UUID) {
        self.decisionID = decisionID
        _matches = Query(filter: #Predicate { $0.id == decisionID })
    }

    private var d: StoredDecision? { matches.first }

    var body: some View {
        ScrollView {
            if let d {
                VStack(alignment: .leading, spacing: 16) {
                    Text(d.title).font(Theme.font(24, .light)).foregroundStyle(Theme.ink)
                    field("Decision", d.decision)
                    field("Expected", d.expectedOutcome)
                    field("Confidence", "\(d.confidence)%")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("OUTCOME REVIEW").font(Theme.font(11, .bold)).tracking(0.7).foregroundStyle(Theme.faint)
                        if let reviewed = d.reviewedOutcome {
                            Text(reviewed).font(Theme.font(14)).foregroundStyle(Theme.body)
                        } else {
                            TextField("What actually happened?", text: $review, axis: .vertical).lineLimit(3...8)
                                .font(Theme.font(14))
                            Button { app.journal.recordOutcome(id: d.id, text: review, at: .now) } label: {
                                PrimaryButtonLabel(title: "Save review")
                            }
                            .buttonStyle(.plain).disabled(review.isEmpty)
                        }
                    }
                }
                .padding(20)
            }
        }
        .background(Theme.page)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func field(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased()).font(Theme.font(11, .bold)).tracking(0.7).foregroundStyle(Theme.faint)
            Text(value.isEmpty ? "—" : value).font(Theme.font(14)).foregroundStyle(Theme.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
