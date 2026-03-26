# Batch Slide Generation Guide

When generating slides for an entire course (multiple topics), use parallel background agents for efficiency.

## Workflow

### Step 1: Inventory Source Files
List all source PPTX/PDF files or topics. Confirm the list with the user before proceeding.

### Step 2: Read Source Content
For each topic, read the source slides to extract content. For large PDFs, use the `pages` parameter to read in chunks of ~10 pages.

### Step 3: Launch Background Agents

Use the Task tool with `subagent_type: "general-purpose"` and `run_in_background: true`.

**Batch size:** 3-5 agents at a time (avoids overwhelming the system).

**Agent prompt template:**
```
You are generating an interactive HTML teaching slide deck.

TOPIC: [Topic Name]
OUTPUT FILE: [/path/to/topic-explained.html]

SOURCE CONTENT:
[Paste extracted content from the source slides here]

INSTRUCTIONS:
1. Read the template from /Users/oreo/.claude/skills/slide-generator/references/template.md
2. Generate a self-contained HTML file with 18-22 slides following the template exactly
3. Include ASCII diagrams for every key concept (at least 5 diagrams)
4. Use key-idea boxes (blue), warning boxes (amber), and analogy boxes (green)
5. Use two-column layouts for concept + diagram slides
6. Add step-by-step algorithm traces where appropriate
7. End with a Summary & Cheat Sheet slide
8. Make sure totalSlides constant matches the actual slide count
9. Explain the "why" behind concepts, not just the "what"
10. Use real-world analogies to make abstract concepts concrete
11. Write the file using the Write tool

The slides should teach the topic to undergraduates who are seeing it for the first time.
Add more explanation and detail than the source slides — expand on concepts,
add examples, and include common exam pitfalls in warning boxes.
```

### Step 4: Monitor Progress

Check on agents periodically using TaskOutput with `block: false`:
```
TaskOutput(task_id: "agent_id", block: false)
```

Report progress to the user as agents complete:
```
Completed: 8/15 topics
In progress: graph, bfs, dfs
Remaining: shortest-path, trees
```

### Step 5: Verify All Files

After all agents complete, verify each file:
- File exists and is non-empty
- Slide count matches totalSlides
- Line count is in expected range (800-1500)

## Example: CS205 Data Structures Batch

Topics generated in 5 batches of 3:

| Batch | Topics | Status |
|-------|--------|--------|
| 1 | Linked Lists, Algorithm Analysis, Recursion | Done |
| 2 | Stacks, Queues, ArrayLists | Done |
| 3 | Priority Queues, Heaps, Maps | Done |
| 4 | HashTables, Trees, Graphs | Done |
| 5 | BFS, DFS, Shortest Path | Done |

Each agent took 3-5 minutes to generate a complete slide deck.

## Tips

- **Include source content in the agent prompt** — agents can't read PPTX files directly, so extract the text first
- **Use consistent naming** — `topic-explained.html` in lowercase with hyphens
- **Same output directory** — keep all slides for a course in one folder
- **Verify totalSlides** — the most common issue is a mismatch between the JS constant and actual slide count
