# Bespoke icon set — Latticework

**Rule: every glyph is a custom single-stroke drawing. No emoji. No stock icon
libraries (Lucide/Feather/Heroicons). No SF Symbols for brand glyphs.**

- Style: `stroke: currentColor; fill: none; stroke-width: 1.55; linecap: round;
  linejoin: round;` on a `0 0 24 24` viewBox.
- One consistent stroke weight across the whole set.
- Sizes: tab 22px · title-chip 19px · list/discipline 17px · pill/inline 13px.

The canonical path data lives in `build_mockups.py` (the `I = {…}` dict). Reuse
those exact paths when porting to SwiftUI `Path`/SVG. The set:

## Navigation / titles
| Name | Meaning | Shape |
|---|---|---|
| `today` | Today tab | sunrise — horizon line + half-sun arc + 3 rays |
| `library` | Library tab | stacked layers (three offset diamonds) |
| `drills` | Drills tab | concentric target (3 rings + dot) |
| `journal` | Journal tab | book with spine line |
| `profile` | Profile tab | head + shoulders |
| `lattice` | brand mark | 5 connected nodes (the app's namesake) |

## Discipline / concept marks
| Name | Used for | Shape |
|---|---|---|
| `psychology` | Psychology / Confirmation bias | concentric "mind ripples" + dot |
| `economics` | Economics | upward trend arrow |
| `math` | Math & Probability | two overlapping circles (Venn) |
| `inversion` | Inversion | two swap arrows |
| `shield` | Margin of Safety | shield |
| `people` | Social Proof | two figures |
| `circle` | Circle of Competence | ring inside ring |
| `eye` | Incentive-Caused Bias | eye |

## Stats / misc
| Name | Shape |
|---|---|
| `flame` | streak flame |
| `seal` | check inside a circle (mastered / reviewed) |
| `search` | magnifier |
| `pencil` | compose |
| `back` | chevron-left |
| `x` | cross (incorrect) |
| `spark` | small radiant dot (status accent) |

## Adding a new icon
1. Draw it on the `0 0 24 24` grid at 1.55 stroke, matching the existing set's
   geometric, calm feel (no filled shapes, no decorative flourishes).
2. Add the path to the `I` dict in `build_mockups.py` so the mockups stay in sync.
3. Mirror it as a SwiftUI `Path` in the app's `Icon` view.
4. Map disciplines to their glyph in one place so the library/journal stay consistent.
