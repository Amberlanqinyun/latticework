import XCTest
@testable import LatticeworkKit

final class StreakEngineTests: XCTestCase {
    let engine = StreakEngine()
    var cal = Calendar(identifier: .gregorian)

    override func setUp() {
        super.setUp()
        cal.timeZone = TimeZone(identifier: "America/New_York")!
    }

    private func day(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
        cal.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
    }

    func testFirstCompletionStartsStreakAtOne() {
        let out = engine.markComplete(StreakState(), now: day(2026, 6, 1), calendar: cal)
        XCTAssertEqual(out.state.count, 1)
        XCTAssertTrue(out.advanced)
        XCTAssertEqual(out.state.lastActiveDay, cal.startOfDay(for: day(2026, 6, 1)))
    }

    func testSecondCompletionSameDayIsNoOp() {
        let first = engine.markComplete(StreakState(), now: day(2026, 6, 1, 9), calendar: cal)
        let second = engine.markComplete(first.state, now: day(2026, 6, 1, 21), calendar: cal)
        XCTAssertEqual(second.state.count, 1)
        XCTAssertFalse(second.advanced)
        XCTAssertEqual(second.state, first.state)
    }

    func testConsecutiveDayIncrements() {
        let d1 = engine.markComplete(StreakState(), now: day(2026, 6, 1), calendar: cal)
        let d2 = engine.markComplete(d1.state, now: day(2026, 6, 2), calendar: cal)
        let d3 = engine.markComplete(d2.state, now: day(2026, 6, 3), calendar: cal)
        XCTAssertEqual(d3.state.count, 3)
        XCTAssertTrue(d3.advanced)
    }

    func testMissedDayResetsToOne() {
        let d1 = engine.markComplete(StreakState(), now: day(2026, 6, 1), calendar: cal)
        let d2 = engine.markComplete(d1.state, now: day(2026, 6, 2), calendar: cal)
        // skip Jun 3, complete Jun 4
        let d4 = engine.markComplete(d2.state, now: day(2026, 6, 4), calendar: cal)
        XCTAssertEqual(d4.state.count, 1)
        XCTAssertTrue(d4.advanced)
    }

    func testMonthBoundaryIsConsecutive() {
        let s = StreakState(count: 9, lastActiveDay: cal.startOfDay(for: day(2026, 6, 30)))
        let out = engine.markComplete(s, now: day(2026, 7, 1), calendar: cal)
        XCTAssertEqual(out.state.count, 10)
    }

    func testIsCompletedReflectsLastActiveDay() {
        let s = engine.markComplete(StreakState(), now: day(2026, 6, 1, 8), calendar: cal).state
        XCTAssertTrue(engine.isCompleted(s, on: day(2026, 6, 1, 23), calendar: cal))
        XCTAssertFalse(engine.isCompleted(s, on: day(2026, 6, 2, 0), calendar: cal))
        XCTAssertFalse(engine.isCompleted(StreakState(), on: day(2026, 6, 1), calendar: cal))
    }

    func testStreakSurvivesDSTSpringForward() {
        // US DST begins 2026-03-08. Complete the day before and the day of.
        let d7 = engine.markComplete(StreakState(), now: day(2026, 3, 7), calendar: cal)
        let d8 = engine.markComplete(d7.state, now: day(2026, 3, 8), calendar: cal)
        XCTAssertEqual(d8.state.count, 2)
        XCTAssertTrue(d8.advanced)
    }
}
