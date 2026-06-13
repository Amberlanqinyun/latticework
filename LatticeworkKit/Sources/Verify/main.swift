import Foundation
import LatticeworkKit

// Minimal, dependency-free test harness (XCTest is unavailable under CLT-only).
// Mirrors the XCTest suites so the logic core can be verified headlessly.

var failures = 0
var checks = 0
func check(_ cond: Bool, _ msg: String) {
    checks += 1
    if !cond { failures += 1; print("  ✗ \(msg)") }
}
func eq<T: Equatable>(_ a: T, _ b: T, _ msg: String) { check(a == b, "\(msg) — got \(a), want \(b)") }
func group(_ name: String, _ body: () -> Void) { print("• \(name)"); body() }

let cal: Calendar = {
    var c = Calendar(identifier: .gregorian); c.timeZone = TimeZone(identifier: "America/New_York")!; return c
}()
func day(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date {
    cal.date(from: DateComponents(year: y, month: m, day: d, hour: h))!
}
func sample(_ id: String, _ disc: Discipline = .psychology) -> MentalModel {
    MentalModel(id: id, title: id, discipline: disc, quote: "q", definition: "d", example: "e",
                whenToUse: "w", trap: "t", drill: .init(scenario: "s", options: ["a","b","c","d"], correctIndex: 0, explanation: "x"))
}

// MARK: StreakEngine
group("StreakEngine") {
    let e = StreakEngine()
    let first = e.markComplete(StreakState(), now: day(2026,6,1), calendar: cal)
    eq(first.state.count, 1, "first completion = 1"); check(first.advanced, "first advances")

    let same = e.markComplete(first.state, now: day(2026,6,1,21), calendar: cal)
    eq(same.state.count, 1, "same day no-op count"); check(!same.advanced, "same day not advanced")

    let d2 = e.markComplete(first.state, now: day(2026,6,2), calendar: cal)
    let d3 = e.markComplete(d2.state, now: day(2026,6,3), calendar: cal)
    eq(d3.state.count, 3, "consecutive days increment")

    let gap = e.markComplete(d2.state, now: day(2026,6,4), calendar: cal)
    eq(gap.state.count, 1, "missed day resets")

    let monthEnd = StreakState(count: 9, lastActiveDay: cal.startOfDay(for: day(2026,6,30)))
    eq(e.markComplete(monthEnd, now: day(2026,7,1), calendar: cal).state.count, 10, "month boundary consecutive")

    let dst7 = e.markComplete(StreakState(), now: day(2026,3,7), calendar: cal)
    eq(e.markComplete(dst7.state, now: day(2026,3,8), calendar: cal).state.count, 2, "survives DST spring-forward")

    check(e.isCompleted(first.state, on: day(2026,6,1,23), calendar: cal), "isCompleted same day true")
    check(!e.isCompleted(first.state, on: day(2026,6,2), calendar: cal), "isCompleted next day false")
}

// MARK: ContentLibrary
group("ContentLibrary") {
    var utc = Calendar(identifier: .gregorian); utc.timeZone = TimeZone(identifier: "UTC")!
    let lib = ContentLibrary(models: [sample("a"), sample("b"), sample("c")])
    let d14a = utc.date(from: DateComponents(year: 2026, month: 6, day: 14, hour: 3))!
    let d14b = utc.date(from: DateComponents(year: 2026, month: 6, day: 14, hour: 22))!
    eq(lib.modelOfTheDay(on: d14a, calendar: utc), lib.modelOfTheDay(on: d14b, calendar: utc), "model-of-day stable within a day")
    let d15 = utc.date(from: DateComponents(year: 2026, month: 6, day: 15))!
    check(lib.modelOfTheDay(on: d14a, calendar: utc) != lib.modelOfTheDay(on: d15, calendar: utc), "model-of-day changes next day")
    check(ContentLibrary(models: []).modelOfTheDay(on: Date(), calendar: utc) == nil, "empty lib -> nil")

    let mixed = ContentLibrary(models: [sample("a", .inversion), sample("b", .psychology)])
    eq(mixed.disciplinesPresent(), [.psychology, .inversion], "disciplinesPresent canonical & non-empty")
    eq(mixed.model(id: "a")?.discipline, .inversion, "lookup by id")
    check(mixed.model(id: "zz") == nil, "missing id -> nil")

    do {
        let bundled = try ContentLibrary.bundled()
        check(bundled.all.count >= 10, "bundled decodes >= 10 models")
        for m in bundled.all {
            check(!m.quote.isEmpty, "\(m.id) has quote")
            check(m.drill.correctIndex >= 0 && m.drill.correctIndex < m.drill.options.count, "\(m.id) drill index in range")
        }
    } catch { failures += 1; print("  ✗ bundled() threw \(error)") }

    var threw = false
    do { _ = try ContentLibrary.decode(Data(#"[{"id":"x"}]"#.utf8)) } catch { threw = true }
    check(threw, "malformed JSON rejected")
}

// MARK: ProgressService
group("ProgressService") {
    let svc = ProgressService(store: InMemoryProgressStore(), masteryThreshold: 3)
    eq(svc.status(for: "x"), .new, "unknown -> new")
    eq(svc.recordDrill(modelID: "a"), .learning, "first drill -> learning")
    eq(svc.recordDrill(modelID: "a"), .learning, "second drill -> learning")
    eq(svc.recordDrill(modelID: "a"), .mastered, "third drill -> mastered")
    eq(svc.recordDrill(modelID: "a"), .mastered, "mastery is a ratchet")
    let s2 = ProgressService(store: InMemoryProgressStore(), masteryThreshold: 2)
    s2.recordDrill(modelID: "b"); s2.recordDrill(modelID: "b"); s2.recordDrill(modelID: "c")
    eq(s2.masteredCount(in: ["b","c"]), 1, "masteredCount")
    eq(s2.learningCount(in: ["b","c"]), 1, "learningCount")
    check(ModelStatus.new < .learning && ModelStatus.learning < .mastered, "status ordering")
}

// MARK: DrillEngine
group("DrillEngine") {
    let e = DrillEngine()
    let d = MentalModel.Drill(scenario: "s", options: ["a","b","c","d"], correctIndex: 2, explanation: "because")
    check(e.score(d, choice: 2).isCorrect, "correct choice")
    check(!e.score(d, choice: 0).isCorrect, "wrong choice")
    check(!e.score(d, choice: 99).isCorrect, "out-of-range choice incorrect")
    eq(e.score(d, choice: 2).explanation, "because", "explanation surfaced")
    let pool = (0..<4).map { sample("\($0)") }
    let ids = Set(pool.map(\.id))
    for _ in 0..<50 { check(ids.contains(e.next(from: pool)!.id), "next() returns a pool member") }
    check(e.next(from: []) == nil, "empty pool -> nil")
}

// MARK: DecisionJournal
group("DecisionJournal") {
    let c = Calendar(identifier: .gregorian)
    func dt(_ d: Int) -> Date { c.date(from: DateComponents(year: 2026, month: 6, day: d))! }
    let j = DecisionJournal(store: InMemoryDecisionStore())
    let e = j.create(title: "Hire?", decision: "Yes", confidence: 70, now: dt(1))
    eq(j.list().count, 1, "create stores")
    eq(j.create(title: "hi", decision: "", confidence: 150, now: dt(2)).confidence, 100, "confidence clamps high")
    eq(j.create(title: "lo", decision: "", confidence: -5, now: dt(3)).confidence, 0, "confidence clamps low")
    eq(j.list().first!.title, "lo", "list newest first")
    let rev = j.recordOutcome(id: e.id, text: "worked", at: dt(20))
    check(rev?.reviewedOutcome == "worked", "recordOutcome sets text")
    check(j.recordOutcome(id: UUID(), text: "x", at: dt(1)) == nil, "unknown id -> nil")
    j.delete(id: e.id)
    check(!j.list().contains { $0.id == e.id }, "delete removes entry")
}

print("\n\(checks - failures)/\(checks) checks passed.")
if failures > 0 { print("FAILED: \(failures)"); exit(1) }
print("ALL GREEN ✓")
