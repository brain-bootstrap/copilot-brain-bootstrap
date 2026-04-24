# Bootstrap Upgrade Guide — ᗺB Brain Bootstrap (Copilot Edition)

> **Read this ONLY when `MODE=UPGRADE`.** Follow steps A through D, then return to `context/bootstrap/PROMPT.md` → Phase 3.
> Powered by [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap

---

> **SACRED RULE: NEVER LOSE USER DATA.** Domain knowledge, lessons, task state are irreplaceable.

---

## Step 0: Pre-Upgrade Safety Backup

`install.sh` creates a backup automatically before touching anything. Verify it exists:

```bash
ls -lh context/tasks/.pre-upgrade-backup.tar.gz 2>/dev/null && echo "✅ Backup exists" || echo "⚠️  No backup found"
```

If no backup exists (you copied files manually without `install.sh`), create one now:

```bash
tar czf context/tasks/.pre-upgrade-backup.tar.gz .github/copilot-instructions.md context/ 2>/dev/null || true
echo "✅ Pre-upgrade backup saved"
```

Restore at any time:

```bash
tar xzf context/tasks/.pre-upgrade-backup.tar.gz
```

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
# Capture line counts BEFORE making any edits (run this at the start of Phase 2)
# then re-run here to verify counts are >= pre-upgrade counts
wc -l context/tasks/lessons.md context/tasks/todo.md 2>/dev/null
```

**Required checks:**

- [ ] `context/tasks/lessons.md` line count is **≥ pre-upgrade count** (data never removed)
- [ ] `context/tasks/todo.md` line count is **≥ pre-upgrade count**
- [ ] All custom domain docs (`context/*.md` you created) still exist and are unchanged
- [ ] `.github/instructions/` files were NOT modified (they are user-customized — never touch)
- [ ] `.github/copilot-instructions.md` has all your original content plus any newly merged sections

```bash
# Validate structure
bash validate.sh 2>&1
```

**Phase 2 is complete when validate.sh passes and all checkboxes are checked.**

Return to `context/bootstrap/PROMPT.md` → Phase 3.
