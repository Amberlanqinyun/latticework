import XCTest
@testable import LatticeworkKit

/// Seedable deterministic RNG for testing selection.
private struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state ^= state << 13; state ^= state >> 7; state ^= state << 17
        return state
    }
}

final class DrillEngineTests: XCTestCase {
    let engine = DrillEngine()

    private func drill(correct: Int) -> MentalModel.Drill {
        .init(scenario: "s", options: ["a", "b", "c", "d"], correctIndex: correct, explanation: "because")
    }

    func testScoringCorrect() {
        let r = engine.score(drill(correct: 2), choice: 2)
        XCTAssertTrue(r.isCorrect)
        XCTAssertEqual(r.explanation, "because")
    }

    func testScoringIncorrect() {
        XCTAssertFalse(engine.score(drill(correct: 2), choice: 0).isCorrect)
    }

    func testOutOfRangeChoiceIsIncorrect() {
        XCTAssertFalse(engine.score(drill(correct: 2), choice: 99).isCorrect)
        XCTAssertFalse(engine.score(drill(correct: 2), choice: -1).isCorrect)
    }

    func testNextReturnsNilForEmptyPool() {
        var rng: any RandomNumberGenerator = SeededRNG(seed: 1)
        XCTAssertNil(engine.next(from: [], using: &rng))
    }

    func testNextIsDeterministicWithSeededRNG() {
        let pool = (0..<5).map {
            MentalModel(id: "\($0)", title: "t", discipline: .psychology, quote: "q", definition: "d",
                        example: "e", whenToUse: "w", trap: "t",
                        drill: drill(correct: 0))
        }
        var a: any RandomNumberGenerator = SeededRNG(seed: 42)
        var b: any RandomNumberGenerator = SeededRNG(seed: 42)
        XCTAssertEqual(engine.next(from: pool, using: &a)?.id, engine.next(from: pool, using: &b)?.id)
    }

    func testNextAlwaysReturnsAMemberOfThePool() {
        let pool = (0..<3).map {
            MentalModel(id: "\($0)", title: "t", discipline: .math, quote: "q", definition: "d",
                        example: "e", whenToUse: "w", trap: "t", drill: drill(correct: 1))
        }
        let ids = Set(pool.map(\.id))
        var rng: any RandomNumberGenerator = SeededRNG(seed: 7)
        for _ in 0..<50 {
            XCTAssertTrue(ids.contains(engine.next(from: pool, using: &rng)!.id))
        }
    }
}
