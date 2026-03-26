---
name: slide-generator
description: Generate interactive HTML teaching slide decks from existing presentations (PPTX, PDF, or topic descriptions). Use when the user wants to create HTML slides, convert slides, make teaching slides, generate a slide deck, convert PPTX to HTML, create interactive slides, or says "make slides", "teaching mode slides", "convert to HTML slides". Also trigger for batch slide generation across multiple topics.
---

# HTML Teaching Slide Generator

Convert existing lecture slides (PPTX/PDF) or topic descriptions into self-contained, interactive HTML slide decks optimized for teaching.

## Philosophy

Each slide deck is a **single HTML file** — no dependencies, no build step, no framework. Open in any browser and teach. The slides use a dark theme with ASCII diagrams, callout boxes, and keyboard navigation to create an engaging learning experience.

## When to Use

- User has PPTX/PDF slides they want converted to interactive HTML
- User wants to create teaching slides for a topic from scratch
- User wants to batch-generate slides for an entire course
- User mentions "teaching mode", "HTML slides", "interactive slides", or "convert slides"

---

## Workflow Overview

```
Phase 1: Source Analysis     →  Read existing slides / understand the topic
Phase 2: Content Planning    →  Decide slide count, structure, ASCII diagrams
Phase 3: HTML Generation     →  Generate the self-contained HTML file
Phase 4: Verification        →  Confirm slide count, check for issues
Phase 5: Optional Extras     →  Feedback form, deployment, batch generation
```

---

## Phase 1: Source Analysis

### If converting from PPTX/PDF:
1. Read the source file using the Read tool (for PDFs, use `pages` parameter to read in chunks of ~10 pages)
2. Extract key concepts, definitions, examples, and diagrams
3. Note the logical flow and ordering of topics
4. Identify what needs ASCII diagram treatment

### If creating from a topic description:
1. Ask the user for the topic and course level
2. Plan coverage based on standard CS curriculum for that topic
3. Identify prerequisite knowledge and target audience

### Ask the User:
- "How many slides do you want?" (default: 18-22)
- "Any specific examples or problems to include?"
- "Should I add a feedback form at the end?" (optional)

---

## Phase 2: Content Planning

Plan the slide structure before generating:

1. **Title slide** — topic name, subtitle, navigation instructions
2. **Motivation / Big Picture** — why this topic matters, where it fits
3. **Core concept slides** (bulk of the deck) — definitions, ASCII diagrams, examples
4. **Step-by-step traces** — walk through algorithms/processes with ASCII art
5. **Comparison slides** — tables, side-by-side layouts
6. **Applications** — real-world uses
7. **Summary / Cheat Sheet** — key formulas, complexity table, common pitfalls

### Content Guidelines:
- **Explain the "why"** behind every concept, not just the "what"
- **ASCII diagrams everywhere** — every data structure, algorithm trace, state machine, proof sketch
- **Use analogies** — connect abstract concepts to everyday objects (restaurant, library, etc.)
- **Two-column layouts** — pair explanations with diagrams
- **Progressive complexity** — build from simple to complex
- **Consistent examples** — reuse the same graph/tree/structure across related slides so students can compare

---

## Phase 3: HTML Generation

Generate a single self-contained HTML file using the template from `references/template.md`.

### File Naming Convention:
```
<topic-lowercase>-explained.html
```
Examples: `nfa-explained.html`, `linked-list-explained.html`, `shortest-path-explained.html`

### Generation Rules:

1. **Read the template** from `references/template.md` before generating
2. **Use the exact CSS** from the template — do not modify colors, fonts, or layout classes
3. **Use the exact JavaScript** from the template — update only `totalSlides` constant
4. **Every slide** must have a `<div class="slide-number">N</div>` tag
5. **Slide 1** gets the `active` class: `<div class="slide active" id="s1">`
6. **ASCII diagrams** go in `<div class="diagram">` blocks with `&lt;` and `&gt;` for angle brackets
7. **Use HTML entities** for special characters in diagram blocks (`&lt;`, `&gt;`, `&amp;`)
8. **Target 18-22 slides** per deck (can go higher for complex topics)
9. **Target 800-1500 lines** per file

### Required Elements Per Deck:
- At least 5 ASCII diagrams
- At least 2 key-idea boxes (blue)
- At least 1 warning box (amber)
- At least 1 analogy box (green)
- At least 2 two-column layouts
- At least 1 table
- A summary/cheat sheet as the final slide

### Callout Box Usage:
- **key-idea** (blue): Core concepts, important definitions, "aha moment" insights
- **warning** (amber): Common mistakes, pitfalls, edge cases, exam traps
- **analogy** (green): Real-world comparisons that make abstract concepts click

---

## Phase 4: Verification

After generating, verify:
1. Total slide count matches `totalSlides` in the JavaScript
2. All slides have sequential IDs (`s1`, `s2`, ..., `sN`)
3. All slides have `<div class="slide-number">N</div>`
4. ASCII diagrams render correctly (no broken HTML entities)
5. File is self-contained (no external dependencies)
6. File size is reasonable (30-60KB typical)

---

## Phase 5: Optional Extras

### Feedback Form
If the user wants a feedback form, add it as the last slide. Read `references/feedback-form.md` for the template.

Requires:
- A Google Sheet with Apps Script web app (provide setup instructions)
- The Apps Script URL set in the `GOOGLE_SHEET_URL` constant
- Form fields: rating (1-5), ASCII diagrams helpfulness, knew AI-assisted?, vs traditional comparison (1-5), best slide, comments

### Batch Generation
For generating slides for an entire course:
1. List all topics and confirm with the user
2. Use the Task tool with background agents (subagent_type: "general-purpose") to generate slides in parallel
3. Generate in batches of 3-5 agents at a time to avoid overwhelming the system
4. Each agent gets: the template reference, the source content/topic, and generation instructions
5. Monitor completion and report progress

### Deployment
- **Local use**: Just open the HTML file in a browser
- **GitHub Pages**: Create a repo, push HTML files, enable Pages
- **Course LMS**: Upload HTML files directly (they're self-contained)

---

## Error Handling

Common issues:
- **PDF too large to read at once**: Use the `pages` parameter to read 10 pages at a time
- **PPTX content extraction**: Read the file, extract text content from each slide
- **ASCII diagrams breaking**: Ensure all `<` and `>` in diagram blocks use `&lt;` and `&gt;`
- **Slide count mismatch**: Always verify `totalSlides` matches actual slide count after generation
