# Architectural Decisions — {{PROJECT_NAME}}

> This file records significant architectural decisions. When a pattern is established, document it here so future agents don't re-litigate it.

---

## ADR Format

```
## ADR-NNN — <Decision Title>

**Date:** YYYY-MM-DD
**Status:** Accepted | Deprecated | Superseded by ADR-NNN
**Context:** Why this decision was needed.
**Decision:** What was decided.
**Consequences:** What this enables, what it constrains.
```

---

<!-- ADR entries are added here during bootstrap and development -->

## ADR-001 — Use `claude/` as the shared knowledge layer

**Date:** Auto-filled by /bootstrap  
**Status:** Accepted  
**Context:** Both Claude Code and GitHub Copilot need access to project knowledge (architecture, build commands, rules). Duplicating this across CLAUDE.md and copilot-instructions.md creates maintenance drift.  
**Decision:** All deep project knowledge lives in `claude/*.md`. Both CLAUDE.md and `.github/copilot-instructions.md` reference these files via `read_file`. Files are always up-to-date in one place.  
**Consequences:** Any AI assistant that can read files has full project context. Updating once propagates everywhere.
