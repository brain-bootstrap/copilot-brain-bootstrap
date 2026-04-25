---
name: health
description: Verify Copilot configuration health — copilot-instructions.md, hooks, skills, errors log, secrets scan, and MCP reachability. Reports ✅/⚠️/❌ for each check.
---

# Health Skill — Copilot Brain Configuration Validation

Verify that the Copilot Brain configuration is healthy and complete.

## Steps

### 1. copilot-instructions.md
- Exists and is not empty
- Line count: `wc -l < .github/copilot-instructions.md`
- Size: `wc -c < .github/copilot-instructions.md` (budget: ≤32KB = 32768 bytes)
- Contains key sections: Skills Roster, Exit Checklist, Terminal Rules

### 2. Hook Scripts
- `.github/hooks/scripts/` directory exists and contains scripts:
  ```bash
  ls .github/hooks/scripts/*.sh 2>/dev/null | wc -l
  ```
- All hook scripts are executable:
  ```bash
  for h in .github/hooks/scripts/*.sh; do test -x "$h" || echo "NOT_EXEC: $h"; done
  ```

### 3. Skills
- All `.github/skills/*/SKILL.md` files exist
- Each has `name:` and `description:` in frontmatter:
  ```bash
  for f in .github/skills/*/SKILL.md; do grep -q '^name:' "$f" || echo "BAD FRONTMATTER: $f"; done
  ```

### 4. Error Log
- `context/tasks/COPILOT_ERRORS.md` exists (warn if missing)

### 5. Secrets Scan
```bash
git ls-files | xargs grep -l 'BEGIN.*PRIVATE KEY\|password\s*=\s*[^{][^"\x27]\{8,\}' 2>/dev/null | head -10
```
Report any matches as ⚠️ warnings.

### 6. MCP Tool Reachability
Check that the required runtimes are available (all MCP tools run via `uvx` or `npx`):
```bash
command -v uvx &>/dev/null && echo "uvx: ✅" || echo "uvx: ❌ missing — install via: pip install uv"
command -v npx &>/dev/null && echo "npx: ✅" || echo "npx: ⚠️ missing — install Node.js (for playwright)"
command -v ccc &>/dev/null && echo "cocoindex CLI (ccc): ✅" || echo "cocoindex CLI (ccc): ⚠️ optional — install via: pip install cocoindex"
# uvx-based: codebase-memory-mcp, code-review-graph, serena, cocoindex-code-mcp-server (available when uvx installed)
```

## Report Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Copilot Brain Health — <repo>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  copilot-instructions.md  ✅ 187 lines / 4.2KB (budget: 32KB)
  Hook scripts             ✅ 9/9 executable
  Skills                   ✅ 49/49 have valid frontmatter
  Error log                ✅ COPILOT_ERRORS.md exists
  Secrets scan             ✅ no leaks detected
  codebase-memory-mcp      ⚠️ missing — run setup-plugins.sh
  cocoindex (ccc)          ✅ installed
  code-review-graph        ✅ installed
  uvx (playwright/serena)  ✅ installed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Overall: ⚠️ healthy with 1 warning
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

After the table, list any ⚠️/❌ items with one-line fix instructions.
