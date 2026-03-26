---
name: make-slides
description: Use when creating teaching slides from any source (PPTX, PDF, topic, or HTML). Unified pipeline that generates AND enhances slides in one flow — no need to run two separate skills. Triggers on "make slides", "create slides", "teaching slides", "convert to slides", "enhance slides", or any slide-related request.
---

# /make-slides — Transform Slides into Interactive Learning Experiences

Transform existing lecture slides (PPTX/PDF) into **interactive, Canvas-enhanced HTML decks** with step-through animations, playgrounds, and challenge quizzes. The default behavior: give it a PPTX or PDF → get back a self-contained HTML file with full interactivity.

## Default Behavior

```
/make-slides sorting.pptx
```

**This is the default and most common use case.** Takes existing lecture slides and produces an enhanced interactive HTML deck. No flags needed.

## Usage

```
/make-slides <input> [options]
```

## Input Detection

| Input | What Happens | Common? |
|-------|-------------|---------|
| `topic.pptx` | **DEFAULT:** Extract → generate → enhance with Canvas/quizzes | **Most common** |
| `topic.pdf` | **DEFAULT:** Extract → generate → enhance with Canvas/quizzes | **Most common** |
| `"Binary Search Trees"` | Generate from topic description → enhance | Occasional |
| `topic-explained.html` | Skip generation → enhance existing deck | Rare |
| `topic-enhanced.html part 2` | Resume enhancement at Part 2 | Resume |
| `--generate-only "topic"` | Generate explained HTML only, skip enhancement | Override |
| `--enhance-only file.html` | Enhance existing HTML only | Override |
| `--exercise file.pptx` | Generate standalone exercise app instead | Alternative |

## Default Pipeline (PPTX/PDF → Enhanced Interactive HTML)

```
Input: sorting.pptx (or .pdf)
         ↓
┌─────────────────────────────┐
│  Phase A: EXTRACT & GENERATE│
│  Read PPTX/PDF → extract    │
│  content → build base HTML  │
│  with ASCII diagrams &      │
│  callout boxes              │
└─────────────┬───────────────┘
              ↓
         (auto-proceed)
              ↓
┌─────────────────────────────┐
│  Phase B: ENHANCE           │
│  Base HTML → Canvas-enhanced│
│  interactive deck with:     │
│  • Step-through animations  │
│  • Interactive playgrounds  │
│  • Inline challenges (3)    │
│  • Final quiz section (3)   │
│  • Code highlighting sync   │
│  (3-part build with review) │
└─────────────┬───────────────┘
              ↓
┌─────────────────────────────┐
│  Phase C: QUALITY AUDIT     │
│  5 domain expert subagents  │
│  (parallel content check)   │
│  + main agent UI audit      │
│  → fix all issues found     │
└─────────────────────────────┘
              ↓
Output: sorting-enhanced.html
        (~24 slides, audited & fixed)
```

**No checkpoint between Phase A and B** — the pipeline auto-proceeds. The only pauses are during Phase B's 3-part enhancement build (plan summary → approval → Part 1 → Part 2 → Part 3).

## Interactivity Mandate

**Use Canvas animations and interactive elements as much as possible.** Every concept that CAN be visualized SHOULD be visualized. Override the enhance-slides priority table with these rules:

| Content Type | Enhancement | Priority |
|-------------|-------------|----------|
| Algorithm walkthrough | Step-through Canvas animation (Next/Auto/Reset) | **REQUIRED** |
| Data structure operations | Interactive playground (user inputs values) | **REQUIRED** |
| Code example | Synced `.line.active` highlighting with Canvas | **REQUIRED** |
| Comparison (A vs B) | Side-by-side Canvas with toggle | **REQUIRED** |
| **Concept definition** | **Canvas diagram with interactive exploration** | **REQUIRED** (upgraded from MEDIUM) |
| Process/workflow | **Animated flow with step-through** | **REQUIRED** (upgraded from LOW) |
| Summary / cheat sheet | Canvas decision flowchart | HIGH |
| Pure formula only | Static with callout boxes | OK as static |

**Rule: If a slide has NO Canvas or interactive element, justify WHY it can't be interactive.** Default to interactive, not static.

## Theme Selection

Ask the user to pick a theme **before generating**. Present these choices:

| # | Theme | Background | Accent Colors | Vibe | Best For |
|---|-------|-----------|---------------|------|----------|
| 1 | **Aurora Light** (default) | White → soft indigo → lavender gradient | Indigo/pink gradient headings, orange progress bar, purple buttons | Energetic, modern, clean | Classroom lectures, daytime presentations |
| 2 | **Midnight Dark** | Deep navy (#0f172a) | Blue/purple gradients, cyan accents | Focused, immersive, techy | Lab sessions, coding demos, evening classes |
| 3 | **Sunset Warm** | Warm cream (#fffbeb) → soft peach | Amber/coral headings, warm orange buttons | Friendly, approachable, warm | Intro courses, non-CS students |
| 4 | **Ocean Cool** | Cool grey-blue (#f0f9ff) → ice blue | Teal/cyan headings, sea-green buttons | Calm, professional, crisp | Conference talks, guest lectures |
| 5 | **Neon Pop** | Near-black (#0a0a0a) | Neon green/pink/cyan, glow effects | Bold, high-energy, game-like | Student engagement, hackathons |

### Theme Details

**Aurora Light** (default):
```css
body: background #f8fafc; color #1e293b;
slides: background linear-gradient(135deg, #f8fafc, #eef2ff, #faf5ff);
h1: gradient #6366f1 → #ec4899; font-weight 800;
buttons: gradient #6366f1 → #8b5cf6, white text, shadow;
code-blocks: dark (#1e293b) for contrast;
canvas: white background, soft shadows;
callouts: soft colored backgrounds with left borders;
tables: indigo gradient headers, white cells;
progress: gradient orange → pink → purple;
title slide: animated floating particles background;
```

**Midnight Dark:**
```css
body: background #0f172a; color #e2e8f0;
(Original dark theme from enhance-slides SKILL.md)
```

**Sunset Warm:**
```css
body: background #fffbeb; color #292524;
slides: background linear-gradient(135deg, #fffbeb, #fff7ed, #fef2f2);
h1: gradient #ea580c → #dc2626;
buttons: gradient #f97316 → #ef4444;
canvas: #fffbeb background;
callouts: warm amber/rose tints;
```

**Ocean Cool:**
```css
body: background #f0f9ff; color #0c4a6e;
slides: background linear-gradient(135deg, #f0f9ff, #ecfeff, #f0fdfa);
h1: gradient #0891b2 → #0d9488;
buttons: gradient #06b6d4 → #14b8a6;
canvas: white background;
callouts: cool cyan/teal tints;
```

**Neon Pop:**
```css
body: background #0a0a0a; color #e2e8f0;
slides: background #0a0a0a;
h1: gradient #22d3ee → #a855f7, text-shadow glow;
buttons: border neon, transparent bg, glow on hover;
canvas: #111 background with neon grid lines;
callouts: neon border glow effects;
```

### Override with flag:
```
/make-slides sorting.pptx --theme sunset
/make-slides sorting.pptx --theme neon
```

If no flag and user doesn't choose, default to **Aurora Light**.

## Phase A: Generate Base Deck

**Invoke the `slide-generator` skill logic:**

1. **Detect source type** and extract content:
   - PPTX → Read and extract slide text, notes, structure
   - PDF → Read in 10-page chunks, extract content
   - Topic text → Plan from scratch based on course level
2. **Ask Q** (combine into ONE question block):
   - "How many slides?" (default: 18-22)
   - "Any specific examples to include?"
   - "Course level?" (intro, intermediate, advanced)
   - **"Which theme?"** — present the choices below
3. **Plan** the slide structure (title → motivation → core concepts → traces → comparisons → summary)
4. **Generate** `{topic}-explained.html` using the slide-generator template from `~/.claude/skills/slide-generator/references/template.md`
5. **Verify** slide count, IDs, entities, self-containment

### Auto-Proceed to Enhancement

By default, **do NOT pause** between generation and enhancement — auto-proceed to Phase B immediately. The base deck is an intermediate artifact, not a deliverable.

Exception: If Q used `--generate-only`, deliver the explained HTML and stop.

## Phase B: Enhance with Interactivity

**Invoke the `enhance-slides` skill logic on the generated file:**

### Step 1: Analyze & Plan

1. **Analyze** the base HTML — catalog every slide, identify ALL enhancement candidates
2. **Plan enhancements** using the Interactivity Mandate table above (maximize Canvas/interactive)
3. **Identify merges** — consecutive slides showing the same operation step-by-step → merge into ONE interactive step-through
4. **Plan the 3-part split** with roughly equal slide counts

### Step 2: Present Summary to Q (REQUIRED — do NOT skip)

**Before writing any code**, present a detailed summary:

```
Enhancement Plan Summary:
═══════════════════════════
Source: {filename} ({N} original slides)
Target: {M} content slides + 6 challenge/quiz slides = ~{total} total

Part 1 (slides s1–s8):
  s1: Title slide (static)
  s2: Motivation — Canvas animated diagram showing [concept]
  s3: Core concept — Interactive playground for [operation]
  s4: Algorithm trace — Step-through with Next/Auto/Reset
  ...

Part 2 (slides s9–s14 + sCA, sCB):
  s9: [title] — Canvas [type]
  ...
  sCA: Challenge — Trace/Predict exercise
  sCB: Challenge — Fix the Bug exercise

Part 3 (slides s15–s18 + sCC + sQ1-sQ3):
  ...
  sCC: Challenge — Decision/Scenario exercise
  sQ1-sQ3: Final quiz section (3 questions)

Merges:
  - Original slides 7-8-9 → s5 (interactive step-through)
  - Original slides 12-13 → s9 (side-by-side comparison)

Interactive elements: {count} Canvas animations, {count} playgrounds,
  {count} step-throughs, 3 inline challenges, 3 quiz questions
Static slides: {count} (with justification for each)
```

**Wait for Q's approval before proceeding.**

### Step 3: Build Part by Part

5. **Build Part 1** → Q reviews → approval
6. **Build Part 2** → Q reviews → approval
7. **Build Part 3** (+ 6 challenge/quiz slides) → Q reviews → done

**Each part is a checkpoint. Never combine parts. Never skip ahead.**

Output: `{topic}-enhanced.html`

## Phase C: Quality Audit (after all 3 parts are built)

After the enhanced deck is complete, run a two-layer quality audit **before delivering to Q**.

### Layer 1: Content Audit — 5 Domain Expert Subagents (parallel)

Launch **5 subagents simultaneously**, each acting as a domain expert reviewing different aspects of the slide content:

| Subagent | Role | What It Checks |
|----------|------|---------------|
| **Accuracy Checker** | Domain expert | Factual correctness of all definitions, formulas, complexity claims, algorithm descriptions |
| **Code Reviewer** | Code expert | All code snippets compile/run correctly, no syntax errors, correct variable names, accurate output predictions |
| **Quiz Validator** | Assessment expert | All challenge/quiz answers are correct, distractors are plausible but wrong, explanations match the right answer |
| **Terminology Checker** | Language expert | Consistent terminology throughout, no typos in technical terms, correct use of CS jargon, proper capitalization |
| **Pedagogy Reviewer** | Teaching expert | Logical flow makes sense, "why" explanations are accurate, analogies don't mislead, difficulty progression is appropriate |

Each subagent receives the full HTML file and returns a list of issues found:
```
Agent prompt template:
"You are a [ROLE] reviewing an interactive HTML teaching deck about [TOPIC].
Read the entire file and report ALL issues you find in your domain.
For each issue: slide ID, exact text/code with the error, what's wrong, suggested fix.
If no issues found, say 'No issues found.'"
```

**Run all 5 in parallel using the Agent tool.** Collect all results.

### Layer 2: UI Audit — Main Agent (sequential, after content audit)

The **main agent** acts as a UI/UX expert and audits the visual/interactive quality by reading the HTML:

| Check | What to Look For | Fix |
|-------|-----------------|-----|
| **Canvas size** | Canvas too small for content (< 400px wide) | Increase to 520x370 minimum |
| **Code visibility** | Code blocks with text too small or truncated | Adjust font-size, add horizontal scroll |
| **Button overlap** | Buttons crowding or overlapping on narrow layouts | Add flex-wrap, adjust gap |
| **Canvas color contrast** | Canvas text unreadable (light text on light canvas, or dark text on dark fill) | Match all `ctx.fillStyle` text colors to the theme — see Canvas Color Rules in enhance-slides SKILL.md. Light themes: text must be `#1e293b`/`#475569`/`#4f46e5`, boxes `rgba(79,70,229,0.07-0.12)`. Dark themes: text `#e2e8f0`/`#94a3b8`, boxes `rgba(0,0,0,0.2-0.4)`. Every fillText must contrast its background rect. |
| **Log panel overflow** | Log div without max-height or overflow-y | Add `max-height:120px;overflow-y:auto` |
| **Navigation conflict** | Arrow keys interfering with text inputs | Verify INPUT/SELECT/TEXTAREA guard |
| **Slide count mismatch** | `totalSlides` doesn't match actual slide count | Fix the constant |
| **slideOrder completeness** | Missing slides from slideOrder array | Add all slide IDs |
| **MutationObserver** | Interactive slides missing observer (won't reinit on nav) | Add observer to each interactive slide |
| **Timer cleanup** | `setInterval` without `clearInterval` in reset | Add cleanup |
| **IIFE leaks** | Global variable pollution between slides | Wrap in IIFE, only expose `window.sNAction` |
| **Mobile layout** | Grid layouts breaking on small screens | Test responsive behavior |

### Step 4: Fix Issues

1. **Collect** all issues from both layers
2. **Prioritize**: content errors (wrong answers, incorrect code) > UI issues > cosmetic
3. **Fix all content errors** — these are blocking (wrong quiz answers = students learn wrong things)
4. **Fix all UI issues** that affect usability
5. **Report** to Q: "Fixed N content issues and M UI issues. Here's what was found and corrected."

### Skip Audit?

Add `--no-audit` to skip Phase C (not recommended):
```
/make-slides sorting.pptx --no-audit
```

## Quick Mode

For faster iteration when Q already knows what they want:

```
/make-slides "Sorting Algorithms" --quick
```

- Skips Checkpoint A (auto-proceeds to enhancement)
- Still pauses for the 3-part enhancement plan approval
- Good for batch generation of a known curriculum

## Exercise Mode

```
/make-slides sorting.pptx --exercise
```

- Generates a standalone exercise app instead of a slide deck
- All questions visible (scroll layout), timer, live scoring
- Uses the enhance-slides Exercise Architecture pattern

## Batch Mode

```
/make-slides --batch topics.txt
```

Where `topics.txt` is:
```
Binary Search Trees | intermediate
Graph Traversal (BFS/DFS) | intermediate
Shortest Path Algorithms | advanced
```

- Generates + enhances each topic using parallel subagents (3-5 at a time)
- Each agent gets: template reference, topic, course level
- Reports progress as each deck completes

## File Naming

| Phase | Output |
|-------|--------|
| Generate | `{topic}-explained.html` |
| Enhance | `{topic}-enhanced.html` |
| Exercise | `exercise-{topic}.html` |

## Key References

- **Slide generator template:** `~/.claude/skills/slide-generator/references/template.md`
- **Enhance-slides full spec:** `~/.claude/skills/enhance-slides/SKILL.md`
- **Completed deck examples:** See enhance-slides SKILL.md "Completed Decks Reference" section
- **Dark theme CSS:** Defined in enhance-slides SKILL.md Phase 3

## Error Handling

| Error | Recovery |
|-------|----------|
| PDF too large | Read in 10-page chunks with `pages` parameter |
| PPTX extraction incomplete | Ask Q to paste missing slide content |
| Base deck has too few diagrams | Add more ASCII diagrams before enhancing |
| Enhancement Part N too large | Split into smaller sub-parts |
| Canvas animation broken | Check IIFE encapsulation + MutationObserver |
