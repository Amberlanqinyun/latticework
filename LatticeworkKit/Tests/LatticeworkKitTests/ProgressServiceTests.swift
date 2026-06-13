import XCTest
@testable import LatticeworkKit

final class ProgressServiceTests: XCTestCase {
    func makeService(threshold: Int = 3) -> ProgressService {
        ProgressService(store: InMemoryProgressStore(), masteryThreshold: threshold)
    }

    func testUnknownModelDefaultsToNew() {
        XCTAssertEqual(makeService().status(for: "unseen"), .new)
    }

    func testFirstDrillMovesNewToLearning() {
        let svc = makeService()
        XCTAssertEqual(svc.recordDrill(modelID: "a"), .learning)
        XCTAssertEqual(svc.status(for: "a"), .learning)
    }

    func testReachingThresholdPromotesToMastered() {
        let svc = makeService(threshold: 3)
        XCTAssertEqual(svc.recordDrill(modelID: "a"), .learning)
        XCTAssertEqual(svc.recordDrill(modelID: "a"), .learning)
        XCTAssertEqual(svc.recordDrill(modelID: "a"), .mastered)
    }

    func testMasteryIsAOneWayRatchet() {
        let svc = makeService(threshold: 2)
        svc.recordDrill(modelID: "a")
        svc.recordDrill(modelID: "a") // mastered
        XCTAssertEqual(svc.recordDrill(modelID: "a"), .mastered) // stays mastered
    }

    func testMarkMasteredForces() {
        let svc = makeService()
        svc.markMastered(id: "a")
        XCTAssertEqual(svc.status(for: "a"), .mastered)
    }

    func testCountsOverASet() {
        let svc = makeService(threshold: 2)
        svc.recordDrill(modelID: "a")                 // learning
        svc.recordDrill(modelID: "b"); svc.recordDrill(modelID: "b") // mastered
        let ids = ["a", "b", "c"]
        XCTAssertEqual(svc.learningCount(in: ids), 1)
        XCTAssertEqual(svc.masteredCount(in: ids), 1)
    }

    func testStatusOrdering() {
        XCTAssertTrue(ModelStatus.new < .learning)
        XCTAssertTrue(ModelStatus.learning < .mastered)
    }
}
