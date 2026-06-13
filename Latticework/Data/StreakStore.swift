import Foundation
import Observation
import LatticeworkKit

/// App-level streak store. Delegates all date logic to the kit's pure
/// `StreakEngine`; persists `StreakState` in UserDefaults.
@Observable
final class StreakStore {
    private let engine = StreakEngine()
    private let defaults: UserDefaults
    private let countKey = "streak.count"
    private let lastKey = "streak.lastActiveDay"

    private(set) var state: StreakState

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let count = defaults.integer(forKey: countKey)
        let last = defaults.object(forKey: lastKey) as? Date
        self.state = StreakState(count: count, lastActiveDay: last)
    }

    var count: Int { state.count }
    var completedToday: Bool { engine.isCompleted(state, on: .now) }

    /// Mark today complete. Returns true if the streak advanced.
    @discardableResult
    func markTodayComplete(now: Date = .now) -> Bool {
        let outcome = engine.markComplete(state, now: now)
        state = outcome.state
        defaults.set(state.count, forKey: countKey)
        defaults.set(state.lastActiveDay, forKey: lastKey)
        return outcome.advanced
    }
}
