# Bootstrap Reference — Report Templates

> **This file is read by Copilot in Phase 5 only.** It contains the report templates for FRESH INSTALL and UPGRADE.
> Keeping it separate from `context/bootstrap/PROMPT.md` prevents these lines from occupying working context during execution phases 1–4.

---

## Template: FRESH INSTALL

```markdown
# 🎉 Bootstrap Complete — [PROJECT_NAME]

> ᗺB · [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap
> Your AI coding assistant just learned everything about your codebase.
> Generated [date] · **Mode: Fresh Install** · ⏱️ Completed in ~[N] minutes

---

## ✅ Configuration Health — All Systems Go

- **validate.sh** → ✅ **[N] passed**, 0 failed
- **Remaining placeholders** → ✅ 0
- **copilot-instructions.md** → ✅ [N] lines (budget: ≤4KB)
- **Domain docs created** → ✅ [N]

## 🔍 What Brain Learned About Your Stack

- 🗣️ **Language(s)** → [list with file counts]
- 📦 **Package Manager** → [name + version]
- 🏗️ **Frameworks** → [list]
- 🎨 **Formatter/Linter** → [name]
- 🧪 **Test Framework** → [name]
- 📐 **Architecture** → [monorepo/single-app/dual-tier/library]
- ⚙️ **CI** → [name]
- 🗄️ **Database** → [name or N/A]
- 🔌 **MCP Tools** → [list configured tools from `.mcp.json`, or "none configured"]

## 📁 What Was Installed

- **[N] filled config files** — zero placeholders remaining
- **[N] slash commands** — `/build`, `/test`, `/lint`, `/review`, `/mr`, `/plan`, `/debug`, `/bootstrap`, `/health`, and more
- **[N] lifecycle hooks** — config protection, terminal safety, session context
- **[N] AI subagents** — `@reviewer`, `@researcher`, `@plan-challenger`, `@security-auditor`, `@session-reviewer`
- **[N] skills** — tdd, root-cause-trace, cross-layer-check, careful, changelog, and more
- **[N] domain docs** — [list: `context/architecture.md`, `context/build.md`, others created]
- **Project-specific rules** — captured in `context/rules.md`

## 🧠 Project-Specific Patterns Captured

[List 3–5 critical rules discovered from the codebase:]

- [Pattern 1 — e.g., "Never block real-time loops with synchronous I/O"]
- [Pattern 2 — e.g., "All API responses must use the shared ResponseBuilder"]
- [Pattern 3]

## 💡 MCP Suggestions (based on your stack)

[Fill from Phase 4.5 — only include if relevant:]

- [e.g., "Database MCP — DATABASE detected"]
- [e.g., "GitHub MCP — github-actions CI detected"]

## 🔌 MCP Tool Status

> These tools are MCP servers — configured in `.mcp.json`, not Claude plugins.

- **CocoIndex** → [configured in .mcp.json / not configured]
  → Install: `uvx cocoindex-code-mcp-server@latest --data-dir .codex/cocoindex --index`
- **Code Review Graph** → [configured in .mcp.json / not configured]
  → Install: `uvx code-review-graph@latest`
- **Serena** → [configured in .mcp.json / not configured]
  → Install: `uvx serena@latest`
- **Playwright** → [configured in .mcp.json / not configured]
  → Install: `npx @playwright/mcp@latest`

→ Browse more MCP servers: [smithery.ai](https://smithery.ai)

## 🤝 Collaboration Mode

🤝 **TEAM** (default) — config is committed, shared with the team.
→ Switch to SOLO (personal, not committed): `echo -e '\ncontext/\n.github/copilot-instructions.md' >> .gitignore`

## 🎯 What's Next — Get Productive in 60 Seconds

1. 💾 **Commit the brain**: `git add context/ .github/copilot-instructions.md .github/prompts/ .github/agents/ .github/skills/ .github/hooks/ .github/instructions/`
2. 👀 **Review** `context/architecture.md` — adjust as you explore deeper
3. 🧪 **Try it** — run `/build`, `/test`, `/lint` — they Just Work™
4. 📚 **Grow the brain** — create domain docs as you work: `context/<domain>.md`
5. 🔄 **Future upgrades**: re-run `bash install.sh .` → run `/bootstrap`

---

> 💡 **Pro tip:** Every correction you make gets captured in `context/tasks/lessons.md` — the AI literally cannot make the same mistake twice.

⏱️ **Phase timing:** P1 [time] · P2 skipped (FRESH) · P3 [time] · P4 [time] · P5 [time]
⏱️ **Wall-clock total:** ~[N] minutes
```

---

## Template: UPGRADE

```markdown
# 🔄 Configuration Upgraded — [PROJECT_NAME]

> ᗺB · [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap
> Your Brain just got smarter — new capabilities installed, all your knowledge preserved.
> Generated [date] · **Mode: Smart Upgrade** · ⏱️ Completed in ~[N] minutes

---

## ✅ Configuration Health — All Systems Go

- **validate.sh** → ✅ **[N] passed**, 0 failed
- **Remaining placeholders** → ✅ 0
- **copilot-instructions.md** → ✅ [N] lines (budget: ≤4KB)
- **Domain docs** → ✅ [N] total ([N] preserved, [N] enriched, [N] new)

## 🛡️ What Was Preserved — Your Knowledge is Sacred

- 📚 **Your domain docs** → ✅ Untouched — [list of preserved context/*.md]
- 🧠 **Your lessons & todo** → ✅ Untouched — Sacred, never modified
- ⚡ **Your custom prompts** → ✅ Untouched — [list]
- 🪝 **Your custom hooks** → ✅ Untouched — [list]
- 📋 **Your copilot-instructions.md** → ✅ Enhanced — [N] sections added, all your content preserved

## ➕ What Was Added / Upgraded

- ⚡ **New prompts** → [list of added prompts, or "none — you had them all!"]
- 🪝 **New hooks** → [list of added hooks, or "none — fully hooked up!"]
- 🖥️ **Instructions** → [N] new instruction files merged
- 📁 **Directory structure** → [normalized to context/tasks/, or "already standard ✅"]

## 🤝 Collaboration Mode

🤝 **TEAM** (default) — config is committed, shared with the team.
→ Switch to SOLO (personal, not committed): `echo -e '\ncontext/\n.github/copilot-instructions.md' >> .gitignore`

## 🎯 Review Recommendations

1. 💾 **Commit**: `git add context/ .github/copilot-instructions.md .github/prompts/ .github/agents/ .github/skills/ .github/hooks/ .github/instructions/`
2. 👀 Scan `copilot-instructions.md` for `<!-- Added by template upgrade -->` markers — verify they fit your project
3. 🧪 Run `/plan` to verify Copilot has the full project context

---

> 💡 Your accumulated knowledge (`context/tasks/lessons.md`) was never touched. Every lesson learned carries forward.

⏱️ **Phase timing:** P1 [time] · P2 [time] · P3 [time] · P4 [time] · P5 [time]
⏱️ **Wall-clock total:** ~[N] minutes
```
