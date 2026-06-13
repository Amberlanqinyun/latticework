# Project setup — linking the app to LatticeworkKit

The app source (`Latticework/`) consumes the tested logic core
(`LatticeworkKit/`). There is no committed `.xcodeproj` (Xcode generates user
state); create the project once and wire it up as below.

## 1. Create the app target
Xcode → **File ▸ New ▸ Project ▸ iOS App**
- Product name: `Latticework`
- Interface: **SwiftUI**, Language: **Swift**, Storage: **SwiftData**
- Minimum deployment: **iOS 17.0**
- Delete the generated `ContentView.swift` and the generated `App` file.
- Drag the contents of `Latticework/` into the target (Copy items if needed).

## 2. Add LatticeworkKit as a local package
Xcode → **File ▸ Add Package Dependencies… ▸ Add Local…** → select the
`LatticeworkKit/` folder → add the `LatticeworkKit` library to the app target.

The app already `import LatticeworkKit` in its sources.

## 3. Bundle the content
Add `Latticework/Resources/models.json` to the app target's **Copy Bundle
Resources** (the app loads it via `ContentLibrary.load(from: .main)`, falling back
to the package resource bundle).

## 4. Install Open Sans (the only typeface)
1. Download Open Sans (Light, Regular, Medium, SemiBold, Bold + italics) and add
   the `.ttf` files to the target.
2. In **Info.plist**, add `UIAppFonts` (Fonts provided by application) with each
   filename. The PostScript names the app expects: `OpenSans-Light`,
   `OpenSans-Regular`, `OpenSans-Medium`, `OpenSans-SemiBold`, `OpenSans-Bold`,
   `OpenSans-Italic`, `OpenSans-LightItalic`. (`Theme.font` falls back gracefully
   if a face is missing, but install them for the intended look.)

## 5. Run
⌘R on an iOS 17+ simulator.

## Verifying the logic core (no Xcode needed)
```bash
cd LatticeworkKit
swift run Verify     # headless, 150 checks
swift test           # XCTest, under full Xcode / CI
```

## Architecture recap
- All logic lives in `LatticeworkKit` behind deep interfaces (ContentLibrary,
  StreakEngine, ProgressService, DrillEngine, DecisionJournal).
- The app provides SwiftData-backed `ProgressStore` / `DecisionStore`
  implementations (`Latticework/Models/Persisted.swift`) and thin `@Observable`
  wrappers (`ContentStore`, `StreakStore`, `AppState`).
- Design system (`Theme`, `AppIcon`, `Components`) is Open Sans + bespoke icons +
  flat Notion blocks, matching `mockups.html`.
