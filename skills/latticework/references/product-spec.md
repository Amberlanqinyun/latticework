# Product spec — Latticework

## Problem
People who want to think better keep *reading* Munger's wisdom but never *applying*
it. The material is long, dense, and scattered; readers highlight a quote, feel
briefly smarter, and forget it within a week. Nothing closes the loop between
learning a model and using it on a real decision.

## Solution
A 5-minute daily practice:
- **Model of the day** with a vivid example and a one-line "apply it" prompt.
- **Library** of ~31 models by discipline (Psychology, Economics, Math &
  Probability, Physics & Engineering, Biology, Inversion).
- **Drills** — scenario-based recall ("which bias is at play?") with instant feedback.
- **Decision journal** — log a real decision + models applied + confidence, then
  get nudged later to review the outcome and calibrate judgment over time.
- **Streak** + gentle daily reminder to build the habit.

The decision journal is the retention thesis — it's what makes the app sticky.
Give it disproportionate polish.

## The six core screens (v1)
1. **Today** — streak ring, model of the day (quote + attribution), "apply it"
   prompt, Mark complete.
2. **Library** — search; models grouped by discipline; each row shows a bespoke
   discipline icon + status.
3. **Model detail** — quote, "what it is", example, "when to use it", "the trap it
   prevents"; Start drill.
4. **Drill** — scenario, options, right/wrong feedback + explanation, haptics.
5. **Decision journal** — entries newest-first (date, confidence, reviewed); compose
   sheet; outcome review; calm empty state.
6. **Profile** — stats (streak, learning, mastered), subscription, about/provenance.

## Tabs
Today · Library · Drills · Journal · Profile. Active = ink, inactive = faint
(no colored active state).

## Monetization
Free tier is genuinely useful (today, starter models, basic journal). Premium
unlocks full library, advanced drills, iCloud sync. Monthly + annual (annual
cheaper per month). StoreKit 2. Entitlement read from a single observable source.

## Out of scope for v1
Android/web/macOS, AI chat, audio narration, social/community features, Apple
Watch, spaced repetition, widgets, Siri intents, localization beyond English,
full licensing of *Poor Charlie's Almanack* (ship original prose + short
attributed quotes only). Several of these are explicitly *later phases*.
