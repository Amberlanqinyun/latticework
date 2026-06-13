import Foundation
import Observation

/// Tracks daily-engagement streaks. Lightweight; persisted in UserDefaults.
@Observable
final class StreakStore {
    private let defaults = UserDefaults.standard
    private let lastKey = "streak.lastActiveDay"
    private let countKey = "streak.count"

    var count: Int { defaults.integer(forKey: countKey) }

    /// Call when the user completes today's model. Returns true if streak advanced.
    @discardableResult
    func markTodayComplete() -> Bool {
        let cal = Calendar.current
        let today = cal.startOfDay(for: .now)
        if let last = defaults.object(forKey: lastKey) as? Date {
            let lastDay = cal.startOfDay(for: last)
            if cal.isDate(lastDay, inSameDayAs: today) { return false } // already counted
            let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
            let newCount = cal.isDate(lastDay, inSameDayAs: yesterday) ? count + 1 : 1
            defaults.set(newCount, forKey: countKey)
        } else {
            defaults.set(1, forKey: countKey)
        }
        defaults.set(today, forKey: lastKey)
        return true
    }

    var completedToday: Bool {
        guard let last = defaults.object(forKey: lastKey) as? Date else { return false }
        return Calendar.current.isDateInToday(last)
    }
}
