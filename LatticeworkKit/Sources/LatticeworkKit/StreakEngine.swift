import Foundation

/// The persisted state of a user's streak. Value type — storage is the app's concern.
public struct StreakState: Equatable, Sendable {
    public var count: Int
    public var lastActiveDay: Date?

    public init(count: Int = 0, lastActiveDay: Date? = nil) {
        self.count = count
        self.lastActiveDay = lastActiveDay
    }
}

/// Result of completing a day: the new state and whether the streak advanced.
public struct StreakOutcome: Equatable, Sendable {
    public let state: StreakState
    public let advanced: Bool
}

/// Pure streak logic. The clock and calendar are injected — the engine never reads
/// the wall clock, so every day-boundary case is deterministically testable.
public struct StreakEngine: Sendable {
    public init() {}

    /// Apply a "completed today" event.
    /// - first ever completion → count 1, advanced
    /// - already completed today → unchanged, not advanced
    /// - last active was yesterday → +1, advanced
    /// - otherwise (gap) → reset to 1, advanced
    public func markComplete(_ state: StreakState, now: Date, calendar: Calendar = .current) -> StreakOutcome {
        let today = calendar.startOfDay(for: now)

        guard let last = state.lastActiveDay else {
            return StreakOutcome(state: StreakState(count: 1, lastActiveDay: today), advanced: true)
        }
        let lastDay = calendar.startOfDay(for: last)

        if calendar.isDate(lastDay, inSameDayAs: today) {
            return StreakOutcome(state: state, advanced: false)
        }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let newCount = calendar.isDate(lastDay, inSameDayAs: yesterday) ? state.count + 1 : 1
        return StreakOutcome(state: StreakState(count: newCount, lastActiveDay: today), advanced: true)
    }

    /// Whether the streak has already been completed on the given day.
    public func isCompleted(_ state: StreakState, on date: Date, calendar: Calendar = .current) -> Bool {
        guard let last = state.lastActiveDay else { return false }
        return calendar.isDate(last, inSameDayAs: date)
    }
}
