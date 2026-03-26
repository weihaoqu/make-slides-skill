# /make-slides — Claude Code Skill

Transform lecture slides (PPTX, PDF, or topic descriptions) into **interactive, Canvas-enhanced HTML decks** with step-through animations, playgrounds, and challenge quizzes.

```
sorting.pptx  →  sorting-enhanced.html (24 interactive slides)
```

## Quick Start

### 1. Install

```bash
git clone https://github.com/weihaoqu/make-slides-skill.git
cd make-slides-skill
bash install.sh
```

### 2. Use

Open [Claude Code](https://docs.anthropic.com/en/docs/claude-code) in any directory and type:

```
/make-slides sorting.pptx
```

That's it. Claude will extract your slides, build an interactive HTML deck, and run a quality audit — all automatically.

### 3. Open the output

```bash
open sorting-enhanced.html
```

Single self-contained HTML file. No dependencies. Works in any browser.

## More examples

```bash
# From a PDF
/make-slides chapter5.pdf

# From a topic (no source file needed)
/make-slides "Binary Search Trees"

# Pick a theme
/make-slides sorting.pptx --theme neon

# Generate a quiz/exercise app instead of slides
/make-slides sorting.pptx --exercise
```

## What you get

Every slide is enhanced with interactive elements:

- **Step-through animations** — Next / Auto / Reset buttons to walk through algorithms
- **Interactive playgrounds** — type values and watch data structures respond
- **Synced code highlighting** — code lines light up as execution progresses
- **3 inline challenges** — predict output, fix the bug, pick the right answer
- **3 quiz questions** — multiple choice, trace exercises, fill-in-the-blank
- **5 themes** — Aurora Light, Midnight Dark, Sunset Warm, Ocean Cool, Neon Pop

## How it works

```
Your slides (PPTX / PDF / topic)
        ↓
Phase A: Extract & Generate
        ↓  (automatic)
Phase B: Enhance — 3-part build with review between each part
        ↓
Phase C: Quality Audit — 5 parallel AI agents check accuracy
        ↓
Output: one interactive HTML file (~24 slides)
```

## Themes

| Theme | Look | Best For |
|-------|------|----------|
| **Aurora Light** (default) | White → indigo gradient | Classroom lectures |
| **Midnight Dark** | Deep navy | Lab sessions, coding demos |
| **Sunset Warm** | Warm cream → peach | Intro courses |
| **Ocean Cool** | Cool grey-blue | Conference talks |
| **Neon Pop** | Black with glow effects | Hackathons |

## What gets installed

The install script copies files into `~/.claude/`:

```
~/.claude/
├── commands/
│   └── make-slides.md            ← the /make-slides command
└── skills/
    ├── enhance-slides/
    │   └── SKILL.md              ← Canvas enhancement engine
    └── slide-generator/
        ├── SKILL.md              ← HTML generation engine
        └── references/
            ├── template.md
            ├── batch-generation.md
            └── feedback-form.md
```

To uninstall, just delete those files.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI

## License

MIT
