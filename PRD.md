# PRD — Latticework

> A Charlie Munger mental-models iOS app. Daily wisdom, recall drills, and a decision journal — in a Notion-clean, Open Sans, single-accent design system.

**Status:** ready-for-agent
**Platform:** iOS 17+ (SwiftUI, SwiftData)
**Author:** synthesized via `to-prd`
**Date:** 2026-06-13

> **Publishing note:** No issue tracker / triage-label vocabulary is configured for this project, so this PRD is committed as `PRD.md` rather than pushed to a tracker with the `ready-for-agent` label. Run the skill's `/setup` step (issue tracker + triage label) and I can publish it there instead.

---

## Problem Statement

People who want to think better — investors, founders, students, lifelong learners — keep *reading* Charlie Munger's wisdom but never *applying* it. The source material (*Poor Charlie's Almanack*, the talks, the psychology-of-misjudgment list) is long, dense, and scattered. Readers highlight a great quote, feel briefly smarter, and forget it within a week. There is no system that turns "worldly wisdom" into a repeatable daily practice, and — critically — nothing that closes the loop between *learning a model* and *using it on a real decision*. Insight without application is entertainment.

## Solution

Latticework turns Munger's mental models into a 5-minute daily habit:

- A **model of the day** on the home screen, with a vivid example and a one-line "apply it" prompt.
- A browsable **library** of ~31 models organized by discipline (Psychology, Economics, Math, Physics/Engineering, Biology, Inversion).
- **Drills** — scenario-based recall that asks "which bias is at play?" with instant feedback.
- A **decision journal** where the user logs a real decision, the models they applied, and their confidence — then gets nudged weeks later to review the outcome and calibrate their judgment over time.
- A **streak** system and gentle notifications to build the habit.

The product feels calm and document-like (Notion-inspired): a single typeface (Open Sans), a restrained monochrome palette with one warm-ink accent, flat hairline surfaces, generous whitespace, and a bespoke icon set drawn for the app (no stock/emoji icons). Munger's words are treated as the hero content.

---

## User Stories

### Onboarding & first run
1. As a new user, I want a short, calm welcome that explains the daily-model idea, so that I understand the habit I'm signing up for before I commit.
2. As a new user, I want to start using the app without creating an account, so that nothing blocks me from the first model.
3. As a returning user, I want my progress, streak, and journal to be on the device immediately at launch, so that I never see an empty loading screen.
4. As a privacy-conscious user, I want to optionally sign in with Apple, so that my data can sync without handing over an email/password.

### Today (daily practice)
5. As a daily user, I want one clearly chosen model each day, so that I'm not paralyzed by choice.
6. As a daily user, I want the day's model to stay the same all day and across relaunches, so that the experience feels stable and intentional.
7. As a daily user, I want to see Munger's actual quote for the model, attributed, so that I'm learning from the source, not a paraphrase.
8. As a daily user, I want a concrete "apply it today" prompt, so that the model leaves the screen and enters my life.
9. As a daily user, I want to mark the day complete and feel acknowledged (haptic + visual), so that completing feels rewarding.
10. As a daily user, I want my streak count visible, so that I'm motivated to maintain it.
11. As a daily user, I want the streak to advance only once per day and break only if I miss a full day, so that the count is honest and forgiving of same-day re-opens.
12. As a daily user, I want a gentle daily reminder notification, so that the habit survives busy days.
13. As a daily user, I want to tap the daily card to open the full model, so that I can go deeper when I have time.

### Library (browse & discover)
14. As a learner, I want models grouped by discipline, so that I can see the "latticework" structure Munger describes.
15. As a learner, I want to search models by title or quote text, so that I can find a specific idea fast.
16. As a learner, I want each model row to show its discipline and a distinct icon, so that I can scan visually.
17. As a learner, I want to see which models I've started vs. mastered, so that I can track coverage.
18. As a learner, I want disciplines with no models hidden, so that the library never shows empty sections.
19. As a learner, I want the library to feel calm and uncluttered even with 30+ models, so that browsing isn't overwhelming.

### Model detail
20. As a learner, I want the model's quote, plain-language definition, a vivid example, "when to use it," and "the trap it prevents," so that I understand the idea from multiple angles.
21. As a learner, I want to launch a drill directly from the model, so that I can immediately test my understanding.
22. As a learner, I want completing a drill to mark the model as "learning," so that my progress updates from real activity, not just views.
23. As a learner, I want a clear way back to the library, so that I never hit a dead end.
24. As a learner, I want related disciplines/tags shown, so that I can navigate laterally across the latticework.

### Drills (active recall)
25. As a learner, I want scenario-based questions ("a fund manager insists..."), so that I practice spotting models in realistic situations.
26. As a learner, I want immediate right/wrong feedback with an explanation, so that I learn from mistakes in the moment.
27. As a learner, I want a haptic cue on answering (success/error), so that feedback is felt, not just seen.
28. As a learner, I want to start a random drill from the Drills tab, so that I can practice without picking a specific model.
29. As a learner, I want completed drills to count toward my stats, so that effort is visible.
30. As a learner, I want a drill to be dismissable at any time, so that I'm never trapped in a flow.
31. As a returning learner, I want weak/forgotten models to resurface more often (spaced repetition), so that practice targets what I actually struggle with. *(later phase)*

### Decision journal (the differentiator)
32. As a decision-maker, I want to log a real decision with a title and description, so that I capture my reasoning at the moment.
33. As a decision-maker, I want to record which models I applied, so that I connect theory to practice.
34. As a decision-maker, I want to set my confidence (0–100%), so that I can later check whether I was over- or under-confident.
35. As a decision-maker, I want to record my expected outcome, so that there's something concrete to compare reality against.
36. As a decision-maker, I want to be reminded later to review the outcome, so that the loop actually closes.
37. As a decision-maker, I want to write what actually happened and mark the entry reviewed, so that I build a calibration record.
38. As a decision-maker, I want my entries listed newest-first with date, confidence, and reviewed status, so that I can scan my decision history.
39. As a decision-maker, I want to delete an entry, so that I control my own record.
40. As a decision-maker, I want a calm empty state explaining the journal's value, so that I understand why to use it before I have entries.
41. As a decision-maker, I want my calibration trend over time (confidence vs. actual), so that I can see my judgment improving. *(later phase)*

### Profile & stats
42. As a user, I want to see my current streak, models learning, and models mastered, so that I have a sense of progress.
43. As a user, I want stat numbers in tabular figures so they align cleanly, so that the screen feels precise.
44. As a user, I want a clear subscription area explaining Premium, so that I understand what upgrading gives me.
45. As a user, I want to restore a previous purchase, so that I'm not double-charged across devices.
46. As a user, I want an honest "about" note on the source material and quote usage, so that I trust the app's provenance.

### Subscription & monetization
47. As a free user, I want a meaningful free tier (today, a starter set of models, basic journal), so that the app is useful before paying.
48. As a prospective subscriber, I want Premium to unlock the full library, advanced drills, and iCloud sync, so that the value of upgrading is clear.
49. As a subscriber, I want monthly and annual options with the annual clearly cheaper per month, so that I can choose my commitment.
50. As a subscriber, I want my entitlement reflected immediately after purchase, so that there's no confusing delay.

### Sync & continuity
51. As a multi-device user, I want my progress, streak, and journal to sync across iPhone and iPad, so that my practice is continuous.
52. As an offline user, I want full read/write access offline with sync on reconnect, so that a subway ride never blocks me.

### Platform integration (later phases)
53. As a user, I want a Home/Lock screen widget showing the daily model and streak, so that wisdom meets me where I already look.
54. As a user, I want Siri/App Intents ("log a decision", "what's today's model"), so that I can act hands-free.
55. As a user, I want Dynamic Type and VoiceOver support, so that the app is usable regardless of ability.

### Reliability & trust
56. As a user, I want quotes to always be short and attributed, so that the app stays on the right side of fair use.
57. As a user, I want no crashes on first launch if content fails to load, so that I get a graceful message rather than a blank app.

---

## Implementation Decisions

### Architecture & stack
- **SwiftUI + iOS 17 minimum.** Uses `@Observable` (Observation framework), SwiftData, and modern view modifiers (`.snappy`, `.rect(cornerRadius:)`).
- **MVVM-lite with deep, isolated modules.** UI views stay thin; logic lives in small, testable services with stable interfaces (see modules below).
- **Two data layers, deliberately separated:**
  - **Bundled content** (the model library) ships as versioned JSON, loaded read-only at runtime. Content is editorial, not user data, and must be updatable without a migration.
  - **User data** (progress, decisions, streak) persists via SwiftData, with CloudKit sync in a later phase.

### Deep modules (build/modify)
The following are the high-level seams. Each encapsulates real functionality behind a simple interface that rarely changes:

1. **ContentStore** — *Deep module.* Loads and decodes the bundled model library; exposes querying (`all`, `byDiscipline`, `byID`) and the deterministic **model-of-the-day** selection. Interface: a small read-only API returning value types (`MentalModel`). Hides: bundle access, JSON decoding, the day-index math. This is the cleanest test seam in the app — pure input (a date, a content set) to output (a model), no I/O in the logic path.
2. **StreakEngine** — *Deep module.* Pure date logic: given the last-active date, the current date, and the current count, returns the new streak state and whether it advanced. Interface: `markComplete(now:) -> StreakResult` and `completedToday(now:)`. Hides: calendar/day-boundary handling. Persistence is injected, so the logic is testable with no storage.
3. **ProgressService** — Maps drill/learning events to per-model status transitions (`new → learning → mastered`). Interface: `recordDrill(modelID:)`, `status(for:)`. Backed by SwiftData but defined against a storage protocol so it can be tested in-memory.
4. **DrillEngine** — Selects the next drill (random now; spaced-repetition later) and scores an answer. Interface: `next()`, `score(answer:) -> DrillResult`. The selection strategy is swappable behind the interface so spaced repetition slots in without touching call sites.
5. **DecisionStore** — CRUD + outcome-review state for journal entries. Interface: `create`, `list`, `recordOutcome`, `delete`. SwiftData-backed via the storage protocol.
6. **EntitlementService** — Single source of truth for free vs. Premium. Interface: `isPremium` (observable) + `purchase`, `restore`. Wraps StoreKit 2; the rest of the app reads only the boolean/observable and never touches StoreKit directly.
7. **NotificationScheduler** — Schedules the daily reminder and journal-review nudges. Interface: `scheduleDaily(at:)`, `scheduleReview(for:on:)`. Wraps `UserNotifications`.

### Design system
- **Single typeface: Open Sans** (weights 300/400/500/600/700, plus italics). No other font families. Hierarchy comes from weight + size + spacing, not multiple fonts.
- **Palette:** background `#F7F6F3`, surface `#FFFFFF`, ink `#37352F`, secondary `#787774`, faint `#9B9A97`, hairline `rgba(55,53,47,.09)`. Semantic: green `#448361` (success/reviewed), red `#C4554D` (incorrect). One ink accent for primary actions; color is used sparingly (Notion-style).
- **Surfaces are flat "blocks":** white, 1px hairline border, ~12px radius, near-zero shadow, subtle hover/press tint. No heavy elevation, no nested cards.
- **Bespoke icon set:** all glyphs are custom single-stroke (1.55) SVG/SF-equivalent drawings — tabs (sunrise, layers, target, book, person), disciplines (eye, people, mind-ripples, trend, Venn, ring, shield, swap-arrows), a brand **lattice** mark (5 connected nodes), and stat glyphs (flame, book, seal). No emoji, no stock icon library.
- **Spacing:** generous; large section gaps, roomy block padding, line-height ~1.6. Calm and breathable over dense.
- **Tab bar:** 5 tabs — Today, Library, Drills, Journal, Profile. Active = ink, inactive = faint (no colored active state).

### Content model (schema)
- `MentalModel`: `id`, `title`, `discipline` (enum), `quote`, `definition`, `example`, `whenToUse`, `trap`, and a nested `Drill` (`scenario`, `options[]`, `correctIndex`, `explanation`). Codable, value type.
- `Discipline` enum: Psychology, Economics, Math & Probability, Physics & Engineering, Biology, Inversion — each with an associated bespoke icon.
- **Persisted (SwiftData):** `ModelProgress` (`modelID` unique, `status`, `lastReviewed`, `drillsCompleted`); `DecisionEntry` (`id`, `title`, `decision`, `modelsUsed[]`, `expectedOutcome`, `confidence`, `createdAt`, `reviewedOutcome?`, `reviewedAt?`).

### Key interactions / contracts
- **Model of the day** = `models[ ordinalDay % models.count ]` — deterministic per calendar day, stable across relaunch, no randomness, no network.
- **Streak rule:** completing marks today; if last-active was yesterday → increment; if today already → no-op; otherwise → reset to 1.
- **Drill completion** transitions a model to at least `learning` and increments `drillsCompleted`.
- **Free vs. Premium** gating reads `EntitlementService.isPremium` only.

### Content/legal
- Quotes are short, attributed excerpts; definitions and examples are original prose. No reproduction of book chapters. An "about" note states provenance. Licensing review precedes any deep expansion of source content.

---

## Testing Decisions

**What makes a good test here:** tests assert *external, observable behavior* through a module's public interface — never private state or implementation details. Given inputs in, expected values out. Storage and system services are injected so the logic modules are tested with no real I/O, no SwiftData container, and no clock dependence (dates are passed in).

**Modules to test (priority order):**
1. **StreakEngine** — the highest-value, purest seam. Cover: first-ever completion; same-day re-completion (no double count); consecutive-day increment; missed-day reset; week/month boundaries; DST/timezone day boundaries. All via injected `now`, no persistence.
2. **ContentStore (model-of-the-day + queries)** — deterministic selection for a given date and content set; stable across "relaunch" (re-instantiation); `byDiscipline` excludes empty disciplines; `byID` hits/misses; graceful behavior on empty/malformed content.
3. **ProgressService** — status transitions (`new → learning → mastered`), idempotent drill recording, query accuracy — against an in-memory storage double.
4. **DrillEngine** — answer scoring (correct/incorrect), selection returns a valid drill; (later) spaced-repetition surfaces weak models first.
5. **DecisionStore** — create/list ordering (newest-first), outcome-review state transition, delete — against an in-memory storage double.

**Lower priority / integration:** EntitlementService and NotificationScheduler are thin wrappers over Apple frameworks; verify with light integration tests or manual QA rather than heavy unit coverage.

**Prior art:** none yet — this establishes the testing pattern. The protocol-backed storage doubles and injected-clock approach become the template for future modules. (If the repo later adopts a snapshot-testing approach for views, model-detail and drill screens are the first candidates.)

**Confirm before building:** which of the five logic modules the team wants unit tests authored for in this first pass (recommendation: StreakEngine + ContentStore at minimum, as they are pure and high-value).

---

## Out of Scope

- Android / web / macOS apps (iOS + iPad only for v1).
- AI chat or a "talk to Munger" bot.
- Audio narration / audiobook playback.
- User-generated or community-shared models and decisions.
- Social features, leaderboards, friend streaks.
- Apple Watch app and Live Activities (candidate for a later phase).
- Spaced-repetition engine, calibration analytics, widgets, and Siri intents — explicitly **later phases**, not v1.
- Backend services / accounts beyond Sign in with Apple + CloudKit.
- Localization beyond English at launch.
- Full licensing of *Poor Charlie's Almanack* content (v1 ships original explanations + short attributed quotes only).

---

## Further Notes

- The **decision journal is the retention thesis.** Daily-wisdom apps churn because consumption is forgettable; the outcome-review loop is what makes Latticework sticky and is worth disproportionate polish and instrumentation.
- v1 content scope is ~31 models (the 25 cognitive biases from "The Psychology of Human Misjudgment" + Inversion + ~5 cross-disciplinary models). A seed set of 10 already exists in `models.json`; the remaining ~21 are an authoring task, gated on the legal/quote review.
- Design assets exist: a six-screen Notion-premium mockup (`mockups.html`, generated by `build_mockups.py`) defines the type scale, color tokens, spacing, and the bespoke icon set. These should be ported into the SwiftUI build (Open Sans, `#37352F` palette, flat blocks, custom icons) so code matches the spec.
- The existing SwiftUI scaffold already implements ContentStore, StreakStore (→ to be refactored into the pure **StreakEngine** + injected persistence), the five tabs, and the SwiftData models — so this PRD is partly a hardening/refactor effort, not a greenfield build.
