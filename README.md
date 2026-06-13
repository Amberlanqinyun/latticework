# Latticework — Charlie Munger Mental Models App

A SwiftUI iOS app that teaches Charlie Munger's mental models through daily lessons,
recall drills, and a personal decision journal. Apple HIG-native, content-first.

## What's here

```
Latticework/
├─ LatticeworkApp.swift          # App entry + SwiftData container
├─ Models/
│  ├─ MentalModel.swift          # Content model + Discipline enum + Drill
│  └─ Persisted.swift            # SwiftData: ModelProgress, DecisionEntry
├─ Data/
│  ├─ ContentStore.swift         # Loads models.json, "model of the day"
│  └─ StreakStore.swift          # Daily streak tracking (UserDefaults)
├─ Views/
│  ├─ RootTabView.swift          # 5-tab structure
│  ├─ TodayView.swift            # Daily model + streak + "apply it"
│  ├─ LibraryView.swift          # Models grouped by discipline + search
│  ├─ ModelDetailView.swift      # Full model card + drill launch
│  ├─ DrillsView.swift           # Recall drills with feedback
│  ├─ JournalView.swift          # Decision journal (the retention feature)
│  └─ ProfileView.swift          # Stats + subscription placeholder
└─ Resources/
   ├─ Theme.swift                # Paper/ink design system
   └─ models.json                # 10 seed mental models (MVP sample)
```

## Run it in Xcode

This is **source-only** (no `.xcodeproj` is generated outside Xcode). To run:

1. Open Xcode → **File ▸ New ▸ Project ▸ iOS App**.
   - Product name: `Latticework`
   - Interface: **SwiftUI**, Language: **Swift**, Storage: **SwiftData**
   - Minimum deployment: **iOS 17.0** (uses `@Observable`, SwiftData, `.snappy`).
2. Delete the auto-generated `ContentView.swift` and the `App` file.
3. Drag the contents of this `Latticework/` folder into the Xcode project navigator
   (check **"Copy items if needed"** and add to the target).
4. Ensure `models.json` is in **Target ▸ Build Phases ▸ Copy Bundle Resources**.
5. Build & run (⌘R) on an iOS 17+ simulator.

## Requirements
- Xcode 15+, iOS 17 SDK.

## Notes
- Quotes are short, attributed excerpts used for educational commentary. Explanations
  and examples are original. Review copyright/licensing before shipping (`Poor Charlie's Almanack`).
- Next steps: Widgets, Siri App Intents, CloudKit sync, StoreKit 2, spaced repetition.
