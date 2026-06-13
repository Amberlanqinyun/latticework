# Latticework

A Charlie Munger mental-models iOS app — daily wisdom, recall drills, and a
decision journal. Notion-clean design, Open Sans, bespoke icons.

[![CI](https://github.com/Amberlanqinyun/latticework/actions/workflows/ci.yml/badge.svg)](https://github.com/Amberlanqinyun/latticework/actions/workflows/ci.yml)

## Layout
```
LatticeworkKit/      Pure, tested logic core (Foundation only) — see its README
Latticework/         SwiftUI + SwiftData app that consumes the kit
  Resources/         Theme (Notion tokens, Open Sans), bespoke AppIcon, models.json
  Models/            SwiftData @Models + store adapters for the kit protocols
  Data/              ContentStore / StreakStore (thin wrappers over the kit)
  Views/             Today · Library · ModelDetail · Drills · Journal · Profile
skills/latticework/  Reusable agent skill — the full build brief
docs/PROJECT_SETUP.md  How to create the Xcode project and link the package
mockups.html         Notion-premium design reference (build_mockups.py)
PRD.md               Comprehensive product requirements
```

## Architecture
The app is split into a **tested logic core** and a **thin UI layer**:

- `LatticeworkKit` holds all real logic behind deep, injectable interfaces:
  `ContentLibrary`, `StreakEngine`, `ProgressService`, `DrillEngine`,
  `DecisionJournal`. No SwiftUI, no SwiftData — so it builds and tests anywhere.
- The app provides SwiftData-backed implementations of the kit's storage
  protocols and renders the Notion design system (Open Sans + bespoke icons).

## Run / test the core
```bash
cd LatticeworkKit
swift run Verify   # 150 headless checks (no Xcode needed)
swift test         # XCTest suite (full Xcode / CI)
```

## Build the app
See [docs/PROJECT_SETUP.md](docs/PROJECT_SETUP.md) — create the iOS app target,
add `LatticeworkKit` as a local package, bundle `models.json`, install Open Sans.

## Reuse as a skill
```bash
npx skills add https://github.com/Amberlanqinyun/latticework --skill latticework
```

## Content note
Quotes are short, attributed excerpts used for educational commentary; verify
exact wording and attribution before public release.
