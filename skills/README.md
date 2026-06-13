# Latticework skills

Reusable agent skills extracted from this project so any coding agent (Claude
Code, Codex, Cursor, …) gets the full brief and builds consistently.

## `latticework`
The complete build brief for the Latticework app — product spec, the Notion-clean
+ Open Sans design system, the bespoke icon set, the deep-module architecture, the
content schema, and the TDD workflow. Load it before writing any Latticework code.

### Install
```bash
npx skills add https://github.com/Amberlanqinyun/latticework --skill latticework
```
Or copy `skills/latticework/SKILL.md` (and its `references/`) into your project,
or paste it into a Codex / ChatGPT conversation.

### Layout
```
skills/latticework/
├─ SKILL.md                     # the brief + non-negotiables + workflow
├─ references/
│  ├─ product-spec.md           # problem, solution, 6 screens, scope
│  ├─ design-system.md          # tokens, Open Sans scale, components
│  ├─ icons.md                  # bespoke icon set (no emoji/stock)
│  ├─ architecture.md           # deep modules + interfaces + data layers
│  └─ content-schema.md         # MentalModel / DecisionEntry shapes
└─ assets/
   └─ models.seed.json          # 10 seed models in canonical shape
```
