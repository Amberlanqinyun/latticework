import XCTest
@testable import LatticeworkKit

final class DecisionJournalTests: XCTestCase {
    var cal = Calendar(identifier: .gregorian)
    func makeJournal() -> DecisionJournal { DecisionJournal(store: InMemoryDecisionStore()) }
    private func date(_ d: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 6, day: d))! }

    func testCreateStoresEntry() {
        let j = makeJournal()
        let e = j.create(title: "Hire?", decision: "Yes", confidence: 70, now: date(1))
        XCTAssertEqual(e.title, "Hire?")
        XCTAssertEqual(j.list().count, 1)
    }

    func testConfidenceIsClamped() {
        let j = makeJournal()
        XCTAssertEqual(j.create(title: "a", decision: "", confidence: 150, now: date(1)).confidence, 100)
        XCTAssertEqual(j.create(title: "b", decision: "", confidence: -20, now: date(2)).confidence, 0)
    }

    func testListIsNewestFirst() {
        let j = makeJournal()
        j.create(title: "old", decision: "", confidence: 50, now: date(1))
        j.create(title: "new", decision: "", confidence: 50, now: date(3))
        j.create(title: "mid", decision: "", confidence: 50, now: date(2))
        XCTAssertEqual(j.list().map(\.title), ["new", "mid", "old"])
    }

    func testRecordOutcomeMarksReviewed() {
        let j = makeJournal()
        let e = j.create(title: "Lease?", decision: "Sign", confidence: 80, now: date(1))
        XCTAssertFalse(e.isReviewed)
        let reviewed = j.recordOutcome(id: e.id, text: "Worked out", at: date(20))
        XCTAssertEqual(reviewed?.reviewedOutcome, "Worked out")
        XCTAssertEqual(reviewed?.reviewedAt, date(20))
        XCTAssertTrue(j.list().first(where: { $0.id == e.id })!.isReviewed)
    }

    func testRecordOutcomeUnknownIdReturnsNil() {
        XCTAssertNil(makeJournal().recordOutcome(id: UUID(), text: "x", at: date(1)))
    }

    func testDeleteRemovesEntry() {
        let j = makeJournal()
        let e = j.create(title: "x", decision: "", confidence: 50, now: date(1))
        j.delete(id: e.id)
        XCTAssertTrue(j.list().isEmpty)
    }
}
