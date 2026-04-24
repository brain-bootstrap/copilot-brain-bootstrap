---
description: 'Research a question about the codebase. Delegates exploration to the researcher agent, preserving main context. Returns structured findings: summary, evidence, data flow, pitfalls, related files.'
agent: agent
tools:
  - read_file
  - grep_search
  - file_search
  - list_dir
  - run_in_terminal
argument-hint: '[question about the codebase]'
---

You are performing structured codebase research.

## Research Protocol

1. Restate the question in your own words
2. Identify which parts of the codebase are relevant
3. Search before claiming — use grep_search with evidence thresholds:
   - >10 hits = established pattern
   - 3-10 = emerging
   - <3 = not established
4. Trace data flows from entry point to implementation
5. Note pre-existing patterns the user should follow

## Output Format

```
## Research Findings: [question]

### Summary
[2-3 sentence answer]

### Evidence
- [file:line] <code snippet>
- [file:line] <code snippet>

### Data Flow
<entry point> → <file> → <file> → <output>

### Patterns to Follow
- <established pattern: N occurrences>

### Pitfalls
- <gotcha or non-obvious fact>

### Files to Read/Modify
- `path/to/file.ts` — [why]
```
