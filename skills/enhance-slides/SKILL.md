---
name: enhance-slides
description: Enhance lecture slides (PPTX, PDF, or HTML) into interactive Canvas-based learning experiences with step-through animations, playgrounds, and challenge quizzes. Accepts any source format. Can also generate standalone exercise apps.
argument-hint: [file-path] [optional: part-number or slide-range or "exercise"]
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

# Enhance Slides with Interactive Components

Transform lecture slides from **any format** (PPTX, PDF, or existing HTML) into interactive, self-contained HTML decks with Canvas visualizations, step-through animations, and challenge quizzes.

**Target file:** `$0`
**Focus area:** $1 (if not specified, analyze the entire source and propose a 3-part split)

---

## Phase 0: Input Detection & Content Extraction

Detect the input file type and extract content accordingly:

### Route by file extension:

| Input | Action |
|-------|--------|
| `*.pptx` | Extract text from each slide → build enhanced deck directly |
| `*.pdf` | Read pages in chunks of ~10 → extract content → build enhanced deck directly |
| `*-explained.html` | Existing HTML deck → analyze and enhance (original flow) |
| `*-enhanced.html` + part N | Resume building an in-progress enhanced deck |
| Any `.html` | Analyze structure → enhance |

### Extracting from PPTX

1. **Read the file** using the Read tool (Claude Code can read PPTX files)
2. For each slide, extract:
   - **Title** (usually the first text element)
   - **Body text** (bullet points, paragraphs)
   - **Code snippets** (monospace/formatted text blocks)
   - **Diagrams described in text** (note these — they become Canvas visualizations)
   - **Speaker notes** (if present — often contain teaching context)
3. Create a **slide inventory**: slide number, title, content type, enhancement candidate
4. Note the logical flow and topic groupings

### Extracting from PDF

1. **Read in chunks** using `pages` parameter: `pages: "1-10"`, then `"11-20"`, etc.
2. For each page, extract:
   - **Slide title** (usually largest/boldest text)
   - **Content** (text, bullet points, code)
   - **Figures/diagrams** (note their descriptions — these become Canvas visualizations)
3. PDF slides often have less structure than PPTX — you may need to infer slide boundaries from visual breaks or topic shifts
4. Create the same **slide inventory** as for PPTX

### Content Planning (PPTX/PDF only)

After extraction, plan the enhanced deck:
1. **Identify the topic** and course level from the content
2. **Group related slides** — consecutive slides on the same sub-topic may merge
3. **Decide what to keep, merge, and add**:
   - Keep: core definitions, examples, code, analogies
   - Merge: multi-step traces into one interactive step-through
   - Add: challenges (sCA, sCB, sCC) and quiz (sQ1, sQ2, sQ3)
4. **Fill gaps** — PPTX/PDF often lack the depth of an explained HTML deck. Add:
   - "Why" explanations for key concepts
   - Real-world analogies (`.analogy` callout)
   - Common mistakes (`.warning` callout)
   - Key insights (`.key-idea` callout)
5. **Target ~18 content slides** + 6 challenge/quiz slides = ~24 total

### Output file naming:
- Input: `sorting.pptx` → Output: `sorting-enhanced.html`
- Input: `chapter5.pdf` → Output: `chapter5-enhanced.html`
- Input: `trees-explained.html` → Output: `trees-enhanced.html`

---

## Workflow: Plan First, Build in Parts, Always Get Approval

**Never skip planning or build without approval:**

1. **Read** the source file completely (extract if PPTX/PDF)
2. **Propose** a detailed numbered plan (slide-by-slide with enhancement types)
3. **Wait for approval** before writing any code
4. **Build Part 1** → review → approval
5. **Build Part 2** → review → approval
6. **Build Part 3** → review → done

Each part is a checkpoint. Never combine parts. Always explain the "why" behind design choices.

---

## Architecture: 3-Part Build Pattern

Large decks (15+ original slides) are always split into 3 parts for incremental review:

- **Part 1**: Write as a brand-new file. Includes all CSS, the first ~8 slides, navigation JS, and the slideOrder array.
- **Part 2**: Edit the existing file. Replace from `<!-- ==================== NAVIGATION ==================== -->` through `const slideOrder = [...]` with new slide HTML + updated nav + extended slideOrder.
- **Part 3**: Same edit pattern as Part 2. Adds remaining content slides + 6 challenge slides.

**Before each edit**: Always Grep for both `<!-- ==================== NAVIGATION ====================` and `const slideOrder` to confirm exact line numbers.

---

## Phase 1: Analyze the Source

### If source is HTML (existing deck):
1. Read the original file completely
2. Catalog every slide: number, title, content type

### If source is PPTX or PDF (raw slides):
1. Extract content using Phase 0 steps above
2. Create a slide inventory from extracted content
3. Identify which raw slides map to which enhanced slides
4. Note where you need to **add depth** (explanations, analogies, warnings) that raw slides lack

### For all input types:
3. **Identify merge opportunities** — multiple static slides showing the same operation step-by-step should become ONE interactive slide with step/auto/reset controls (e.g., 3 Dijkstra trace slides → 1 Canvas step-through)
4. Plan the 3-part split with roughly equal slide counts
5. For each slide, decide the enhancement pattern:

| Content Type | Enhancement Pattern | Priority |
|---|---|---|
| Algorithm walkthrough (step-by-step) | **Step-through** — Next/Auto/Reset with Canvas animation | HIGH |
| Data structure operations (insert, remove) | **Interactive playground** — user inputs values, watches animated ops | HIGH |
| Code example | **Code block with `.line.active`** synced to step-through | HIGH |
| Comparison (e.g., sorted vs unsorted list) | **Side-by-side Canvas** with toggle or "Run Both" button | HIGH |
| Application (Top-K, merge, scheduling) | **Interactive simulation** — configurable input, animated execution | MEDIUM |
| After a teaching section (every 2-3 slides) | **Inline challenge** (sCA, sCB, sCC) | MEDIUM |
| Concept definition or properties | **Canvas diagram** with interactive hover/click exploration | MEDIUM |
| Summary / cheat sheet | **Canvas table** with color-coded costs + decision flowchart | LOW |
| Pure definition or formula | Keep mostly static with `.key-idea` / `.warning` / `.analogy` callouts | LOW |

### Slide Merging Strategy

When the source deck has 2-4 consecutive slides showing the same operation (e.g., "Insert Step 1", "Insert Step 2", "Insert Step 3"), **merge them into a single interactive slide** with:
- Precomputed steps array from all the static slide states
- Step/Auto/Reset buttons to walk through
- Canvas + code sync showing each state
- Log panel narrating what happens at each step

This typically reduces 20 source slides to ~16-18 content slides, making room for 6 challenge slides within a 24-slide target.

## Phase 2: Propose the Plan

Present a numbered plan:
- Part 1 slides (s1–sN): titles and enhancement types
- Part 2 slides (sN+1–sM): titles and enhancement types
- Part 3 slides (sM+1–end + 6 challenges): titles and types
- Note any merges: "Original slides 7-8-9 → merged into s7 (interactive step-through)"

### Additional info for PPTX/PDF sources:
- Show a **source mapping**: "PPTX slide 3-4 → s2 (merged into step-through)"
- Note **content you'll add** that wasn't in the original: "Adding analogy for heap property", "Adding warning about off-by-one in array indexing"
- Note **content you'll skip** from the original: "Skipping slides 15-16 (administrative/syllabus info)"
- Flag any **ambiguous content** from extraction: "Slide 8 had a diagram I couldn't fully read — I'll create a Canvas version based on the surrounding text"

Ask for approval, then build one part at a time.

## Phase 3: Implement

### File Structure (Part 1 creates this)
```html
<!DOCTYPE html>
<html lang="en">
<head><!-- meta, title, full CSS --></head>
<body>
  <div id="progress-bar"><div id="progress"></div></div>

  <!-- SLIDES (each is <div class="slide" id="sN">) -->
  <!-- Inline <script> blocks after each interactive slide -->

  <!-- ==================== NAVIGATION ==================== -->
  <div class="nav">...</div>

  <!-- ==================== NAVIGATION JS ==================== -->
  <script>
  const slideOrder = ['s1','s2',...];
  // showSlide, navigate, keyboard handler, init
  </script>
</body>
</html>
```

### Slide ID Convention
- Content slides: `s1`, `s2`, ..., `s20`
- Inline challenges (placed between content): `sCA`, `sCB`, `sCC`
- Final quiz section: `sQ1`, `sQ2`, `sQ3`

### slideOrder Array
Challenges are interleaved with content, not grouped at the end:
```js
const slideOrder = ['s1','s2',...,'s8',  // Part 1
  's9','s10','s11',                       // Part 2 content
  's12','s13','sCA','s14','sCB',          // challenges between content
  's15','sCC','s16',                      // Part 3 content
  's17','s18','sQ1','sQ2','sQ3'];         // final quiz
```

### Dark Theme CSS
```
Background:       #0f172a
Panel background:  #1e293b, rgba(0,0,0,0.2) for canvas bg, rgba(0,0,0,0.25) for logs
Borders:          #334155, #475569
Text primary:     #e2e8f0
Text secondary:   #94a3b8, #cbd5e1
Code font:        monospace

Colors:
  Blue:    #38bdf8 (headings), #6366f1 (nodes/primary), #818cf8 (borders)
  Purple:  #a78bfa (accents)
  Amber:   #f59e0b (highlights, active items)
  Green:   #22c55e (success, sorted, correct)
  Red:     #ef4444 (errors, wrong answers)
  Pink:    #f472b6 (secondary accent)
```

### CSS Classes
```css
.btn           — gradient blue-purple button (background: linear-gradient(135deg, #6366f1, #8b5cf6))
.btn-sm        — smaller padding variant
.btn-secondary — gray button (#334155 bg)
.key-idea      — green-bordered callout box
.warning       — red-bordered callout box
.analogy       — purple-bordered callout box
.code-block    — dark code container with .code-content inside
.line          — single code line (inside .code-content)
.line.active   — highlighted code line (rgba(99,102,241,0.15) bg + left border)
.slide-number  — empty div at bottom of each slide (populated by CSS or left empty)
```

### Canvas Visualizations
- **Always use Canvas API** (not SVG) for trees, arrays, bar charts, graphs, and animations
- Canvas dimensions: `width="520" height="370"` (or similar), with `style="width:100%"` for responsiveness
- Canvas background depends on theme (see Canvas Color Rules below)

### Canvas Color Rules (CRITICAL — match colors to theme)

Canvas text and fill colors MUST match the theme's background. Using dark-theme colors on a light canvas (or vice versa) makes text invisible.

**Dark themes (Midnight Dark, Neon Pop):**
- Canvas background: `style="background:rgba(0,0,0,0.2);border-radius:12px;"`
- Box fills: `rgba(0,0,0,0.2-0.4)` or `#1e293b`
- Primary text: `#e2e8f0` (light)
- Secondary text: `#94a3b8`, `#cbd5e1`
- Accent text: `#c7d2fe`, `#a5f3fc`

**Light themes (Aurora Light, Sunset Warm, Ocean Cool):**
- Canvas background: `style="background:white;border-radius:16px;box-shadow:0 4px 16px rgba(0,0,0,0.08);"`
- Box fills: `rgba(79,70,229,0.07-0.12)` (light tint) — **NEVER** `rgba(0,0,0,0.3+)` or solid dark
- Primary text: `#1e293b` (dark slate)
- Secondary text: `#475569` (medium slate) — **NEVER** `#94a3b8` (too faint on white)
- Accent text: `#4f46e5` (indigo) — **NEVER** `#c7d2fe` or `#e2e8f0` (invisible on white)
- Box strokes: `#6366f1` or `#818cf8`

**Validation rule:** Every `ctx.fillText()` must be readable against its background rect. Dark text on dark fill = bug. Light text on light fill = bug. Always verify contrast after writing canvas code.

**Tree drawing pattern:**
```js
for (let i = 0; i < n; i++) {
  const lv = Math.floor(Math.log2(i + 1));
  const posInLv = i - Math.pow(2, lv) + 1;
  const spacing = canvasWidth / Math.pow(2, lv);
  const x = spacing/2 + posInLv * spacing;
  const y = startY + lv * levelGap;
}
```

**Graph drawing pattern (weighted, directed):**
```js
// Node positions — precompute as {id: {x, y}} object
const positions = { A: {x:80, y:60}, B: {x:220, y:60}, ... };

// Draw edges first (so nodes overlap them)
edges.forEach(({from, to, weight}) => {
  const p1 = positions[from], p2 = positions[to];
  ctx.beginPath();
  ctx.moveTo(p1.x, p1.y);
  ctx.lineTo(p2.x, p2.y);
  ctx.strokeStyle = highlighted ? '#f59e0b' : '#475569';
  ctx.lineWidth = highlighted ? 3 : 1.5;
  ctx.stroke();
  // Weight label at midpoint
  const mx = (p1.x + p2.x) / 2, my = (p1.y + p2.y) / 2;
  ctx.fillStyle = '#cbd5e1';
  ctx.fillText(weight, mx, my - 6);
  // Arrowhead for directed graphs
});

// Draw nodes on top
Object.entries(positions).forEach(([id, {x, y}]) => {
  ctx.beginPath();
  ctx.arc(x, y, 20, 0, Math.PI * 2);
  ctx.fillStyle = visited.has(id) ? '#22c55e' : current === id ? '#f59e0b' : '#6366f1';
  ctx.fill();
  ctx.fillStyle = '#fff';
  ctx.font = 'bold 14px monospace';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText(id, x, y);
});
```

**Distance/state table on Canvas:**
```js
// Draw a table below or beside the graph
const cols = nodes.length;
const cellW = 50, cellH = 28, tableX = 20, tableY = canvasHeight - 70;
// Header row
nodes.forEach((n, i) => {
  ctx.fillStyle = '#94a3b8';
  ctx.fillText(n, tableX + i * cellW + cellW/2, tableY);
});
// Value row
dist.forEach((d, i) => {
  ctx.fillStyle = d === Infinity ? '#64748b' : '#e2e8f0';
  ctx.fillText(d === Infinity ? '∞' : d, tableX + i * cellW + cellW/2, tableY + cellH);
});
```

**Comparison toggle (side-by-side or run-both):**
```js
// Two canvases side by side, or one canvas with a toggle button
window.sNToggle = function(mode) {
  currentMode = mode;
  // Re-draw canvas with different algorithm/approach
  draw();
};
// "Run Both" button — runs two animations simultaneously on split canvas
```

- Array bar drawing: colored rectangles with values centered
- Node circles: radius 18-22, filled with theme color, white bold monospace text
- Draw edges BEFORE nodes so nodes overlap edge lines

### JavaScript Patterns

**IIFE encapsulation** — every slide's JS is wrapped in an IIFE to avoid global pollution:
```js
(function(){
  const canvas = document.getElementById('cS5');
  const ctx = canvas.getContext('2d');

  // Only expose button handlers to global scope:
  window.s5Step = function() { ... };
  window.s5Reset = function() { ... };
  window.s5Auto = function() { ... };

  // MutationObserver to reinitialize when slide becomes active:
  const obs = new MutationObserver(() => {
    if (document.getElementById('s5').classList.contains('active')) init();
  });
  obs.observe(document.getElementById('s5'), {attributes: true, attributeFilter: ['class']});
  init();
})();
```

**Naming conventions:**
- Canvas IDs: `cS5`, `cS12`, `cCA` (c + slide ID)
- Button handlers: `s5Step()`, `s5Reset()`, `s5Auto()` (slide ID + action)
- Log divs: `s5Log`, `s5Status`
- Timer variables: `timer` (local to IIFE), always cleared in reset

**Step-through pattern:**
```js
let steps = [...]; // precomputed
let stepIdx = 0;
let timer = null;

window.sNStep = function() {
  if (stepIdx >= steps.length) return;
  // apply step, highlight, update canvas
  stepIdx++;
};
window.sNAuto = function() {
  if (timer) return;
  timer = setInterval(() => {
    if (stepIdx >= steps.length) { clearInterval(timer); timer = null; return; }
    sNStep();
  }, 800);
};
window.sNReset = function() {
  if (timer) clearInterval(timer); timer = null;
  stepIdx = 0;
  init();
};
```

**Interactive playground pattern** (user enters value, animated operation):
```js
window.sNInsert = function() {
  const val = parseInt(document.getElementById('sNinput').value);
  if (isNaN(val)) return;
  // add to data structure
  // animate with requestAnimationFrame or setTimeout chain
};
```

**Interactive input pattern** (user adjusts values, sees result immediately):
```js
// For edge relaxation, comparison inputs, etc.
window.sNCheck = function() {
  const a = parseInt(document.getElementById('sNvalA').value);
  const b = parseInt(document.getElementById('sNvalB').value);
  // compute result, update Canvas, show explanation
};
```

### Heap/Tree-specific helpers (reuse across tree-based decks)
- `upheap(i)` — bubble up, swapping with parent
- `downheap(i)` — sink down, swapping with smaller/larger child
- `buildMinHeap()` / `buildMaxHeap()` — bottom-up heapify
- Draw edges before nodes (so nodes overlap edge lines)
- Highlight array: pass `highlight` array of indices to draw function

### Graph-specific helpers (reuse across graph-based decks)
- Node positions object: `{A: {x, y}, B: {x, y}, ...}` — precomputed layout
- Adjacency list: `{A: [{to:'B', w:3}, ...], ...}`
- BFS/DFS color states: white (unvisited) → amber (in-progress) → green (done)
- Priority queue for Dijkstra: simple array with min-extract
- Edge relaxation highlight: flash edge amber, then update dist table
- Parent chain trace: animate backward from destination to source

### Navigation JS (always at bottom)
```js
const slideOrder = ['s1','s2',...];
let currentIdx = 0;

function showSlide(idx) {
  slideOrder.forEach(id => document.getElementById(id).classList.remove('active'));
  const slideEl = document.getElementById(slideOrder[idx]);
  slideEl.classList.add('active');
  slideEl.classList.remove('fade-in');
  void slideEl.offsetWidth; // force reflow
  slideEl.classList.add('fade-in');
  document.getElementById('prevBtn').disabled = (idx === 0);
  document.getElementById('nextBtn').disabled = (idx === slideOrder.length - 1);
  const pct = slideOrder.length > 1 ? (idx / (slideOrder.length - 1)) * 100 : 0;
  document.getElementById('progress').style.width = pct + '%';
}

function navigate(dir) { /* bounds-checked */ }

// Keyboard: ArrowLeft/Right for nav, DISABLED when INPUT/SELECT/TEXTAREA focused
document.addEventListener('keydown', (e) => {
  const tag = document.activeElement.tagName;
  if (tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA') return;
  if (e.key === 'ArrowRight') navigate(1);
  if (e.key === 'ArrowLeft') navigate(-1);
});

showSlide(0);
```

### Challenge Slide Patterns

**sCA — Trace/Predict** (inline after a concept section):
- Show a sequence of operations, ask user to predict the final state
- Text input for prediction (e.g., "Type the visit order: A, B, C, ...")
- "Step Through" button to verify + Canvas animation
- Color-coded feedback: green if correct, red if wrong, with explanation

**sCB — Fix the Bug** (inline after a code-heavy section):
- Show code with one highlighted buggy line
- Multiple-choice `<select>` to identify the bug
- Canvas diagram showing WHY the bug causes incorrect behavior
- Reveal detailed explanation on correct answer

**sCC — Decision/Scenario** (inline after comparison section):
- 3-4 real-world scenarios, user picks the right approach
- Can include trick questions to test deeper understanding
- Check All button + color-coded border feedback on each select
- Detailed explanation panel revealed after checking

**sQ1 — Multi-Question Quiz** (final section):
- 3 radio-button questions in a 3-column grid
- Check Answers button, score display with per-question feedback
- Questions cover: complexity, index/formula, practical application

**sQ2 — Trace Exercise** (final section):
- Given a data structure state, predict result of an operation
- Step-by-step trace reveal via button
- Canvas shows each intermediate state

**sQ3 — Predict Output** (final section):
- Show Java/pseudocode, user enters predicted output values
- Text input fields for answers
- "Show Trace" button steps through execution visually on Canvas

### Layout Patterns
```html
<!-- Two-column: visualization + controls -->
<div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;margin-top:1rem;">
  <div><!-- Canvas or code --></div>
  <div><!-- Controls, log, explanation --></div>
</div>

<!-- Three-column: quiz questions -->
<div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem;margin-top:1rem;">

<!-- Log/output area -->
<div style="background:rgba(0,0,0,0.25);border-radius:8px;padding:0.6rem;
     font-family:monospace;font-size:0.78rem;max-height:120px;overflow-y:auto;">

<!-- Control button row -->
<div style="display:flex;gap:0.5rem;flex-wrap:wrap;">
  <button class="btn btn-sm" onclick="sNStep()">Step</button>
  <button class="btn btn-sm" onclick="sNAuto()">Auto Play</button>
  <button class="btn btn-sm btn-secondary" onclick="sNReset()">Reset</button>
</div>

<!-- Input with label -->
<input type="text" id="sNinput" value="default"
  style="padding:0.4rem 0.6rem;background:#1e293b;border:1px solid #475569;
         border-radius:6px;color:#e2e8f0;font-family:monospace;">
```

## Phase 4: Insertion Edit Pattern

When adding Part 2 or Part 3 to an existing file:

1. **Grep** for `<!-- ==================== NAVIGATION ====================` to find the line number
2. **Grep** for `const slideOrder` to confirm the slideOrder line
3. **Edit**: replace from the NAVIGATION comment through the slideOrder line with:
   - All new slide `<div>` blocks + their `<script>` blocks
   - The navigation HTML (unchanged)
   - The navigation JS with the UPDATED slideOrder array
4. Everything after slideOrder (showSlide function, navigate, keyboard handler) remains untouched

---

## Mode 2: Standalone Exercise App

When Q asks to create a **practice exercise** (not a slide deck), use a different architecture:

### Exercise Architecture
```
Fixed header: progress bar + timer + live score
Scrollable body: sections of questions
Summary panel: appears when all questions answered
```

### Key Differences from Slide Decks
| Aspect | Slide Deck | Exercise App |
|--------|-----------|--------------|
| Navigation | Arrow keys, prev/next buttons | Scroll (all visible) |
| Layout | One slide visible at a time | All questions visible, sectioned |
| State | Per-slide IIFE | Centralized scoring (Set-based) |
| Feedback | Step-through reveals | Instant per-question check |
| Canvas | Heavy (every interactive slide) | Light or none (CSS feedback) |
| Timer | None | Countdown with color warning |

### Question Types Available
1. **Multiple choice** — radio buttons, `.opt.selected` class, color-coded feedback
2. **Text input** — `.input-answer` field, exact match or flexible validation
3. **Matching** — grid of `<select>` dropdowns, check-all button
4. **Ordering** — click-to-place items into slots, reset button, position validation
5. **Multi-select** — checkboxes, partial credit possible

### Exercise Patterns
```js
// Centralized state
const totalQs = 18;
let answered = new Set();
let correct = new Set();

function markQuestion(qid, isCorrect) {
  answered.add(qid);
  if (isCorrect) correct.add(qid);
  updateProgress();
}

// Prevent re-answering
function checkMC(qid) {
  if (answered.has(qid)) return;
  // ... validate, show feedback, markQuestion
}

// Countdown timer (color turns red at 5 min)
let timeLeft = duration * 60;
const timerInterval = setInterval(() => {
  if (timeLeft <= 0) { clearInterval(timerInterval); return; }
  timeLeft--;
  if (timeLeft <= 300) timerEl.style.color = '#ef4444';
}, 1000);

// Summary with screenshot instructions
function showSummary() {
  // Section-by-section breakdown
  // Name display for identification
  // Screenshot instructions for eCampus submission
}
```

### Exercise CSS Classes
```css
.question          — card with left border, margin-bottom
.question.correct  — green border
.question.incorrect — red border
.question.answered — slightly dimmed
.q-num             — colored badge (different color per section)
.hint / .hint.show — toggleable hint box
.feedback.correct  — green text
.feedback.incorrect — red text
.order-item        — clickable draggable item
.order-slot        — drop target with dashed border
.order-slot.filled — solid border, filled state
```

### Student Submission
- Name input field at the top (required)
- Summary box with bordered screenshot area
- Instructions: "Screenshot this box and submit on eCampus"
- Include keyboard shortcuts (Cmd+Shift+4 / Win+Shift+S)

---

## Important Rules

- **No external dependencies.** Everything is self-contained HTML/CSS/JS.
- **Match the dark theme** consistently across all decks.
- **Don't over-enhance.** Pure definitions are fine as formatted static content with `.key-idea` / `.warning` / `.analogy` callouts. Only add interactivity where it genuinely helps understanding.
- **Canvas over SVG.** Use Canvas API for all visualizations (trees, arrays, graphs, charts). More consistent and performant for animations.
- **IIFE everything.** Never leak variables into global scope except `window.sNAction` button handlers.
- **MutationObserver on every interactive slide** to reinitialize when the slide becomes active (handles forward/backward navigation).
- **Precompute steps** — never compute algorithm steps on-the-fly during animation.
- **Timer cleanup** — always clear intervals in reset functions.
- **Arrow keys disabled** when INPUT/SELECT/TEXTAREA is focused (prevents navigation while typing).
- **Merge multi-step static slides** — if 2+ source slides show the same operation step by step, combine into one interactive step-through slide.
- **Explain the "why"** — always explain reasoning behind design choices.
- **Plan before building** — never start coding without user approval on the plan.
- **One part at a time** — build Part 1, get approval, then Part 2, etc. Never skip ahead.
- **PPTX/PDF: add depth** — raw slides are often sparse. Add explanations, analogies, warnings, and "why" context that the original slides lack. Don't just convert — *enhance*.

## Quality Checklist (before delivering each part)

- [ ] Every interactive slide has a MutationObserver
- [ ] Every timer is cleared in its reset function
- [ ] Every IIFE only exposes `window.sNAction` handlers
- [ ] Canvas redraws correctly when navigating back to a slide
- [ ] Code `.line.active` highlighting syncs with step index
- [ ] Log panel auto-scrolls to latest entry
- [ ] All buttons have consistent `.btn` / `.btn-sm` / `.btn-secondary` styling
- [ ] slideOrder array includes ALL slides (content + challenges)
- [ ] Arrow keys don't interfere with text inputs

### Additional checks for PPTX/PDF sources:
- [ ] All key content from the original slides is preserved (nothing accidentally dropped)
- [ ] Added depth beyond the original: analogies, warnings, "why" explanations
- [ ] Diagrams from original are faithfully recreated as Canvas visualizations
- [ ] Code snippets from original are correctly formatted in `.code-block` containers
- [ ] Topic flow makes sense (reordering from original is OK if it improves learning)

## Completed Decks Reference

All 15 enhanced decks are in the working directory:
- `linked-list-enhanced.html` (27 slides)
- `algorithm-analysis-enhanced.html` (24 slides)
- `recursion-enhanced.html` (24 slides)
- `stacks-enhanced.html` (23 slides)
- `queues-enhanced.html` (23 slides)
- `arraylists-enhanced.html` (23 slides)
- `priority-queues-enhanced.html` (24 slides)
- `heap-enhanced.html` (26 slides)
- `maps-enhanced.html`
- `hashtables-enhanced.html`
- `trees-enhanced.html`
- `graph-enhanced.html`
- `bfs-enhanced.html`
- `dfs-enhanced.html`
- `shortest-path-enhanced.html` (24 slides)

Exercise apps:
- `exercise-lists-arrays-complexity.html` (18 questions, 50 min)

Use any of these as reference when building new decks.
