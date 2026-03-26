# /make-slides — Claude Code Skill

Transform lecture slides (PPTX, PDF, or topic descriptions) into **interactive, Canvas-enhanced HTML decks** with step-through animations, playgrounds, and challenge quizzes. One command, fully automated.

## What it does

```
sorting.pptx  →  sorting-enhanced.html (24 interactive slides)
```

Give it a PPTX, PDF, or topic name. It extracts content, builds a base HTML deck, then enhances every slide with:

- **Canvas step-through animations** (Next / Auto / Reset)
- **Interactive playgrounds** (user inputs values, watches operations)
- **Code highlighting** synced to execution trace
- **3 inline challenges** (predict, fix-the-bug, pick-the-answer)
- **3 quiz questions** (MC, trace, fill-in-the-blank)
- **5 themes** (Aurora Light, Midnight Dark, Sunset Warm, Ocean Cool, Neon Pop)

Output is a **single self-contained HTML file** — no dependencies, no build step. Open in any browser.

## Demo

The skill has been used to produce 15+ enhanced decks for CS courses (data structures, algorithms, computer architecture).

## Install

```bash
git clone https://github.com/YOUR_USERNAME/make-slides-skill.git
cd make-slides-skill
bash install.sh
```

This copies 3 files into your `~/.claude/` directory:

```
~/.claude/
├── commands/
│   └── make-slides.md          # The /make-slides command
└── skills/
    ├── enhance-slides/
    │   └── SKILL.md            # Canvas enhancement engine
    └── slide-generator/
        ├── SKILL.md            # Base HTML generation engine
        └── references/
            ├── template.md     # Slide HTML template
            ├── batch-generation.md
            └── feedback-form.md
```

## Usage

Open Claude Code in any directory and run:

```bash
# From a PPTX file (most common)
/make-slides sorting.pptx

# From a PDF
/make-slides chapter5.pdf

# From a topic description
/make-slides "Binary Search Trees"

# With theme selection
/make-slides sorting.pptx --theme neon

# Exercise mode (scrollable quiz app instead of slides)
/make-slides sorting.pptx --exercise

# Skip the quality audit
/make-slides sorting.pptx --no-audit
```

## How it works

```
Input (PPTX/PDF/topic)
        ↓
Phase A: Extract & Generate
  Read source → build base HTML deck
        ↓ (auto-proceed)
Phase B: Enhance (3-part build)
  Part 1 → review → Part 2 → review → Part 3 → review
  Each slide gets Canvas visualizations + interactivity
        ↓
Phase C: Quality Audit
  5 parallel subagents check:
  • Content accuracy    • Code correctness
  • Quiz answers        • Terminology
  • Pedagogy flow
  + UI audit (contrast, canvas sizing, navigation, timers)
        ↓
Output: topic-enhanced.html (~24 slides, audited)
```

## Themes

| Theme | Background | Best For |
|-------|-----------|----------|
| **Aurora Light** (default) | White → indigo → lavender | Classroom lectures |
| **Midnight Dark** | Deep navy (#0f172a) | Lab sessions, coding demos |
| **Sunset Warm** | Warm cream → peach | Intro courses |
| **Ocean Cool** | Cool grey-blue → ice | Conference talks |
| **Neon Pop** | Near-black with glow | Hackathons, engagement |

## Architecture

The skill is 3 files working together:

- **`make-slides.md`** — The command. Orchestrates the full pipeline (extract → generate → enhance → audit). Handles theme selection, flags, and the 3-part build pattern.
- **`enhance-slides/SKILL.md`** — The enhancement engine. Contains all Canvas patterns (trees, graphs, arrays, bar charts), JS patterns (IIFE, step-through, MutationObserver), CSS themes, challenge templates, and the quality checklist.
- **`slide-generator/SKILL.md`** — The generation engine. Converts PPTX/PDF/topic into a base HTML deck with ASCII diagrams, callout boxes, and proper slide structure.

## Key design decisions

- **Single HTML file** — no dependencies, no framework, no build step
- **Canvas API over SVG** — more consistent for animations, better performance
- **IIFE per slide** — no global variable leaks between slides
- **MutationObserver on every interactive slide** — proper reset on forward/backward navigation
- **Precomputed steps** — never compute algorithm steps during animation
- **Theme-aware canvas colors** — light themes use dark text, dark themes use light text (enforced by validation rules)

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- That's it. No other dependencies.

## License

MIT
