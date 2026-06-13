import Foundation

/// A logged real-world decision — the app's retention feature.
public struct DecisionEntry: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var decision: String
    public var modelsUsed: [String]
    public var expectedOutcome: String
    public var confidence: Int          // 0...100
    public var createdAt: Date
    public var reviewedOutcome: String?
    public var reviewedAt: Date?

    public init(id: UUID = UUID(), title: String, decision: String, modelsUsed: [String] = [],
                expectedOutcome: String = "", confidence: Int = 50, createdAt: Date,
                reviewedOutcome: String? = nil, reviewedAt: Date? = nil) {
        self.id = id; self.title = title; self.decision = decision; self.modelsUsed = modelsUsed
        self.expectedOutcome = expectedOutcome; self.confidence = confidence; self.createdAt = createdAt
        self.reviewedOutcome = reviewedOutcome; self.reviewedAt = reviewedAt
    }

    public var isReviewed: Bool { reviewedOutcome != nil }
}

/// Storage seam for decisions. App backs with SwiftData; tests use in-memory.
public protocol DecisionStore: AnyObject {
    func add(_ entry: DecisionEntry)
    func all() -> [DecisionEntry]
    func update(_ entry: DecisionEntry)
    func delete(id: UUID)
}

public final class InMemoryDecisionStore: DecisionStore {
    private var entries: [UUID: DecisionEntry] = [:]
    public init() {}
    public func add(_ entry: DecisionEntry) { entries[entry.id] = entry }
    public func all() -> [DecisionEntry] { Array(entries.values) }
    public func update(_ entry: DecisionEntry) { entries[entry.id] = entry }
    public func delete(id: UUID) { entries[id] = nil }
}

/// CRUD + outcome-review logic over decision entries.
public struct DecisionJournal {
    private let store: DecisionStore
    public init(store: DecisionStore) { self.store = store }

    /// Create an entry. Confidence is clamped to 0...100.
    @discardableResult
    public func create(title: String, decision: String, modelsUsed: [String] = [],
                       expectedOutcome: String = "", confidence: Int, now: Date) -> DecisionEntry {
        let entry = DecisionEntry(title: title, decision: decision, modelsUsed: modelsUsed,
                                  expectedOutcome: expectedOutcome,
                                  confidence: min(100, max(0, confidence)), createdAt: now)
        store.add(entry)
        return entry
    }

    /// All entries, newest first.
    public func list() -> [DecisionEntry] {
        store.all().sorted { $0.createdAt > $1.createdAt }
    }

    /// Record the real outcome and mark the entry reviewed.
    @discardableResult
    public func recordOutcome(id: UUID, text: String, at date: Date) -> DecisionEntry? {
        guard var entry = store.all().first(where: { $0.id == id }) else { return nil }
        entry.reviewedOutcome = text
        entry.reviewedAt = date
        store.update(entry)
        return entry
    }

    public func delete(id: UUID) { store.delete(id: id) }
}
