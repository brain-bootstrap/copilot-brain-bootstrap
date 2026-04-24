# Bootstrap Upgrade Guide — ᗺB Brain Bootstrap (Copilot Edition)

> **Read this ONLY when `MODE=UPGRADE`.** Follow steps A through D, then return to `context/bootstrap/PROMPT.md` → Phase 3.
> Powered by [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap

---

> **SACRED RULE: NEVER LOSE USER DATA.** Domain knowledge, lessons, task state are irreplaceable.

---

## Step A: Inventory Existing Content

Read all existing context files in parallel to understand what's already there:

- `context/architecture.md`
- `context/build.md`
- `context/rules.md`
- `context/plugins.md`
- `context/tasks/lessons.md`
- `context/tasks/todo.md`
- `.github/copilot-instructions.md`

Also find any custom domain docs:

```bash
find context/ -name '*.md' -not -path 'context/tasks/*' -not -path 'context/_examples/*' -not -path 'context/bootstrap/*' -not -path 'context/docs/*' 2>/dev/null | sort
```

Build a mental map of:

1. Which placeholders are already filled vs still templated
2. Which domain docs exist (user-written content to preserve)
3. What's in `lessons.md` (don't repeat known mistakes)

---

## Step B: Identify What to Preserve vs Enhance

**Preserve (never overwrite):**

- Any file with real content (no `{{PLACEHOLDER}}` tokens, real project-specific data)
- `context/tasks/lessons.md` — append only, never overwrite
- `context/tasks/todo.md` — append only
- Custom domain docs (`context/messaging.md`, `context/auth.md`, etc.)

**Enhance (additive only):**

- Files with remaining `{{PLACEHOLDER}}` tokens — fill the gaps
- `context/rules.md` — add newly discovered rules, keep existing ones
- `context/plugins.md` — update status for newly detected plugins
- `.github/copilot-instructions.md` `{{CRITICAL_PATTERNS}}` — enrich with new patterns

**Count remaining placeholders:**

```bash
grep -r '{{' context/ .github/copilot-instructions.md 2>/dev/null | grep -v 'tasks/\|_examples/\|bootstrap/' | grep -v '.git' | head -30
```

---

## Step C: Fill Remaining Gaps

For each file that still has `{{PLACEHOLDER}}` tokens, fill them with real values discovered from the codebase. Follow the same rules as Phase 3 in `PROMPT.md`.

For domain docs that exist but are sparse (fewer than 5 real patterns), enrich them by reading 2–3 actual source files in that domain.

---

## Step D: Verify No Data Was Lost

After all changes, confirm:

```bash
# No user-written content was removed (lessons, todos, domain docs)
wc -l context/tasks/lessons.md context/tasks/todo.md 2>/dev/null

# Validate structure
bash validate.sh 2>&1
```

**Phase 2 is complete when validate.sh passes.**

Return to `context/bootstrap/PROMPT.md` → Phase 3.
