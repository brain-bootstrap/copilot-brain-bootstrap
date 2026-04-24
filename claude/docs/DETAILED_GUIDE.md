# Copilot Brain Bootstrap — The Complete Guide

> **Everything you need to know, nothing you don't.**
> From "what is this?" to "I want to build my own hooks."

[Big Picture](#the-big-picture) · [Get Started](#get-started) · [Architecture](#architecture-tour) · [Every File Explained](#every-file-explained) · [Deep Dives](#deep-dives) · [Make It Yours](#make-it-yours) · [FAQ](#faq)

---

> 📖 **This is the deep reference.** Looking for the quick pitch? → [README.md](../../README.md)

---

## The Big Picture

Copilot Brain Bootstrap is a **production-grade scaffolding system** for GitHub Copilot. It installs in one command and gives every Copilot session:

- **Long-term memory** via `claude/` knowledge docs (your AI reads these)
- **38 slash commands** for every development workflow
- **18 skills** for specialized tasks (TDD, security, root-cause tracing...)
- **5 custom agents** (reviewer, researcher, security-auditor, session-reviewer, plan-challenger)
- **7 lifecycle hooks** that run automatically at session start, before commits, and more
- **9 instruction files** that enforce coding standards per file type

---

## Get Started

```bash
# Install into your project
bash <(curl -fsSL https://raw.githubusercontent.com/y-abs/copilot-brain-bootstrap/main/install.sh)

# Validate installation
bash validate.sh

# In Copilot chat, initialize project-specific config
/bootstrap
```

### First session checklist

1. Run `/bootstrap` to fill in `{{PROJECT_NAME}}` and other placeholders
2. Read `claude/tasks/todo.md` to see your current task state
3. Review `claude/tasks/lessons.md` to load session wisdom
4. Try `/plan` for new features, `/review` before PRs, `/debug` for errors

---

## Architecture Tour

### The Three-Tier Context Strategy

```
Tier 1: Always-on (<4KB)     .github/copilot-instructions.md
         ↓                    Injected every request, every time

Tier 2: Path-scoped          .github/instructions/*.instructions.md
         ↓                    Auto-loaded when editing matching files

Tier 3: On-demand            .github/skills/, .github/prompts/
         ↓                    Loaded only when relevant — keeps context clean
```

**Why this matters:** Copilot has a fixed context budget. Tier 1 uses ~4KB. Everything else loads only when needed, letting you have 18 skills + 38 prompts without burning your context window.

### Hook Execution Flow

```
User submits prompt
  → SessionStart hook fires (injects branch, todos, recent commits)
  → [Agent works...]
  → PreToolUse hook fires before any terminal command (safety gate)
  → [Agent runs command...]
  → PostToolUse hook fires after file edits (quality gate)
  → [Agent finishes...]
  → Stop hook fires (exit checklist nudge)
```

---

## Every File Explained

### Root Files

| File                                     | Purpose                                                  |
| ---------------------------------------- | -------------------------------------------------------- |
| `install.sh`                             | FRESH + UPGRADE installation. Idempotent.                |
| `validate.sh`                            | Confirms all components installed correctly              |
| `.shellcheckrc`                          | ShellCheck config — `shell=bash`, SC1090/SC1091 disabled |
| `.gitignore`                             | Ignores local overrides and session artifacts            |
| `.copilot-instructions.local.md.example` | Template for personal overrides (gitignored)             |

### Knowledge Layer (`claude/`)

These files are **read by the AI** at the start of each session. Keep them accurate.

| File                             | Purpose                                                  |
| -------------------------------- | -------------------------------------------------------- |
| `claude/rules.md`                | Code quality rules, architectural constraints            |
| `claude/architecture.md`         | System design, layers, key decisions                     |
| `claude/build.md`                | Build commands, test commands, CI setup                  |
| `claude/templates.md`            | MR/PR templates, commit message formats                  |
| `claude/terminal-safety.md`      | Terminal safety reference — pagers, pipes, interactivity |
| `claude/cve-policy.md`           | Dependency vulnerability response policy                 |
| `claude/plugins.md`              | MCP plugins documentation                                |
| `claude/decisions.md`            | Settled architecture decisions (ADR-lite)                |
| `claude/tasks/todo.md`           | Current task state — updated every session               |
| `claude/tasks/lessons.md`        | Accumulated wisdom from past sessions                    |
| `claude/tasks/COPILOT_ERRORS.md` | Bug tracker with promotion lifecycle                     |

### Prompts (`.github/prompts/`)

38 slash commands covering every workflow. Type `/` in Copilot chat to see them all.

Key prompts:

| Command      | Purpose                            |
| ------------ | ---------------------------------- |
| `/plan`      | Create a task plan with subtasks   |
| `/review`    | Expert 10-point code review        |
| `/debug`     | Root cause analysis                |
| `/mr`        | Generate MR/PR description         |
| `/bootstrap` | Initialize project-specific config |
| `/resume`    | Resume from last session state     |
| `/health`    | Project health check               |
| `/test`      | Run test suite                     |
| `/build`     | Build the project                  |

### Agents (`.github/agents/`)

5 specialized agents invoked with `@agent-name`:

| Agent               | Optimal model | Purpose                                      |
| ------------------- | :-----------: | -------------------------------------------- |
| `@reviewer`         |     opus      | 10-point code review protocol                |
| `@researcher`       |    sonnet     | Codebase exploration, preserves main context |
| `@security-auditor` |     opus      | 6-category security scan                     |
| `@plan-challenger`  |     opus      | Adversarial plan review                      |
| `@session-reviewer` |    sonnet     | Pattern detection in sessions                |

### Hooks (`.github/hooks/`)

7 lifecycle hooks that execute shell commands automatically:

| Hook                      | Event        | Purpose                                    |
| ------------------------- | ------------ | ------------------------------------------ |
| `session-context.json`    | SessionStart | Injects branch, todos, commits, jq warning |
| `terminal-safety.json`    | PreToolUse   | Blocks dangerous commands                  |
| `config-protection.json`  | PreToolUse   | Blocks IDE config modifications            |
| `pre-commit-quality.json` | PreToolUse   | Checks staged files for secrets/debuggers  |
| `quality-gate.json`       | Stop         | Exit checklist nudge                       |
| `subagent-stop.json`      | SubagentStop | Lessons + errors capture nudge             |
| `pre-compact.json`        | PreCompact   | Saves state before context compaction      |

### Skills (`.github/skills/`)

18 skills loaded on-demand when relevant:

| Skill                         | Trigger                        |
| ----------------------------- | ------------------------------ |
| `tdd`                         | Test file editing              |
| `root-cause-trace`            | Error investigation            |
| `cross-layer-check`           | New fields/enums across layers |
| `codebase-memory`             | Architecture questions         |
| `cocoindex-code`              | Semantic code search           |
| `code-review-graph`           | PR blast radius                |
| `serena`                      | LSP-based refactoring          |
| `playwright`                  | Browser automation             |
| `codeburn`                    | Token cost observability       |
| `brainstorming`               | Idea generation                |
| `careful`                     | High-stakes changes            |
| `changelog`                   | Release notes                  |
| `issue-triage`                | GitHub issues                  |
| `pr-triage`                   | GitHub PRs                     |
| `receiving-code-review`       | Code review response           |
| `repo-recap`                  | Repository overview            |
| `subagent-driven-development` | Multi-agent orchestration      |
| `writing-skills`              | Documentation writing          |

### Instructions (`.github/instructions/`)

9 instruction files auto-loaded per file type:

| File                              | Applies to                              |
| --------------------------------- | --------------------------------------- |
| `general.instructions.md`         | All files                               |
| `terminal-safety.instructions.md` | All files                               |
| `quality-gates.instructions.md`   | All files                               |
| `typescript.instructions.md`      | `*.ts`, `*.tsx`, `tsconfig.json`        |
| `nodejs-backend.instructions.md`  | `routes/`, `controllers/`, `src/`, etc. |
| `react.instructions.md`           | `*.tsx`, `*.jsx`, `src/components/`     |
| `python.instructions.md`          | `*.py`                                  |
| `testing.instructions.md`         | `*.test.*`, `*.spec.*`                  |
| `_template.instructions.md`       | Template for custom instruction files   |

---

## Deep Dives

### How Hooks Work

Hooks receive JSON on stdin and can return JSON on stdout:

```bash
# Input (always includes)
{
  "timestamp": "...",
  "cwd": "/path/to/workspace",
  "sessionId": "...",
  "hookEventName": "PreToolUse",
  "tool_name": "run_in_terminal",
  "tool_input": { "command": "git push" }
}

# Output to block
exit 2  # stderr shown to model as reason

# Output to inject context
echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"..."}}'
```

**Key difference from Claude Code:** VS Code uses camelCase for tool input — `tool_input.filePath`, `tool_input.command` (not snake_case).

### The `COPILOT_HOOK_PROFILE` variable

Set `COPILOT_HOOK_PROFILE` in your shell environment to control hook strictness:

| Profile              | What it blocks                                              |
| -------------------- | ----------------------------------------------------------- |
| `minimal`            | Only catastrophic operations (rm -rf /, force push to main) |
| `standard` (default) | + SQL drops, git reset --hard, chmod 777                    |
| `strict`             | + pipe-to-shell (curl \| sh), eval, writes to /etc          |

### Bootstrap vs Upgrade

```bash
# FRESH install (new repo)
bash install.sh /path/to/target

# UPGRADE (existing repo, preserves customizations)
bash install.sh /path/to/target  # detects existing config, merges safely
```

The installer detects existing `claude/` docs and skips them to preserve your customizations.

---

## Placeholder Reference

After installation, run `/bootstrap` in Copilot chat to fill these placeholders:

| Placeholder                | Meaning            | Example                      |
| -------------------------- | ------------------ | ---------------------------- |
| `{{PROJECT_NAME}}`         | Your project name  | `my-api`                     |
| `{{FORMATTER}}`            | Code formatter     | `prettier`, `ruff`, `gofmt`  |
| `{{PACKAGE_MANAGER}}`      | Package manager    | `npm`, `pnpm`, `yarn`, `pip` |
| `{{RUNTIME}}`              | Runtime version    | `Node 22`, `Python 3.12`     |
| `{{ARCHITECTURE_SUMMARY}}` | Brief architecture | `Monorepo: api/ + web/`      |

---

## Make It Yours

### Add a custom instruction file

```markdown
---
applyTo: 'src/payments/**'
---

# Payments Domain Rules

- Never log card numbers or CVVs
- All payment amounts are in cents (integer), never floats
- PCI-DSS: no payment data in logs, analytics, or error messages
```

Save to `.github/instructions/payments.instructions.md`.

### Add a custom hook

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": "npx prettier --write \"$TOOL_INPUT_FILE_PATH\"",
        "timeout": 30
      }
    ]
  }
}
```

Save to `.github/hooks/auto-format.json`.

### Add a custom skill

```markdown
---
name: my-domain
description: Specialized knowledge for payments processing — use when working with Stripe, webhooks, or billing
---

# My Domain Skill

[Your domain-specific instructions...]
```

Save to `.github/skills/my-domain/SKILL.md`.

### Add domain knowledge docs

Copy `claude/_examples/api-domain.md` as a starting point.  
Save your version to `claude/domain/my-api.md` and reference it from `CLAUDE.md`.

---

## FAQ

**Q: Why is there a `claude/` folder in a Copilot repo?**  
A: Copilot reads the same `claude/` knowledge docs as Claude Code. This makes the repo dual-compatible — one knowledge base, two AI tools. The `claude/` docs contain your architecture, rules, and task state.

**Q: What's the difference between a skill and a prompt?**  
A: Prompts (`.prompt.md`) are slash commands you invoke explicitly. Skills (`.github/skills/`) are capabilities the AI loads automatically when relevant — or on demand via `/skillname`. Skills can include scripts and resources; prompts are instructions only.

**Q: Do hooks slow down Copilot?**  
A: Each hook has a configurable timeout (default 30s). Simple hooks (terminal safety check) take <100ms. Heavy hooks (quality gate script) take 1-3s. All run in parallel with Copilot's processing.

**Q: Can I use this with Claude Code too?**  
A: Yes. The `claude/` knowledge layer is shared. Claude Code uses `.claude/` for commands and hooks (separate from `.github/`). Run both setups — they share the knowledge docs without conflicts.

**Q: How do I disable a hook?**  
A: Delete or rename the `.json` file in `.github/hooks/`. Or set `chat.hookFilesLocations` in VS Code settings to exclude specific hook files.

**Q: What's the minimum VS Code version for hooks?**  
A: Hooks require VS Code with GitHub Copilot Chat extension. Agent hooks are currently in Preview — check the VS Code release notes for the minimum version.
