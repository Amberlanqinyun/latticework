import XCTest
@testable import LatticeworkKit

final class ContentLibraryTests: XCTestCase {
    var cal = Calendar(identifier: .gregorian)

    override func setUp() {
        super.setUp()
        cal.timeZone = TimeZone(identifier: "UTC")!
    }

    private func model(_ id: String, _ disc: Discipline = .psychology) -> MentalModel {
        MentalModel(id: id, title: id.capitalized, discipline: disc, quote: "q", definition: "d",
                    example: "e", whenToUse: "w", trap: "t",
                    drill: .init(scenario: "s", options: ["a", "b"], correctIndex: 0, explanation: "x"))
    }

    func testModelOfTheDayIsDeterministicForSameDay() {
        let lib = ContentLibrary(models: [model("a"), model("b"), model("c")])
        let date = cal.date(from: DateComponents(year: 2026, month: 6, day: 14, hour: 3))!
        let later = cal.date(from: DateComponents(year: 2026, month: 6, day: 14, hour: 22))!
        XCTAssertEqual(lib.modelOfTheDay(on: date, calendar: cal),
                       lib.modelOfTheDay(on: later, calendar: cal))
    }

    func testModelOfTheDayChangesAcrossConsecutiveDays() {
        let lib = ContentLibrary(models: [model("a"), model("b"), model("c")])
        let d1 = cal.date(from: DateComponents(year: 2026, month: 6, day: 14))!
        let d2 = cal.date(from: DateComponents(year: 2026, month: 6, day: 15))!
        XCTAssertNotEqual(lib.modelOfTheDay(on: d1, calendar: cal),
                          lib.modelOfTheDay(on: d2, calendar: cal))
    }

    func testModelOfTheDayWrapsModuloCount() {
        let models = [model("a"), model("b")]
        let lib = ContentLibrary(models: models)
        // Two days exactly `count` apart should land on the same model.
        let d1 = cal.date(from: DateComponents(year: 2026, month: 6, day: 14))!
        let d3 = cal.date(from: DateComponents(year: 2026, month: 6, day: 16))!
        XCTAssertEqual(lib.modelOfTheDay(on: d1, calendar: cal),
                       lib.modelOfTheDay(on: d3, calendar: cal))
    }

    func testEmptyLibraryHasNoModelOfTheDay() {
        XCTAssertNil(ContentLibrary(models: []).modelOfTheDay(on: Date(), calendar: cal))
    }

    func testDisciplinesPresentExcludesEmptyAndKeepsCanonicalOrder() {
        let lib = ContentLibrary(models: [model("a", .inversion), model("b", .psychology)])
        XCTAssertEqual(lib.disciplinesPresent(), [.psychology, .inversion])
    }

    func testModelsInDisciplineAndLookupByID() {
        let lib = ContentLibrary(models: [model("a", .economics), model("b", .economics), model("c", .biology)])
        XCTAssertEqual(lib.models(in: .economics).map(\.id), ["a", "b"])
        XCTAssertEqual(lib.model(id: "c")?.discipline, .biology)
        XCTAssertNil(lib.model(id: "zzz"))
    }

    func testBundledContentDecodesAndIsNonEmpty() throws {
        let lib = try ContentLibrary.bundled()
        XCTAssertGreaterThanOrEqual(lib.all.count, 10)
        // every model has a 4-or-more-option drill with an in-range correct index
        for m in lib.all {
            XCTAssertFalse(m.quote.isEmpty, "\(m.id) missing quote")
            XCTAssertTrue(m.drill.correctIndex >= 0 && m.drill.correctIndex < m.drill.options.count,
                          "\(m.id) correctIndex out of range")
        }
    }

    func testDecodeRejectsMalformedJSON() {
        let bad = Data(#"[{"id":"x"}]"#.utf8)
        XCTAssertThrowsError(try ContentLibrary.decode(bad))
    }
}
