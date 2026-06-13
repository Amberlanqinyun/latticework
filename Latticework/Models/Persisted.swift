import Foundation
import SwiftData
import LatticeworkKit

// MARK: - SwiftData @Model records (user data layer)

/// Per-model learning progress, persisted (iCloud-syncable later).
@Model
final class StoredProgress {
    @Attribute(.unique) var modelID: String
    var statusRaw: String
    var lastReviewed: Date?
    var drillsCompleted: Int

    init(modelID: String, statusRaw: String = ModelStatus.new.rawValue,
         lastReviewed: Date? = nil, drillsCompleted: Int = 0) {
        self.modelID = modelID
        self.statusRaw = statusRaw
        self.lastReviewed = lastReviewed
        self.drillsCompleted = drillsCompleted
    }
}

/// A logged decision, persisted.
@Model
final class StoredDecision {
    @Attribute(.unique) var id: UUID
    var title: String
    var decision: String
    var modelsUsed: [String]
    var expectedOutcome: String
    var confidence: Int
    var createdAt: Date
    var reviewedOutcome: String?
    var reviewedAt: Date?

    init(entry: DecisionEntry) {
        self.id = entry.id
        self.title = entry.title
        self.decision = entry.decision
        self.modelsUsed = entry.modelsUsed
        self.expectedOutcome = entry.expectedOutcome
        self.confidence = entry.confidence
        self.createdAt = entry.createdAt
        self.reviewedOutcome = entry.reviewedOutcome
        self.reviewedAt = entry.reviewedAt
    }

    /// Map back to the kit's value type.
    var entry: DecisionEntry {
        DecisionEntry(id: id, title: title, decision: decision, modelsUsed: modelsUsed,
                      expectedOutcome: expectedOutcome, confidence: confidence, createdAt: createdAt,
                      reviewedOutcome: reviewedOutcome, reviewedAt: reviewedAt)
    }

    func apply(_ entry: DecisionEntry) {
        title = entry.title; decision = entry.decision; modelsUsed = entry.modelsUsed
        expectedOutcome = entry.expectedOutcome; confidence = entry.confidence
        reviewedOutcome = entry.reviewedOutcome; reviewedAt = entry.reviewedAt
    }
}

// MARK: - Store adapters (satisfy LatticeworkKit protocols)

/// SwiftData-backed implementation of the kit's `ProgressStore`.
@MainActor
final class SwiftDataProgressStore: ProgressStore {
    private let context: ModelContext
    init(_ context: ModelContext) { self.context = context }

    private func record(_ id: String) -> StoredProgress? {
        let d = FetchDescriptor<StoredProgress>(predicate: #Predicate { $0.modelID == id })
        return try? context.fetch(d).first
    }

    func status(for id: String) -> ModelStatus? {
        record(id).flatMap { ModelStatus(rawValue: $0.statusRaw) }
    }
    func drills(for id: String) -> Int { record(id)?.drillsCompleted ?? 0 }

    func set(status: ModelStatus, drills: Int, for id: String) {
        if let r = record(id) {
            r.statusRaw = status.rawValue
            r.drillsCompleted = drills
            r.lastReviewed = .now
        } else {
            context.insert(StoredProgress(modelID: id, statusRaw: status.rawValue,
                                          lastReviewed: .now, drillsCompleted: drills))
        }
        try? context.save()
    }
}

/// SwiftData-backed implementation of the kit's `DecisionStore`.
@MainActor
final class SwiftDataDecisionStore: DecisionStore {
    private let context: ModelContext
    init(_ context: ModelContext) { self.context = context }

    private func record(_ id: UUID) -> StoredDecision? {
        let d = FetchDescriptor<StoredDecision>(predicate: #Predicate { $0.id == id })
        return try? context.fetch(d).first
    }

    func add(_ entry: DecisionEntry) {
        context.insert(StoredDecision(entry: entry))
        try? context.save()
    }
    func all() -> [DecisionEntry] {
        let d = FetchDescriptor<StoredDecision>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return ((try? context.fetch(d)) ?? []).map(\.entry)
    }
    func update(_ entry: DecisionEntry) {
        record(entry.id)?.apply(entry)
        try? context.save()
    }
    func delete(id: UUID) {
        if let r = record(id) { context.delete(r) }
        try? context.save()
    }
}
