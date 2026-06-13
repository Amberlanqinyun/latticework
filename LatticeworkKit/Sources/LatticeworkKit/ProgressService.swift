import Foundation

/// Learning status of a single model.
public enum ModelStatus: String, Codable, Sendable, Comparable {
    case new, learning, mastered

    private var rank: Int {
        switch self { case .new: return 0; case .learning: return 1; case .mastered: return 2 }
    }
    public static func < (lhs: ModelStatus, rhs: ModelStatus) -> Bool { lhs.rank < rhs.rank }
}

/// Storage seam for progress. The app backs this with SwiftData; tests use the
/// in-memory implementation below.
public protocol ProgressStore: AnyObject {
    func status(for id: String) -> ModelStatus?
    func drills(for id: String) -> Int
    func set(status: ModelStatus, drills: Int, for id: String)
}

public final class InMemoryProgressStore: ProgressStore {
    private struct Row { var status: ModelStatus; var drills: Int }
    private var rows: [String: Row] = [:]
    public init() {}
    public func status(for id: String) -> ModelStatus? { rows[id]?.status }
    public func drills(for id: String) -> Int { rows[id]?.drills ?? 0 }
    public func set(status: ModelStatus, drills: Int, for id: String) {
        rows[id] = Row(status: status, drills: drills)
    }
}

/// Maps learning events to per-model status transitions.
public struct ProgressService {
    private let store: ProgressStore
    public let masteryThreshold: Int

    public init(store: ProgressStore, masteryThreshold: Int = 3) {
        self.store = store
        self.masteryThreshold = masteryThreshold
    }

    public func status(for id: String) -> ModelStatus { store.status(for: id) ?? .new }

    /// Record a completed drill: new → learning, increment drill count,
    /// reaching the threshold promotes to mastered (a one-way ratchet).
    @discardableResult
    public func recordDrill(modelID id: String) -> ModelStatus {
        let current = status(for: id)
        let drills = store.drills(for: id) + 1
        let newStatus: ModelStatus
        if current == .mastered || drills >= masteryThreshold {
            newStatus = .mastered
        } else {
            newStatus = .learning
        }
        store.set(status: newStatus, drills: drills, for: id)
        return newStatus
    }

    /// Force-promote a model to mastered.
    public func markMastered(id: String) {
        store.set(status: .mastered, drills: max(store.drills(for: id), masteryThreshold), for: id)
    }

    public func learningCount(in ids: [String]) -> Int { ids.filter { status(for: $0) == .learning }.count }
    public func masteredCount(in ids: [String]) -> Int { ids.filter { status(for: $0) == .mastered }.count }
}
