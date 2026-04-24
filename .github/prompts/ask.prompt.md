---
description: 'Ask a question about the codebase, a concept, or a decision. Get a direct, evidence-based answer.'
agent: agent
tools:
  - read_file
  - grep_search
  - file_search
  - run_in_terminal
argument-hint: '[question]'
---

Answer the question with evidence from the codebase. Rules:

1. Search before claiming — verify patterns exist with grep_search
2. Cite exact file paths and line numbers
3. If uncertain, say so — use confidence markers:
   - "Verified: [evidence]"
   - "Likely: [reason] (unverified)"
   - "Unknown: would need to search X"
4. Keep answers concise — 3-5 sentences for simple questions
5. For complex answers, use structured output with headers
