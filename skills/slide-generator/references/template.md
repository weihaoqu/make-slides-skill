# HTML Slide Deck Template

This is the exact HTML/CSS/JS template to use for every slide deck. Copy this structure and fill in the slides.

## Complete Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TOPIC_TITLE - A Student-Friendly Guide</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; background: #0f172a; color: #e2e8f0; }

  /* Slide system */
  .slide { display: none; min-height: 100vh; padding: 40px 60px; position: relative; }
  .slide.active { display: flex; flex-direction: column; justify-content: center; }
  .slide-number { position: absolute; bottom: 20px; right: 40px; color: #64748b; font-size: 14px; }

  /* Navigation */
  .nav { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); display: flex; gap: 12px; z-index: 100; }
  .nav button { background: #334155; border: 1px solid #475569; color: #e2e8f0; padding: 8px 20px; border-radius: 8px; cursor: pointer; font-size: 14px; transition: all 0.2s; }
  .nav button:hover { background: #475569; }
  .nav button:disabled { opacity: 0.3; cursor: not-allowed; }
  .progress { position: fixed; top: 0; left: 0; height: 3px; background: linear-gradient(90deg, #3b82f6, #8b5cf6); transition: width 0.3s; z-index: 100; }

  /* Typography */
  h1 { font-size: 2.8em; margin-bottom: 20px; background: linear-gradient(135deg, #3b82f6, #8b5cf6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; line-height: 1.2; }
  h2 { font-size: 2em; margin-bottom: 16px; color: #93c5fd; }
  h3 { font-size: 1.4em; margin-bottom: 12px; color: #a5b4fc; }
  p, li { font-size: 1.15em; line-height: 1.7; color: #cbd5e1; margin-bottom: 10px; }
  .subtitle { font-size: 1.3em; color: #94a3b8; margin-bottom: 30px; }

  /* Layout helpers */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; align-items: start; }
  .center { text-align: center; }
  .mt { margin-top: 20px; }
  .mb { margin-bottom: 20px; }

  /* Code / diagram blocks */
  .diagram { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 24px; font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace; font-size: 1em; line-height: 1.6; white-space: pre; overflow-x: auto; margin: 16px 0; color: #a5f3fc; }
  .diagram.small { font-size: 0.85em; }

  /* Highlight boxes */
  .key-idea { background: linear-gradient(135deg, rgba(59,130,246,0.15), rgba(139,92,246,0.15)); border-left: 4px solid #3b82f6; border-radius: 0 12px 12px 0; padding: 20px 24px; margin: 16px 0; }
  .key-idea h3 { margin-bottom: 8px; }
  .warning { background: rgba(245,158,11,0.12); border-left: 4px solid #f59e0b; border-radius: 0 12px 12px 0; padding: 20px 24px; margin: 16px 0; }
  .warning h3 { color: #fbbf24; }
  .analogy { background: rgba(16,185,129,0.12); border-left: 4px solid #10b981; border-radius: 0 12px 12px 0; padding: 20px 24px; margin: 16px 0; }
  .analogy h3 { color: #34d399; }

  /* Table */
  table { border-collapse: collapse; margin: 16px 0; width: auto; }
  th, td { border: 1px solid #475569; padding: 10px 16px; text-align: center; }
  th { background: #334155; color: #93c5fd; font-weight: 600; }
  td { background: #1e293b; color: #e2e8f0; }
  tr.highlight td { background: rgba(59,130,246,0.2); }

  /* Animations */
  .fade-in { animation: fadeIn 0.5s ease-in; }
  @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

  /* Step-by-step reveal */
  .step { opacity: 0.25; transition: opacity 0.4s; margin: 8px 0; padding: 8px 12px; border-radius: 8px; }
  .step.revealed { opacity: 1; background: rgba(59,130,246,0.08); }

  .emoji { font-size: 1.5em; margin-right: 8px; }

  ul { padding-left: 24px; }
  ul li { margin-bottom: 8px; }
</style>
</head>
<body>

<div class="progress" id="progress"></div>

<!-- ==================== SLIDE 1: TITLE ==================== -->
<div class="slide active" id="s1">
  <div class="center">
    <h1>TOPIC_TITLE</h1>
    <p class="subtitle">SUBTITLE_HERE</p>
    <div style="margin-top: 40px; color: #64748b;">
      <p>Use <b>Arrow Keys</b> or the buttons below to navigate. Press <b>S</b> to step through animations.</p>
    </div>
  </div>
  <div class="slide-number">1</div>
</div>

<!-- ==================== SLIDE 2: CONTENT ==================== -->
<div class="slide" id="s2">
  <h1>Slide Title Here</h1>
  <p class="subtitle">Optional subtitle</p>
  <div class="two-col">
    <div>
      <!-- Left column: text content -->
      <p>Explanation text here.</p>
      <ul>
        <li>Point one</li>
        <li>Point two</li>
      </ul>
    </div>
    <div>
      <!-- Right column: diagram -->
      <div class="diagram">
ASCII diagram here
Use &lt; and &gt; for angle brackets
      </div>
    </div>
  </div>
  <div class="key-idea">
    <h3>Key Idea</h3>
    <p>Important concept explanation.</p>
  </div>
  <div class="slide-number">2</div>
</div>

<!-- Add more slides following the same pattern... -->
<!-- Each slide: <div class="slide" id="sN"> ... <div class="slide-number">N</div> </div> -->

<!-- ==================== LAST SLIDE: SUMMARY ==================== -->
<div class="slide" id="sN">
  <h1>Summary &amp; Cheat Sheet</h1>
  <!-- Key formulas, comparison tables, common pitfalls -->
  <div class="slide-number">N</div>
</div>

<!-- Navigation -->
<div class="nav">
  <button id="prevBtn" onclick="changeSlide(-1)">&larr; Prev</button>
  <button id="nextBtn" onclick="changeSlide(1)">Next &rarr;</button>
</div>

<script>
const totalSlides = N; // <-- UPDATE THIS to match actual slide count
let current = 1;

function showSlide(n) {
  document.querySelectorAll('.slide').forEach(s => s.classList.remove('active'));
  const slide = document.getElementById('s' + n);
  if (slide) {
    slide.classList.add('active');
    slide.classList.add('fade-in');
  }
  document.getElementById('prevBtn').disabled = (n === 1);
  document.getElementById('nextBtn').disabled = (n === totalSlides);
  document.getElementById('progress').style.width = ((n / totalSlides) * 100) + '%';
}

function changeSlide(delta) {
  const next = current + delta;
  if (next >= 1 && next <= totalSlides) {
    current = next;
    showSlide(current);
  }
}

// Keyboard navigation
document.addEventListener('keydown', (e) => {
  if (e.key === 'ArrowRight' || e.key === 'ArrowDown' || e.key === ' ') {
    e.preventDefault();
    changeSlide(1);
  } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
    e.preventDefault();
    changeSlide(-1);
  } else if (e.key === 's' || e.key === 'S') {
    // Reveal next step on current slide
    const slide = document.getElementById('s' + current);
    const steps = slide.querySelectorAll('.step:not(.revealed)');
    if (steps.length > 0) steps[0].classList.add('revealed');
  }
});

showSlide(1);
</script>
</body>
</html>
```

---

## Component Reference

### ASCII Diagram Block
```html
<div class="diagram">
  +---------+        +---------+
  |  Node A | -----&gt; |  Node B |
  +---------+        +---------+
</div>
```
For smaller diagrams: `<div class="diagram small">`

### Key Idea Box (Blue)
```html
<div class="key-idea">
  <h3>Key Idea</h3>
  <p>Core concept or important insight.</p>
</div>
```

### Warning Box (Amber)
```html
<div class="warning">
  <h3>Common Mistake</h3>
  <p>What students often get wrong.</p>
</div>
```

### Analogy Box (Green)
```html
<div class="analogy">
  <h3>Real-World Analogy</h3>
  <p>Think of it like a restaurant queue...</p>
</div>
```

### Two-Column Layout
```html
<div class="two-col">
  <div>
    <!-- Left: explanation -->
  </div>
  <div>
    <!-- Right: diagram or code -->
  </div>
</div>
```

### Table
```html
<table>
  <tr><th>Operation</th><th>Array</th><th>Linked List</th></tr>
  <tr><td>Access</td><td>O(1)</td><td>O(n)</td></tr>
  <tr class="highlight"><td>Insert</td><td>O(n)</td><td>O(1)</td></tr>
</table>
```

### Step-by-Step Reveal (Press S key)
```html
<div class="step">Step 1: Initialize the queue</div>
<div class="step">Step 2: Enqueue the start node</div>
<div class="step">Step 3: While queue is not empty...</div>
```

### Slide Structure Patterns

**Title Slide:**
```html
<div class="slide active" id="s1">
  <div class="center">
    <h1>Topic Name</h1>
    <p class="subtitle">Description</p>
    <div class="diagram">
      <!-- Optional hero ASCII art -->
    </div>
  </div>
  <div class="slide-number">1</div>
</div>
```

**Concept Slide (two-column):**
```html
<div class="slide" id="sN">
  <h1>Concept Name</h1>
  <p class="subtitle">Brief description</p>
  <div class="two-col">
    <div>
      <p>Explanation...</p>
      <ul><li>Point</li></ul>
    </div>
    <div>
      <div class="diagram">ASCII art</div>
    </div>
  </div>
  <div class="key-idea">
    <h3>Takeaway</h3>
    <p>The key insight.</p>
  </div>
  <div class="slide-number">N</div>
</div>
```

**Algorithm Trace Slide:**
```html
<div class="slide" id="sN">
  <h1>Algorithm Name — Step by Step</h1>
  <div class="two-col">
    <div>
      <div class="diagram">
        <!-- ASCII showing the data structure state -->
      </div>
    </div>
    <div>
      <div class="step">Step 1: ...</div>
      <div class="step">Step 2: ...</div>
      <div class="step">Step 3: ...</div>
      <table>
        <tr><th>Variable</th><th>Value</th></tr>
        <tr><td>current</td><td>A</td></tr>
      </table>
    </div>
  </div>
  <div class="slide-number">N</div>
</div>
```

**Summary / Cheat Sheet Slide:**
```html
<div class="slide" id="sN">
  <h1>Summary &amp; Cheat Sheet</h1>
  <div class="two-col">
    <div>
      <h3>Key Concepts</h3>
      <ul>
        <li><b>Term:</b> Definition</li>
      </ul>
      <h3>Complexity</h3>
      <table>
        <tr><th>Operation</th><th>Time</th><th>Space</th></tr>
        <tr><td>Search</td><td>O(log n)</td><td>O(1)</td></tr>
      </table>
    </div>
    <div>
      <div class="key-idea">
        <h3>Remember</h3>
        <p>The most important takeaway.</p>
      </div>
      <div class="warning">
        <h3>Common Pitfalls</h3>
        <ul>
          <li>Mistake students make</li>
        </ul>
      </div>
    </div>
  </div>
  <div class="slide-number">N</div>
</div>
```

---

## Quality Checklist

Before delivering a slide deck, verify:

- [ ] `totalSlides` constant matches actual slide count
- [ ] All slide IDs are sequential: `s1`, `s2`, ..., `sN`
- [ ] All `<div class="slide-number">` tags have correct numbers
- [ ] First slide has `class="slide active"`, all others have `class="slide"`
- [ ] All `<` and `>` in diagram blocks use `&lt;` and `&gt;`
- [ ] At least 5 ASCII diagrams present
- [ ] At least 2 key-idea boxes, 1 warning box, 1 analogy box
- [ ] At least 2 two-column layouts
- [ ] At least 1 comparison table
- [ ] Last slide is a summary/cheat sheet
- [ ] No external dependencies (fonts, CSS, JS — all inline)
- [ ] File size is 30-60KB (800-1500 lines)
