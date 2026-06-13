# Architecture — Latticework

## Layering
```
┌─────────────────────────────────────────────┐
│  App target (SwiftUI + SwiftData, iOS 17+)   │  thin views, @Observable VMs
│  TodayView · LibraryView · DrillsView …      │
└───────────────▲─────────────────────────────┘
                │ depends on
┌───────────────┴─────────────────────────────┐
│  LatticeworkKit  (Foundation only)           │  pure, deep, testable
│  ContentLibrary · StreakEngine ·             │  no SwiftUI, no SwiftData,
│  ProgressService · DrillEngine ·             │  no wall-clock, no I/O in logic
│  DecisionJournal · MentalModel/DecisionEntry │
└──────────────────────────────────────────────┘
```
**Why:** the kit compiles and unit-tests on any machine with `swift test` — no
Xcode/simulator needed. Keep ALL real logic here behind small interfaces; the app
target is glue + presentation.

## Two data layers (never mix)
- **Bundled content** — the model library as versioned JSON, read-only at runtime.
  Editorial, not user data; updatable without a migration.
- **User data** — progress, decisions, streak — via SwiftData in the app target,
  CloudKit sync in a later phase. The kit defines storage *protocols*; the app
  provides SwiftData-backed implementations; tests provide in-memory doubles.

## Deep modules (interfaces — keep these stable)

### ContentLibrary  (pure)
- `init(models: [MentalModel])`
- `var all: [MentalModel]`
- `func models(in: Discipline) -> [MentalModel]`
- `func model(id: String) -> MentalModel?`
- `func disciplinesPresent() -> [Discipline]`  // canonical order, non-empty only
- `func modelOfTheDay(on: Date, calendar: Calendar) -> MentalModel?`
  // deterministic: `models[ordinalDay % count]` — stable per calendar day, no RNG
- `static func bundled() throws -> ContentLibrary`  // decodes the JSON resource
Test seam: pure input→output; the single cleanest module to test.

### StreakEngine  (pure)
- `struct StreakState { var count: Int; var lastActiveDay: Date? }`
- `struct StreakOutcome { var state: StreakState; var advanced: Bool }`
- `func markComplete(_ state: StreakState, now: Date, calendar: Calendar) -> StreakOutcome`
- `func isCompleted(_ state: StreakState, on: Date, calendar: Calendar) -> Bool`
Rules: first ever → count 1, advanced. Same day → unchanged, not advanced.
last == yesterday → +1, advanced. Otherwise → reset to 1, advanced. Always set
`lastActiveDay` to today. Inject `now`/`calendar`; never read the clock internally.

### ProgressService  (storage injected)
- `enum ModelStatus: String { case new, learning, mastered }`
- `protocol ProgressStore { … status(for:), set(status:drills:for:), drills(for:) }`
- `func status(for id: String) -> ModelStatus`  // default `.new`
- `func recordDrill(modelID: String)`  // new→learning; +1 drill; ≥ masteryThreshold → mastered
- `func learningCount(in ids: [String]) -> Int` / `func masteredCount(in:) -> Int`
Backed by `InMemoryProgressStore` (tests) or a SwiftData store (app).

### DrillEngine  (RNG injected)
- `struct DrillResult { let isCorrect: Bool; let explanation: String }`
- `func score(_ drill: MentalModel.Drill, choice: Int) -> DrillResult`
- `func next(from: [MentalModel], using: inout RandomNumberGenerator) -> MentalModel?`
Selection strategy lives behind this interface so spaced repetition can replace
random later without touching call sites. Inject RNG for deterministic tests.

### DecisionJournal  (storage injected)
- `struct DecisionEntry: Identifiable, Equatable { id, title, decision,
  modelsUsed:[String], expectedOutcome, confidence:Int, createdAt, reviewedOutcome?, reviewedAt? }`
- `protocol DecisionStore { add, all, update, delete }`
- `func create(title:decision:modelsUsed:expectedOutcome:confidence:now:) -> DecisionEntry`
  // clamps confidence to 0…100
- `func list() -> [DecisionEntry]`  // newest first
- `func recordOutcome(id:text:at:)` · `func delete(id:)`
Backed by `InMemoryDecisionStore` (tests) or SwiftData (app).

## Entitlement & notifications (app target, thin wrappers)
- `EntitlementService` — single observable `isPremium`; wraps StoreKit 2. The rest
  of the app reads only the boolean, never StoreKit directly.
- `NotificationScheduler` — `scheduleDaily(at:)`, `scheduleReview(for:on:)`; wraps
  `UserNotifications`. Verify via light integration tests / manual QA, not heavy units.

## Testing approach
- Assert external behavior through public interfaces; never private state.
- Inject storage + clock + RNG → no real I/O, no clock dependence.
- First-pass coverage: **StreakEngine** (all day-boundary cases incl. DST/timezone)
  and **ContentLibrary** (deterministic model-of-the-day, grouping, JSON decode).
  Then ProgressService, DrillEngine, DecisionJournal against in-memory doubles.
- Run `swift test` in `LatticeworkKit`; loop to green before wiring UI.
