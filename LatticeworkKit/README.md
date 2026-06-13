# LatticeworkKit

The pure, platform-agnostic logic core for the Latticework app (Foundation only —
no SwiftUI, no SwiftData). The iOS app target depends on this package; all real
logic lives here behind small, deep, testable interfaces.

## Modules
| Module | Responsibility | Test seam |
|---|---|---|
| `ContentLibrary` | Load & query the bundled model library; deterministic model-of-the-day | pure (date + content in → model out) |
| `StreakEngine` | Streak day-boundary logic | pure (inject `now` / `Calendar`) |
| `ProgressService` | `new → learning → mastered` transitions | injected `ProgressStore` |
| `DrillEngine` | Score answers, select next drill | injected RNG |
| `DecisionJournal` | Decision CRUD + outcome review | injected `DecisionStore` |

Value types: `MentalModel`, `MentalModel.Drill`, `Discipline`, `DecisionEntry`,
`StreakState`, `ModelStatus`.

## Running the tests

**With full Xcode / CI:**
```bash
cd LatticeworkKit && swift test
```

**Headless (Command Line Tools only — no XCTest):**
```bash
cd LatticeworkKit && swift run Verify
```
`Verify` is a dependency-free runner that mirrors the XCTest coverage and exits
non-zero on failure (108 checks across all five modules).

## Design principles
- Inject storage, the clock, and RNG — logic never touches real I/O or the wall clock.
- Test external behavior through public interfaces only, never internals.
- Two data layers stay separate: bundled editorial content vs. user data.
