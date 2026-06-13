# Content schema — Latticework

All content is value-type `Codable`. The bundled library is read-only editorial
data; user data is separate (SwiftData in the app).

## MentalModel (bundled content)
```jsonc
{
  "id": "incentive-bias",            // stable kebab-case id
  "title": "Incentive-Caused Bias",
  "discipline": "Psychology",        // must match a Discipline raw value
  "quote": "Show me the incentive and I will show you the outcome.", // short, attributed to Munger
  "definition": "People unconsciously rationalize behavior that serves their incentives…",
  "example": "A salesperson paid on commission recommends the product that pays most…",
  "whenToUse": "Any time you receive advice or design a system that rewards people.",
  "trap": "Trusting stated motives while ignoring the rewards shaping them.",
  "drill": {
    "scenario": "A fund manager insists their high-fee product is best for you. What should you weigh most?",
    "options": ["Their confidence", "Their credentials", "How they are compensated", "How long they've worked there"],
    "correctIndex": 2,
    "explanation": "Incentive-caused bias predicts compensation structure shapes the recommendation more than sincerity."
  }
}
```
- `Discipline` raw values (canonical order): `Psychology`, `Economics`,
  `Math & Probability`, `Physics & Engineering`, `Biology`, `Inversion`.
- Each discipline maps to one bespoke icon (see `icons.md`).
- Quotes are short, attributed excerpts (fair use). Definitions/examples are
  original prose — never paste book passages.
- See `assets/models.seed.json` for 10 valid examples.

## ModelProgress (user data — SwiftData)
- `modelID` (unique) · `status` (`new|learning|mastered`) · `lastReviewed: Date?`
  · `drillsCompleted: Int`

## DecisionEntry (user data — SwiftData)
- `id: UUID` · `title` · `decision` · `modelsUsed: [String]` (model ids/titles)
  · `expectedOutcome` · `confidence: Int` (0–100, clamped) · `createdAt: Date`
  · `reviewedOutcome: String?` · `reviewedAt: Date?`

## Content scope (v1)
~31 models = the 25 cognitive biases from "The Psychology of Human Misjudgment"
+ Inversion + ~5 cross-disciplinary models. 10 seed models already exist; the
rest are an authoring task gated on a quote/licensing review.

## Authoring checklist for a new model
1. Unique kebab-case `id`; `discipline` matches a canonical raw value.
2. Quote ≤ ~1 sentence, attributable to Munger.
3. Original definition, vivid example, clear `whenToUse`, sharp `trap`.
4. One drill: 4 options, correct index, an explanation that teaches the model.
5. Validate it decodes (the `ContentLibrary` JSON test should stay green).
