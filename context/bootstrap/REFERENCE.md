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
- 🔌 **Plugins** → [list enabled plugins or "none detected"]

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

## 🎯 What's Next — Get Productive in 60 Seconds

1. 💾 **Commit the brain**: `git add context/ .github/copilot-instructions.md .github/prompts/ .github/agents/ .github/skills/ .github/hooks/ .github/instructions/`
2. 👀 **Review** `context/architecture.md` — adjust as you explore deeper
3. 🧪 **Try it** — run `/build`, `/test`, `/lint` — they Just Work™
4. 📚 **Grow the brain** — create domain docs as you work: `context/<domain>.md`
5. 🔄 **Future upgrades**: re-run `bash install.sh .` → run `/bootstrap`

---

> 💡 **Pro tip:** Every correction you make gets captured in `context/tasks/lessons.md` — the AI literally cannot make the same mistake twice.

⏱️ **Phase timing:** P1 [time] · P3 [time] · P4 [time] · P5 [time]
⏱️ **Wall-clock total:** ~[N] minutes
```

---

## Template: UPGRADE

```markdown
# 🔄 Bootstrap Upgrade Complete — [PROJECT_NAME]

> ᗺB · [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap
> Generated [date] · **Mode: Upgrade** · ⏱️ Completed in ~[N] minutes

---

## ✅ What Changed

### Added

- [List new files or sections added]

### Enhanced

- [List files enriched with new patterns]

### Preserved

- [List existing user content that was kept untouched]

## ✅ Configuration Health

- **validate.sh** → ✅ **[N] passed**, 0 failed
- **Remaining placeholders** → ✅ 0

## 🎯 What's Next

1. 💾 **Commit the upgrade**: `git add context/ .github/copilot-instructions.md`
2. 👀 **Review changes** in the files listed above
3. 🔄 **Report any issues** — they'll be captured in `context/tasks/lessons.md`

⏱️ **Wall-clock total:** ~[N] minutes
```
