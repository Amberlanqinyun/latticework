import Foundation

/// Outcome of answering a drill.
public struct DrillResult: Equatable, Sendable {
    public let isCorrect: Bool
    public let explanation: String
}

/// Scores drill answers and selects the next drill. Selection is behind this
/// interface so spaced repetition can replace random later without touching callers.
/// RNG is injected for deterministic tests.
public struct DrillEngine: Sendable {
    public init() {}

    /// Score a chosen option. Out-of-range choices are simply incorrect.
    public func score(_ drill: MentalModel.Drill, choice: Int) -> DrillResult {
        DrillResult(isCorrect: choice == drill.correctIndex, explanation: drill.explanation)
    }

    /// Pick the next model to drill on. Returns nil for an empty pool.
    public func next(from pool: [MentalModel], using generator: inout some RandomNumberGenerator) -> MentalModel? {
        guard !pool.isEmpty else { return nil }
        let i = Int.random(in: 0..<pool.count, using: &generator)
        return pool[i]
    }

    /// Convenience using the system RNG.
    public func next(from pool: [MentalModel]) -> MentalModel? {
        var rng = SystemRandomNumberGenerator()
        return next(from: pool, using: &rng)
    }
}
