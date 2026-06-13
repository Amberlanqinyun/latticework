import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DecisionEntry.createdAt, order: .reverse) private var entries: [DecisionEntry]
    @State private var composing = false

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "No decisions yet",
                        systemImage: "book.closed",
                        description: Text("Log a real decision and the models you used. Review the outcome later to calibrate your judgment.")
                    )
                } else {
                    List {
                        ForEach(entries) { entry in
                            NavigationLink {
                                DecisionDetailView(entry: entry)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title).font(.body.weight(.medium))
                                    HStack {
                                        Text(entry.createdAt, style: .date)
                                        Text("· \(entry.confidence)% confident")
                                        if entry.reviewedOutcome != nil {
                                            Label("Reviewed", systemImage: "checkmark.seal")
                                                .foregroundStyle(.green)
                                        }
                                    }
                                    .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { idx in idx.forEach { context.delete(entries[$0]) } }
                    }
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { composing = true } label: { Image(systemName: "square.and.pencil") }
                }
            }
            .sheet(isPresented: $composing) { DecisionComposer() }
        }
    }
}

struct DecisionComposer: View {
    @Environment(\.modelContext) private var context
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
                    Slider(value: $confidence, in: 0...100, step: 5).tint(Theme.accent)
                }
            }
            .navigationTitle("New Decision")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = DecisionEntry(title: title, decision: decision,
                                                  expectedOutcome: expected, confidence: Int(confidence))
                        context.insert(entry)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct DecisionDetailView: View {
    @Bindable var entry: DecisionEntry
    @State private var review = ""

    var body: some View {
        Form {
            Section("Decision") { Text(entry.decision) }
            Section("Expected") { Text(entry.expectedOutcome) }
            Section("Confidence") { Text("\(entry.confidence)%") }
            Section("Outcome review") {
                if let reviewed = entry.reviewedOutcome {
                    Text(reviewed)
                } else {
                    TextField("What actually happened?", text: $review, axis: .vertical).lineLimit(3...8)
                    Button("Save review") {
                        entry.reviewedOutcome = review
                        entry.reviewedAt = .now
                    }
                    .disabled(review.isEmpty)
                }
            }
        }
        .navigationTitle(entry.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
