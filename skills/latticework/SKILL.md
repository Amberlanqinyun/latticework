---
name: latticework
description: >-
  Build and extend Latticework — a Charlie Munger mental-models iOS app (daily
  wisdom, recall drills, decision journal). Use this skill whenever a coding
  agent is asked to implement, extend, redesign, or scaffold Latticework or a
  feature inside it. It carries the full brief: product spec, the Notion-clean +
  Open Sans design system, the bespoke icon set, the deep-module architecture,
  the content schema, and the TDD workflow. Load it before writing any
  Latticework code so the build stays consistent with what was already designed.
---

# Latticework — build brief for coding agents

You are building **Latticework**, a calm iOS app that turns Charlie Munger's
mental models into a daily practice: a model of the day, a library of models by
discipline, recall drills, and a decision journal that closes the loop between
*learning a model* and *using it on a real decision*.

**Read these before coding** (in `references/`):
- `references/product-spec.md` — problem, solution, scope, the 6 screens.
- `references/design-system.md` — color tokens, Open Sans type scale, spacing, components.
- `references/icons.md` — the bespoke icon set (no emoji, no stock libraries).
- `references/architecture.md` — the deep modules, their interfaces, and the data layers.
- `references/content-schema.md` — the `MentalModel` / `DecisionEntry` shapes.
- `assets/models.seed.json` — 10 ready-to-use seed models in the canonical shape.

There is a fuller PRD at the repo root (`PRD.md`) — treat it as the source of
truth if anything here conflicts.

## Non-negotiables (the brand spine)

These define the product. Do not "improve" them away.

1. **One typeface: Open Sans.** Never introduce a second font family. Hierarchy
   comes from weight (300 display / 400 body / 600–700 UI) + size + spacing.
2. **Bespoke icons only.** Every glyph is a custom single-stroke (1.55) drawing.
   No emoji. No Lucide/Feather/SF-default icon dumps. See `references/icons.md`.
3. **Notion-clean surfaces.** Flat "blocks": white, 1px hairline border, ~12px
   radius, near-zero shadow, subtle hover/press tint. No nested cards, no heavy
   elevation, no gradients-as-decoration.
4. **Restrained palette.** Warm off-white canvas `#F7F6F3`, ink `#37352F`, one
   ink accent for primary actions. Color is rare and meaningful (green = success,
   red = incorrect). See tokens in `references/design-system.md`.
5. **Generous breathing room.** Roomy padding, large section gaps, ~1.6 line
   height. Calm over dense.
6. **Munger's words are the hero.** Quotes are short, attributed excerpts;
   definitions/examples are original prose. Keep it fair-use clean.

## Architecture rules

- **iOS 17+, SwiftUI + SwiftData**, `@Observable` state, MVVM-lite. Views stay thin.
- **Separate the logic core from the UI.** All real logic lives in a
  platform-agnostic Swift package, **`LatticeworkKit`** (Foundation only — no
  SwiftUI, no SwiftData), behind small, deep, testable interfaces. The app target
  depends on the kit. This is what makes the core unit-testable without a simulator.
- The deep modules and their interfaces are specified in
  `references/architecture.md`: **ContentLibrary, StreakEngine, ProgressService,
  DrillEngine, DecisionJournal**. Build/extend behind those interfaces; inject
  storage and the clock (pass `now`/`Calendar`) so logic is pure.
- **Two data layers:** bundled editorial content (versioned JSON, read-only) vs.
  user data (SwiftData, CloudKit sync later). Never mix them.

## How to work (TDD loop)

1. **Read** the references and the existing code; reuse components, don't rewrite.
2. **Sketch the module** you'll touch. If it has real logic, it belongs in
   `LatticeworkKit` behind a stable interface, not in a View.
3. **Write the test first** against the module's public interface. Test external
   behavior only — given inputs in, expected values out. Inject storage/clock so
   there's no real I/O and no dependence on the wall clock.
4. **Run `swift test`** in the `LatticeworkKit` package. Loop until green.
5. **Wire the SwiftUI view** on top, matching the design system exactly.
6. **Commit** in small, reviewable steps. Branch off `main`; never commit to a
   default branch directly without asking.

### What a good test looks like here
- Targets a module's public API, not its internals.
- Pure: `StreakEngine` and `ContentLibrary` take a date/content set and return a
  value — no persistence, no clock. `ProgressService` / `DecisionJournal` run
  against in-memory storage doubles.
- Priority coverage: **StreakEngine** (day-boundary, same-day no-op, consecutive
  increment, missed-day reset, DST/timezone) and **ContentLibrary** (deterministic
  model-of-the-day, discipline grouping, decode of `models.seed.json`).

## Definition of done for any feature

- Logic lives in `LatticeworkKit` behind a deep interface, with passing
  `swift test` coverage of its external behavior.
- The UI matches the design system: Open Sans only, bespoke icons, flat blocks,
  the token palette, generous spacing.
- No emoji or stock icons shipped. No second font. No nested-card clutter.
- Quotes stay short + attributed. New content matches `references/content-schema.md`.
- Changes are committed in small steps with a clear message.

When in doubt, prefer the calm, simple, Notion-like choice — and keep Munger's
idea, not the chrome, at the center of the screen.
