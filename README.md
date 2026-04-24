# Copilot Brain Bootstrap

<div align="center">

[![CI](https://github.com/brain-bootstrap/copilot-brain-bootstrap/actions/workflows/ci.yml/badge.svg)](https://github.com/brain-bootstrap/copilot-brain-bootstrap/actions/workflows/ci.yml)
![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-optimized-6e40c9?logo=github)
![License: MIT](https://img.shields.io/badge/License-MIT-0078D4.svg)
![Install in 5 min](https://img.shields.io/badge/Setup-5_minutes-green)

**Give GitHub Copilot the memory, discipline, and tooling it needs to be your best engineer.**

[Get Started](#-get-started-in-5-minutes) · [What's Inside](#-whats-inside) · [Under the Hood](#-under-the-hood) · [Contributing](CONTRIBUTING.md)

</div>

---

## Sound Familiar?

- Copilot gives you a different answer than last session for the same question
- Copilot doesn't know your build command, your test framework, or your service names
- Copilot adds 200 lines of unrelated refactoring to a 5-line bug fix
- Copilot triggers a pager and hangs the terminal
- Copilot writes code without first checking how the existing patterns work
- Copilot marks a task "done" without running a single test

**Copilot is not the problem. Missing context and missing discipline are.**

---

## Not Suggestions — Guarantees

Copilot Brain Bootstrap installs a structured system of context, rules, and automation that makes Copilot behave consistently, every session, every project.

| Without Bootstrap                             | With Bootstrap                                              |
| --------------------------------------------- | ----------------------------------------------------------- |
| Copilot reinvents patterns it can't remember  | Reads `claude/architecture.md` on every session start       |
| Copilot runs `git log` and hangs the terminal | Hook blocks it — adds `--no-pager` automatically            |
| Copilot says "done" without running tests     | Exit checklist enforces proof before ending the turn        |
| Copilot writes speculative code               | 14 golden rules in `claude/rules.md` — applied every task   |
| Copilot forgets your lessons                  | `claude/tasks/lessons.md` injected at session start         |
| No way to delegate parallel work              | `@researcher`, `@reviewer`, `@plan-challenger` agents       |
| No slash commands for common tasks            | 35+ `/prompts` for build, test, debug, mr, review, and more |

---

## Get Started in 5 Minutes

### Option A — One-line install (into an existing project)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/brain-bootstrap/copilot-brain-bootstrap/main/install.sh)
```

### Option B — Clone and install

```bash
git clone https://github.com/brain-bootstrap/copilot-brain-bootstrap.git
bash copilot-brain-bootstrap/install.sh /path/to/your-project
```

### Option C — Manual (copy what you need)

Pick any subset of `.github/prompts/`, `.github/agents/`, `.github/skills/`, or `.github/hooks/` and drop them into your project.

### After install

1. Open VS Code in your project
2. Open GitHub Copilot Chat
3. Type `/bootstrap` → Copilot fills your project-specific placeholders automatically
4. Type `/health` → verify everything is wired up correctly

---

## What's Inside

| Category              | Count | Description                                                         |
| --------------------- | ----- | ------------------------------------------------------------------- |
| **Prompts** (`/name`) | 38    | Slash commands for every common task                                |
| **Agents** (`@name`)  | 5     | Specialized expert agents for review, research, security            |
| **Skills**            | 18    | Auto-activating or on-demand specialist behaviors                   |
| **Hooks**             | 7     | Lifecycle automation: session context, safety gates, quality checks |
| **Instructions**      | 9     | Path-specific coding standards (TS, React, Node.js, Python, etc.)   |
| **Knowledge docs**    | 9     | Persistent project memory in `claude/`                              |

---

## Under the Hood

```
your-project/
├── .github/
│   ├── copilot-instructions.md      ← Always injected by Copilot (<4KB)
│   ├── agents/
│   │   ├── reviewer.agent.md        ← @reviewer — 10-point code review
│   │   ├── researcher.agent.md      ← @researcher — read-only exploration
│   │   ├── plan-challenger.agent.md ← @plan-challenger — adversarial review
│   │   ├── security-auditor.agent.md← @security-auditor — 6-category scan
│   │   └── session-reviewer.agent.md← @session-reviewer — extract lessons
│   ├── hooks/
│   │   ├── session-context.json     ← SessionStart: inject branch + todos + commits
│   │   ├── terminal-safety.json     ← PreToolUse: block pager/interactive/destructive
│   │   ├── config-protection.json   ← PreToolUse: warn on IDE config edits
│   │   ├── pre-commit-quality.json  ← PreToolUse: check staged files for secrets
│   │   ├── quality-gate.json        ← Stop: exit checklist nudge
│   │   ├── subagent-stop.json       ← SubagentStop: lessons + errors capture
│   │   ├── pre-compact.json         ← PreCompact: save state before compaction
│   │   └── scripts/                 ← Shell scripts for each hook
│   ├── prompts/
│   │   ├── bootstrap.prompt.md      ← /bootstrap — autonomous project setup
│   │   ├── plan.prompt.md           ← /plan — write checkable todo list
│   │   ├── debug.prompt.md          ← /debug — root cause first, always
│   │   ├── review.prompt.md         ← /review — 10-point code review
│   │   ├── mr.prompt.md             ← /mr — generate MR description
│   │   └── ...35+ prompts total
│   ├── skills/
│   │   ├── tdd/SKILL.md             ← Auto-activates on test files
│   │   ├── root-cause-trace/        ← Iron Law: no fix without root cause
│   │   ├── brainstorming/           ← Hard gate before any code
│   │   ├── careful/                 ← Extra safety for destructive ops
│   │   ├── cross-layer-check/       ← Consistency across all layers
│   │   ├── codeburn/                ← Token cost observability
│   │   └── ...18 skills total
│   └── instructions/
│       ├── general.instructions.md  ← Applies to all files
│       ├── quality-gates.instructions.md ← Lines/params/nesting limits
│       ├── typescript.instructions.md    ← TS strict mode, Zod, interfaces
│       ├── nodejs-backend.instructions.md ← Routes, repos, HTTP codes
│       ├── react.instructions.md    ← Hooks, TanStack Query, stable keys
│       ├── python.instructions.md   ← Type hints, Pydantic, pytest
│       └── testing.instructions.md  ← Applies to test files only
└── claude/
    ├── architecture.md              ← Service catalog + workspace layout
    ├── rules.md                     ← 14 non-negotiable working standards
    ├── build.md                     ← Build/test/lint commands
    ├── templates.md                 ← MR/PR and ticket templates
    ├── terminal-safety.md           ← Terminal safety reference
    ├── cve-policy.md                ← Dependency security policy
    └── tasks/
        ├── todo.md                  ← Current task state
        ├── lessons.md               ← Accumulated wisdom
        └── COPILOT_ERRORS.md        ← Recurring mistakes to avoid
```

---

## How It Works

### Automatic Context Injection (SessionStart hook)

Every Copilot session starts with a hook that injects:

- Current git branch
- Open todos from `claude/tasks/todo.md`
- Recent lessons from `claude/tasks/lessons.md`
- Active error patterns from `claude/tasks/COPILOT_ERRORS.md`

No more "what branch are we on?" every session.

### Terminal Safety (PreToolUse hook)

Before any `run_in_terminal` call, a hook checks:

- Is this a git command that will trigger a pager? → Block + suggest `--no-pager`
- Is this an interactive program? → Block with explanation
- Is this a destructive operation (rm -rf, DROP TABLE)? → Block + require confirmation

### Quality Gate (Stop hook)

Before ending any turn, a hook warns about:

- Uncommitted changes
- Unchecked todo items
- Stale lessons file

### The `claude/` Knowledge Layer

All deep project knowledge lives in `claude/*.md` — not in copilot-instructions.md (which is limited to 4KB). Copilot reads these files on demand via `read_file`. Update once, applies everywhere.

This layer is **AI-agnostic**: Claude Code, GitHub Copilot, or any AI that can read files uses the same source of truth.

---

## The Prompts

Type `/` in Copilot Chat to see all available prompts.

| Prompt            | What it does                                                     |
| ----------------- | ---------------------------------------------------------------- |
| `/bootstrap`      | Auto-discover project, fill all placeholders, configure plugins  |
| `/plan`           | Write checkable todo list with risk analysis before implementing |
| `/debug`          | 4-phase debug: Observe → Hypothesize → Trace → Verify            |
| `/review`         | 10-point code review with severity markers                       |
| `/mr`             | Generate MR description after build+test+lint pass               |
| `/build`          | Run build, report failures                                       |
| `/test`           | Run tests, report count and failures                             |
| `/lint`           | Run linter, optionally auto-fix                                  |
| `/resume`         | Restore full session context after a break                       |
| `/checkpoint`     | Save progress, commit, prepare for handoff                       |
| `/health`         | Full system health check                                         |
| `/research`       | Structured codebase exploration                                  |
| `/caveman`        | Think out loud before coding (hard gate)                         |
| `/status`         | Branch, uncommitted changes, open todos                          |
| `/generate-tests` | TDD-first test generation                                        |
| + 23 more         | See `.github/prompts/`                                           |

---

## The Agents

Invoke with `@agent-name` in Copilot Chat.

| Agent               | What it does                                                                  |
| ------------------- | ----------------------------------------------------------------------------- |
| `@reviewer`         | 10-point review: cross-layer consistency, transaction safety, test coverage   |
| `@researcher`       | Read-only exploration with structured findings: evidence, data flow, pitfalls |
| `@plan-challenger`  | Adversarial plan review: 5 attack dimensions + self-refutation                |
| `@security-auditor` | 6-category scan: secrets, auth, input validation, deps, data handling, infra  |
| `@session-reviewer` | Extract lessons from session patterns; feed to lessons.md                     |

---

## The Skills

Skills are auto-activating or on-demand specialist behaviors.

| Skill                   | Activates             | What it enforces                                   |
| ----------------------- | --------------------- | -------------------------------------------------- |
| `tdd`                   | On test files         | 3-phase: Explore → Plan → Act                      |
| `root-cause-trace`      | On-demand             | Iron Law: no fix without root cause                |
| `brainstorming`         | On-demand             | Hard gate — no code without structured analysis    |
| `careful`               | On-demand             | Blocks destructive ops until explicit confirmation |
| `cross-layer-check`     | On-demand             | New fields must be consistent across all layers    |
| `changelog`             | On-demand             | Keep a Changelog format, user-facing descriptions  |
| `receiving-code-review` | On-demand             | Triage, fix, respond to review comments            |
| `writing-skills`        | On-demand             | Clear, evidence-based technical writing            |
| + 9 more                | See `.github/skills/` |                                                    |

---

## Validation

```bash
bash validate.sh
```

Checks: core instruction file, knowledge layer, prompts, agents, hooks, skills, instructions, and placeholder detection. Returns ✅/❌ per check.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

MIT — see [LICENSE](LICENSE).

---

<div align="center">

Built by developers who were tired of re-explaining the same things to Copilot every session.

</div>
