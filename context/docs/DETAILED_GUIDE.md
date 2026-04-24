<p align="center">
  <h1 align="center">ᗺB · Copilot Brain Bootstrap — The Complete Guide</h1>
  <p align="center"><em>by <a href="https://github.com/brain-bootstrap">brain-bootstrap</a></em></p>
  <p align="center"><strong>Everything you need to know, nothing you don't.<br>From "what is this?" to "I want to build my own hooks."</strong></p>
  <p align="center">
    <a href="#-the-big-picture">Big Picture</a> · <a href="#-get-started">Get Started</a> · <a href="#-the-architecture-tour">Architecture</a> · <a href="#-every-file-explained">Files</a> · <a href="#-deep-dives">Deep Dives</a> · <a href="#-make-it-yours">Make It Yours</a> · <a href="#-faq">FAQ</a>
  </p>
  <p align="center">
    <a href="../../LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License"></a>
    <a href="#"><img src="https://img.shields.io/badge/100%2B_files-8_categories-6e40c9" alt="100+ files"></a>
    <a href="#"><img src="https://img.shields.io/badge/38_prompts-7_hooks-brightgreen" alt="Automation"></a>
  </p>
</p>

---

> 📖 **This is the deep reference.** Looking for the quick pitch? → [README.md](../../README.md)
>
> **Reading time:** ~15 minutes cover to cover. Every section is self-contained.

---

## 🗺️ The Big Picture

Copilot Brain Bootstrap is **100+ files** organized into **8 categories** that turn GitHub Copilot from a talented stranger into a senior engineer who knows your codebase inside out.

Here's the mental model:

```
  🧠  Your Brain (copilot-instructions.md)
   │   "Here's how we work, here's what matters, here's what never to touch"
   │
   ├── 📚  Knowledge (context/*.md)
   │       "Here's our architecture, our build system, our auth patterns..."
   │
   ├── 📋  Automation (.github/prompts/)
   │       "Here's a slash command for every workflow you'll ever need"
   │
   ├── 🪝  Guardrails (.github/hooks/)
   │       "Here's what you're NOT allowed to do, enforced in code"
   │
   ├── 🤖  Delegation (.github/agents/)
   │       "Here's your team — research, review, challenge"
   │
   ├── 🎓  Discipline (.github/skills/)
   │       "Here's how to write tests, trace bugs, stay safe"
   │
   ├── 📖  Standards (.github/instructions/)
   │       "Here are your coding standards per file type"
   │
   └── 🧠  Memory (context/tasks/)
            "Here's everything we've learned together"
```

**38 slash commands. 7 lifecycle hooks. 5 AI agents. 18 skills. 9 instruction files. 5 MCP plugins. Zero setup friction.**

> 💡 Battle-tested. Works with **any language, any framework, any repo**.

---

## 🚀 Get Started

### Step 1 — Install the template

```bash
git clone https://github.com/brain-bootstrap/copilot-brain-bootstrap.git /tmp/copilot-brain
bash /tmp/copilot-brain/install.sh your-repo/
rm -rf /tmp/copilot-brain
```

> 🔍 **Pre-flight check:** `bash /tmp/copilot-brain/install.sh --check` — verifies all prerequisites before touching your repo. Runs in 1 second, no side effects.

The installer **auto-detects** fresh install vs. upgrade — it never overwrites your knowledge (`context/`, `lessons.md`, architecture docs). Existing files stay untouched; only missing pieces are added.

### Step 2 — Let Copilot configure itself

Open VS Code in your project, open Copilot Chat, and type:

```
/bootstrap
```

Copilot will:

1. 🔍 **Discover** your tech stack (`discover.sh` — pure bash, zero tokens) — detects language, framework, package manager, CI, DB
2. 🏗️ **Analyze** your architecture — services, domains, patterns, aliases
3. 📝 **Populate** all `{{PLACEHOLDER}}` values across every template file (70+ placeholders)
4. 🧠 **Generate** domain-specific knowledge docs — adaptive depth based on 8 domain greps
5. 🔌 **Configure** MCP tools — suggestions for cocoindex, codebase-memory-mcp, code-review-graph, playwright, serena
6. ✅ **Validate** everything works (`bash validate.sh` — 100+ checks)

> 💡 **No Copilot Chat?** Paste `context/bootstrap/PROMPT.md` into any AI chat — it works with any LLM.

### Step 3 — Validate and commit

```bash
bash validate.sh
git add .github/ context/ .mcp.json
git commit -m "chore: add Copilot Brain configuration"
```

> 🤝 **TEAM mode (default)** — commit everything, share the same Copilot behavior with your whole team. Or **SOLO mode**: add `context/` to `.gitignore` and keep knowledge personal.

### Step 4 — Ship code with superpowers

```
/plan implement user authentication
/build
/test
/review
/mr JIRA-123
```

That's it. Copilot now knows your project. 🧠

### First session checklist

1. Run `/bootstrap` to fill in `{{PROJECT_NAME}}` and other placeholders
2. Read `context/tasks/todo.md` to see your current task state
3. Review `context/tasks/lessons.md` to load session wisdom
4. Try `/plan` for new features, `/review` before PRs, `/debug` for errors

---

## 🏛️ The Architecture Tour

Here's how all 100+ files fit together:

```
your-repo/
├── 📋 .github/copilot-instructions.md  ← The brain (<4KB — injected every session)
│
├── 🤖 .github/agents/   (5 files)      ← @reviewer, @researcher, @plan-challenger...
├── 🪝 .github/hooks/    (7 files)      ← Safety, quality, session continuity
│   └── scripts/                         ← Deterministic bash — zero AI tokens
├── 📋 .github/prompts/  (38 files)     ← /plan, /review, /debug, /mr, /bootstrap...
├── 🎓 .github/skills/   (18 dirs)      ← tdd, root-cause-trace, brainstorming...
├── 📖 .github/instructions/ (9 files)  ← Auto-load per file type (TS, React, Python...)
│
└── 📚 context/                          ← Persistent knowledge — updated once, read everywhere
    ├── architecture.md                  ← Service catalog + workspace layout
    ├── rules.md                         ← 14 non-negotiable working standards
    ├── build.md                         ← Build/test/lint/CI commands
    ├── plugins.md                       ← MCP tool catalog
    └── tasks/
        ├── todo.md                      ← 📝 Current task plan (survives restarts)
        ├── lessons.md                   ← 🧠 Accumulated wisdom (injected every session)
        └── COPILOT_ERRORS.md            ← 🐛 Recurring mistakes → promotes to rules at 3+
```

### 🎯 The Three-Tier Context Strategy

Your AI shouldn't drown in 50K tokens when you ask it to fix a typo. So the system loads knowledge in three layers:

| Layer                | What loads                                                     | When                      |     Cost     |
| :------------------- | :------------------------------------------------------------- | :------------------------ | :----------: |
| 🟢 **Always on**     | `copilot-instructions.md` — operating protocol, critical rules | Every session             | ~3-4K tokens |
| 🟡 **Auto-injected** | `todo.md` + `lessons.md` + git status — via SessionStart hook  | Every session start       | ~1-2K tokens |
| 🔵 **On-demand**     | Full domain docs — architecture, build, auth, database         | When the task requires it |  ~1-2K each  |

**Why this matters:** Copilot has a fixed context budget. Tier 1 uses ~4KB. Everything else loads only when needed, letting you have 18 skills + 38 prompts without burning your context window.

### Hook Execution Flow

```
User submits prompt
  → SessionStart hook fires (injects branch, todos, lessons, recent commits)
  → [Copilot works...]
  → PreToolUse hook fires before any terminal command (safety gate)
  → [Copilot runs command...]
  → [Copilot finishes...]
  → Stop hook fires (exit checklist nudge)
```

---

## 📂 Every File, Explained

### 🏠 Root Files

| File                                     | Purpose                                                                                                |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `install.sh`                             | FRESH + UPGRADE installation. Idempotent — never overwrites your knowledge.                            |
| `validate.sh`                            | 100+ checks: file existence, hook loading, placeholder detection, MCP config integrity.                |
| `.shellcheckrc`                          | ShellCheck config — `shell=bash`, SC1090/SC1091 disabled (dynamic sourcing)                            |
| `.gitignore`                             | Ignores local overrides and session artifacts                                                          |
| `.copilot-instructions.local.md.example` | Template for personal overrides — copy to `.github/instructions/personal.instructions.md` (gitignored) |

### 🧠 Bootstrap Scaffolding — `context/bootstrap/` (3 files)

> These files exist only during bootstrap. They can be deleted after Phase 5 cleanup. For future upgrades, re-clone the template.

| File                  | What it does                                                         |
| :-------------------- | :------------------------------------------------------------------- |
| 🪄 `PROMPT.md`        | Paste into any AI to auto-configure — works with any LLM             |
| 📖 `REFERENCE.md`     | Report templates for Phase 5 — kept separate to save working context |
| 🔄 `UPGRADE_GUIDE.md` | Smart Merge guide (Phase 2) — loaded only for UPGRADE mode           |

### 📚 Knowledge Layer (`context/`)

These files are **read by Copilot** on demand. Keep them accurate — they're the AI's textbooks.

| File                              | Purpose                                                  |     Auto-loaded?     |
| --------------------------------- | -------------------------------------------------------- | :------------------: |
| `context/rules.md`                | Code quality rules, architectural constraints            |     📖 On-demand     |
| `context/architecture.md`         | System design, layers, key decisions                     |     📖 On-demand     |
| `context/build.md`                | Build commands, test commands, CI setup                  |     📖 On-demand     |
| `context/templates.md`            | MR/PR templates, commit message formats                  |     📖 On-demand     |
| `context/terminal-safety.md`      | Terminal safety reference — pagers, pipes, interactivity |  🔒 Via instruction  |
| `context/cve-policy.md`           | Dependency vulnerability response policy                 |     📖 On-demand     |
| `context/plugins.md`              | MCP plugins documentation                                |     📖 On-demand     |
| `context/decisions.md`            | Settled architecture decisions (ADR-lite)                |     📖 On-demand     |
| `context/tasks/todo.md`           | Current task state — updated every session               | ✅ SessionStart hook |
| `context/tasks/lessons.md`        | Accumulated wisdom from past sessions                    | ✅ SessionStart hook |
| `context/tasks/COPILOT_ERRORS.md` | Bug tracker with promotion lifecycle                     |     📖 On-demand     |

> 💡 **The `_examples/` folder** has three worked domain examples (API, database, messaging). Study them → create your own → delete them.

### 📋 Prompts — `.github/prompts/` (38 files)

38 slash commands covering every workflow. Type `/` in Copilot Chat to see them all.

| Command           | What it does                               | ✨ Special sauce                                |
| :---------------- | :----------------------------------------- | :---------------------------------------------- |
| `/plan`           | Create a task plan before coding           | Checkable todos + risk analysis                 |
| `/review`         | Expert 10-point code review                | Severity-classified findings                    |
| `/debug`          | Root cause analysis workflow               | 4-phase: Observe → Hypothesize → Trace → Verify |
| `/mr`             | Generate MR/PR description                 | After build+test+lint pass                      |
| `/bootstrap`      | Initialize project-specific config         | 5-phase auto-configure process                  |
| `/resume`         | Resume from last session state             | Re-loads todos, lessons, branch                 |
| `/health`         | Full system health check                   | ✅/❌ per component                             |
| `/status`         | Branch, uncommitted changes, open todos    | One-glance project state                        |
| `/test`           | Run test suite and report failures         | Scope-aware                                     |
| `/build`          | Build project, report failures             | Side-effect safe                                |
| `/lint`           | Lint and optionally auto-fix               | Formatter-aware                                 |
| `/generate-tests` | TDD-first test generation                  | Test before implementation                      |
| `/caveman`        | Think out loud before coding (hard gate)   | Blocks code generation until reasoned           |
| `/maintain`       | Detect stale docs, fix cross-references    | Full maintenance cycle                          |
| `/checkpoint`     | Save progress, commit, prepare for handoff | Pre-fetches branch + task state                 |
| + 23 more         | See `.github/prompts/` for all 38          |                                                 |

### 🤖 Agents — `.github/agents/` (5 files)

5 specialized agents invoked with `@agent-name`. Each runs in an **isolated context window** — research doesn't pollute your main conversation:

| Agent               | Model  | What it does                                                                      | Max turns |
| ------------------- | :----: | :-------------------------------------------------------------------------------- | :-------: |
| `@reviewer`         |  Opus  | 10-point code review: cross-layer consistency, transaction safety, test coverage  |    30     |
| `@researcher`       | Sonnet | Read-only codebase exploration — explores 20+ files without touching your context |    20     |
| `@plan-challenger`  |  Opus  | Adversarial plan review: 5 attack dimensions + self-refutation                    |    20     |
| `@security-auditor` |  Opus  | 6-category security scan: secrets, auth, input validation, deps, data handling    |    20     |
| `@session-reviewer` | Sonnet | Extract lessons from session patterns; feed to `lessons.md` + `COPILOT_ERRORS.md` |    15     |

### 🪝 Hooks — `.github/hooks/` (7 files)

7 lifecycle hooks that execute shell commands automatically — zero AI tokens, deterministic protection:

| Hook                      | Event        | What it does                                                    | ⏱️  |
| ------------------------- | ------------ | --------------------------------------------------------------- | :-: |
| `session-context.json`    | SessionStart | Injects branch, open todos, lessons, recent commits             | 10s |
| `terminal-safety.json`    | PreToolUse   | Blocks pagers, `vi`, unbounded output — 3 profiles              | 5s  |
| `config-protection.json`  | PreToolUse   | Warns before editing `tsconfig.json`, `.eslintrc`, `biome.json` | 5s  |
| `pre-commit-quality.json` | PreToolUse   | Catches `debugger`, secrets, `console.log` in staged files      | 30s |
| `quality-gate.json`       | Stop         | 6-item exit checklist nudge before yielding                     | 5s  |
| `subagent-stop.json`      | SubagentStop | Nudges lessons + error capture after every subagent run         | 5s  |
| `pre-compact.json`        | PreCompact   | Saves branch, open todos, uncommitted files before compaction   | 10s |

> 🛡️ **Hooks are not suggestions — they're enforcement.** A blocked action returns an error message explaining what to do instead.

### 🎓 Skills — `.github/skills/` (18 dirs)

18 skills loaded on-demand when relevant. Mention a skill by name in chat to activate it:

| Skill                   | Activates             | What it enforces                                   |
| :---------------------- | :-------------------- | :------------------------------------------------- |
| `tdd`                   | On test files         | 3-phase: Explore → Plan → Act, test-first always   |
| `root-cause-trace`      | On-demand             | Iron Law: no fix without root cause                |
| `brainstorming`         | On-demand             | Hard gate — no code without structured analysis    |
| `careful`               | On-demand             | Blocks destructive ops until explicit confirmation |
| `cross-layer-check`     | On-demand             | New fields must be consistent across all layers    |
| `changelog`             | On-demand             | Keep a Changelog format, user-facing descriptions  |
| `codebase-memory`       | On-demand             | Live structural graph — 120× fewer tokens vs reads |
| `cocoindex-code`        | On-demand             | Semantic search — find code by meaning, not names  |
| `code-review-graph`     | On-demand             | Risk score 0–100, blast radius, breaking changes   |
| `serena`                | On-demand             | LSP rename/move/inline across entire codebase      |
| `playwright`            | On-demand             | Browser automation — navigate, click, fill, snap   |
| `codeburn`              | On-demand             | Token cost observability by task type and model    |
| `receiving-code-review` | On-demand             | Triage, fix, respond to review comments            |
| `writing-skills`        | On-demand             | Clear, evidence-based technical writing            |
| + 4 more                | See `.github/skills/` |                                                    |

### 📖 Instructions — `.github/instructions/` (9 files)

9 instruction files auto-loaded per file type. These enforce hard coding standards — they fire even without `/plan` or `/review`:

| File                              | Applies to                                | Key rules                                            |
| --------------------------------- | ----------------------------------------- | ---------------------------------------------------- |
| `general.instructions.md`         | All files (`**/*`)                        | Match existing conventions; comment WHY not WHAT     |
| `terminal-safety.instructions.md` | Shell scripts (`**/*.{sh,bash}`)          | Always `set -euo pipefail`, quote variables          |
| `quality-gates.instructions.md`   | All files (`**/*`)                        | 50 lines/fn, 4 params, 400 lines/file                |
| `typescript.instructions.md`      | `*.ts`, `*.tsx`, `tsconfig.json`          | Strict mode, Zod at boundaries, no barrel re-exports |
| `nodejs-backend.instructions.md`  | `routes/`, `controllers/`, `src/`, `api/` | Repository pattern, typed routes, async middleware   |
| `react.instructions.md`           | `*.tsx`, `*.jsx`, `src/components/`       | TanStack Query, stable keys, custom hook extraction  |
| `python.instructions.md`          | `*.py`                                    | Type hints, Pydantic, pytest, ruff                   |
| `testing.instructions.md`         | `*.test.*`, `*.spec.*`                    | Test behavior not implementation; cover all branches |
| `_template.instructions.md`       | _(template)_                              | Copy → set `applyTo:` → customize                    |

---

## 🔬 Deep Dives

### 🔄 Bootstrap: How It Actually Works

The bootstrap runs in **5 optimized phases**. Scripts handle the grunt work; Copilot focuses on what requires reasoning.

#### Phase 1: Discovery (~2s) 🔍

Runs `context/scripts/discover.sh` — detects:

- Existing config → chooses **FRESH** or **UPGRADE** mode
- Languages (25+), package manager, runtime, formatter, linter
- Test framework, DB, CI system
- Derives build/test/lint/serve commands

> 🆕 **FRESH mode** — no existing config → install everything from template  
> ♻️ **UPGRADE mode** — existing config detected → smart merge, preserve your stuff

#### Phase 2: Smart Merge (UPGRADE only) 🔀

Your stuff is **sacred**:

| What                      | Strategy        | Guarantee                              |
| :------------------------ | :-------------- | :------------------------------------- |
| `lessons.md`              | **NEVER TOUCH** | Your accumulated wisdom is untouchable |
| `todo.md`                 | **NEVER TOUCH** | Your active task state is untouchable  |
| Domain docs               | **PRESERVE**    | Your knowledge stays intact            |
| Prompts, hooks            | **ADD MISSING** | Your files kept, new ones added        |
| `copilot-instructions.md` | **ENHANCE**     | Missing sections appended with markers |

#### Phase 3: Template Population (~3s mechanical + ~1-2m creative) 📝

**Step 1 — Mechanical** (`populate-templates.sh`):
Reads discovery output → replaces 70+ `{{PLACEHOLDER}}` values across all files.

**Step 2 — Creative** (Copilot reasoning, **adaptive depth**):
Fills what machines can't: architecture docs, domain analysis, critical patterns specific to _your_ codebase.

Runs **8 domain-detection greps** to identify domains present in the codebase:

| Domain grep detects                | → Creates                                         |
| :--------------------------------- | :------------------------------------------------ |
| Kafka / RabbitMQ / SQS / NATS      | `context/messaging.md` + messaging instructions   |
| Knex / DataSource / multi-DB       | `context/database.md` + database instructions     |
| StatusEnum / state machine         | `context/lifecycle.md` + lifecycle instructions   |
| Keycloak / Auth0 / JWT             | `context/auth.md` + auth instructions             |
| Webhook delivery / idempotent      | `context/webhooks.md` + webhooks instructions     |
| Adapter factory / integrations     | `context/adapters.md` + adapters instructions     |
| Report / analytics / XSLT          | `context/reporting.md` + reporting instructions   |
| Signup / registration / onboarding | `context/enrollment.md` + enrollment instructions |

#### Phase 4: MCP Tool Suggestions 🔌

Copilot scans the discovery output and adds **MCP suggestions** to the final report:

- `DATABASE` detected → suggest `postgres` or `mysql` MCP server
- CI/GitHub detected → suggest `github` MCP server
- Web frontend detected → suggest `playwright` MCP server

Configure via `.mcp.json`: `{ "mcpServers": { "server-name": { "command": "uvx", "args": [...] } } }`

#### Phase 5: Validate + Report 🧹

Runs `bash validate.sh`:

- ✅ 100+ validation checks
- 🔍 Detects remaining `{{PLACEHOLDER}}` values
- Reports installed vs. preserved components

---

### 🪝 How Hooks Work

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

The installer detects existing `context/` docs and skips them to preserve your customizations.

---

## 📌 Placeholder Reference

After installation, run `/bootstrap` in Copilot Chat to fill these placeholders. Most are filled automatically by `populate-templates.sh`; the starred ones ★ require Copilot reasoning:

| Placeholder                |      Filled by      | Example                                   |
| :------------------------- | :-----------------: | :---------------------------------------- |
| `{{PROJECT_NAME}}`         |       script        | `my-api`                                  |
| `{{LANGUAGE}}`             |       script        | `TypeScript`, `Python`, `Go`              |
| `{{RUNTIME}}`              |       script        | `Node 22`, `Python 3.12`, `Go 1.22`       |
| `{{PACKAGE_MANAGER}}`      |       script        | `npm`, `pnpm`, `yarn`, `pip`, `uv`        |
| `{{FORMATTER}}`            |       script        | `prettier`, `ruff`, `gofmt`, `biome`      |
| `{{LINTER}}`               |       script        | `eslint`, `pylint`, `golangci-lint`       |
| `{{TEST_FRAMEWORK}}`       |       script        | `jest`, `vitest`, `pytest`, `go test`     |
| `{{BUILD_COMMAND}}`        |       script        | `npm run build`, `python -m build`        |
| `{{TEST_COMMAND}}`         |       script        | `npm test`, `pytest -v`, `go test ./...`  |
| `{{LINT_COMMAND}}`         |       script        | `npm run lint`, `ruff check .`            |
| `{{CI_SYSTEM}}`            |       script        | `GitHub Actions`, `GitLab CI`, `CircleCI` |
| `{{DATABASE}}`             |       script        | `PostgreSQL`, `MySQL`, `MongoDB`          |
| `{{ARCHITECTURE_SUMMARY}}` |      ★ Copilot      | `Monorepo: api/ + web/, event-sourced`    |
| `{{ARCHITECTURE_DIAGRAM}}` |      ★ Copilot      | ASCII/mermaid component diagram           |
| `{{KEY_DOMAIN_ENTITIES}}`  |      ★ Copilot      | `User, Order, Product, Invoice`           |
| `{{CRITICAL_PATTERNS}}`    |      ★ Copilot      | `Never bypass AuthMiddleware`             |
| `{{TECH_STACK}}`           |      ★ Copilot      | `NestJS + Prisma + Postgres + Redis`      |
| `{{CODING_STANDARDS}}`     |      ★ Copilot      | Project-specific rules beyond defaults    |
| `{{LAYER_DIAGRAM}}`        |      ★ Copilot      | Controller → Service → Repository diagram |
| `{{NAMING_CONVENTIONS}}`   |      ★ Copilot      | `camelCase vars, PascalCase types`        |
| `{{API_CONVENTIONS}}`      |      ★ Copilot      | REST vs GraphQL, versioning strategy      |
| `{{COMMON_PITFALLS}}`      |      ★ Copilot      | Project-specific anti-patterns            |
| `{{BUILD_NOTES}}`          |      ★ Copilot      | Special steps, env vars required          |
| `{{TEST_NOTES}}`           |      ★ Copilot      | Test data setup, mocking strategy         |
| `{{MR_CHECKLIST}}`         |      ★ Copilot      | Extra items beyond default checklist      |
| `{{COMMIT_EXAMPLES}}`      |      ★ Copilot      | Sample good commit messages               |
| `{{UPGRADE_NOTES}}`        |      ★ Copilot      | What changed in this bootstrap version    |
| `{{DOMAIN_CONTEXT}}`       |      ★ Copilot      | Business domain overview                  |
| `{{MESSAGING_SYSTEM}}`     |  script (if found)  | `Kafka`, `RabbitMQ`, `SQS`                |
| `{{AUTH_PROVIDER}}`        |  script (if found)  | `Keycloak`, `Auth0`, `JWT`                |
| `{{REPO_YEAR}}`            |       script        | `2024`                                    |
| `{{MAINTAINER}}`           | script (git config) | `Your Name`                               |

> Run `grep -r '{{' context/ .github/` after bootstrap to find any remaining unfilled placeholders.

---

## 📐 Best Practices

| Category                  | Rule                                           | Why                                                     |
| :------------------------ | :--------------------------------------------- | :------------------------------------------------------ |
| Context docs              | Keep `architecture.md` under 200 lines         | Loaded on-demand — concise beats comprehensive          |
| `lessons.md`              | Max 50 lessons — prune old ones quarterly      | Too many lessons = too slow to scan                     |
| `todo.md`                 | Max 10 active tasks — move done items to DONE  | Focus beats completeness                                |
| Hooks                     | Keep each hook under 30s total timeout         | Hooks block AI action — slow hooks = slow AI            |
| Instructions              | One instruction file per tech domain           | Avoids conflicts; makes enable/disable easy             |
| Skills                    | Include 3+ concrete examples in every SKILL.md | AI follows examples better than abstract rules          |
| `copilot-instructions.md` | Under 4KB total                                | Budget is limited — prioritize the most impactful rules |
| MCP tools                 | Only install tools you actually use            | More tools = more token overhead in every call          |
| Context `_examples/`      | Delete after using as templates                | Example files in production context confuse the AI      |

---

## 🔌 MCP Plugin Ecosystem

Five VS Code-compatible MCP tools extend Copilot's capabilities beyond text reasoning:

```json
{
  "mcpServers": {
    "cocoindex-code": {
      "command": "uvx",
      "args": ["cocoindex-code-mcp-server@latest", "--project-root", "."]
    },
    "serena": {
      "command": "uvx",
      "args": ["serena@latest", "--workspace", "."]
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

| Tool                    | What it gives Copilot                                  | Best for                   | Install requires |
| :---------------------- | :----------------------------------------------------- | :------------------------- | :--------------- |
| **cocoindex-code**      | Semantic code search — find by meaning, not file name  | Large codebases, refactors | Python + `uvx`   |
| **codebase-memory-mcp** | Structural graph — 120× fewer tokens than full reads   | Architecture questions     | curl binary      |
| **code-review-graph**   | Risk score, blast radius, breaking changes             | Pre-merge safety checks    | Python           |
| **serena**              | LSP rename/move/inline — whole-codebase precision      | Safe renaming, refactoring | `uvx`            |
| **playwright**          | Browser automation — navigate, click, fill, screenshot | E2E testing, web scraping  | Node.js 18+      |

Add to `.mcp.json` → restart VS Code → tool appears automatically in Copilot agent sessions.

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

Copy `context/_examples/api-domain.md` as a starting point.  
Save your version to `context/domain/my-api.md` and reference it from `.github/copilot-instructions.md`.

---

## ❓ FAQ

**Q: Why is there a `context/` folder in a Copilot repo?**  
A: Copilot reads the same `context/` knowledge docs as Claude Code. This makes the repo dual-compatible — one knowledge base, two AI tools. The `context/` docs contain your architecture, rules, and task state.

**Q: What's the difference between a skill and a prompt?**  
A: Prompts (`.prompt.md`) are slash commands you invoke explicitly. Skills (`.github/skills/`) are capabilities the AI loads automatically when relevant — or on demand by name. Skills can include scripts and resources; prompts are instructions only.

**Q: Do hooks slow down Copilot?**  
A: Each hook has a configurable timeout (default 30s). Simple hooks (terminal safety check) take <100ms. Heavy hooks (quality gate script) take 1-3s. Hooks run sequentially within an event — keep timeouts short.

**Q: Can I use this with Claude Code too?**  
A: Yes. The `context/` knowledge layer is shared. Claude Code uses `.claude/` for commands and hooks (separate from `.github/`). Run both setups — they share the knowledge docs without conflicts.

**Q: How do I disable a hook?**  
A: Delete or rename the `.json` file in `.github/hooks/`. Or set `chat.hookFilesLocations` in VS Code settings to exclude specific hook files.

**Q: What's the minimum VS Code version for hooks?**  
A: Hooks require VS Code with GitHub Copilot Chat extension. Agent hooks are in Preview — check the VS Code release notes for the minimum version.

**Q: How do I check which placeholders are still unfilled?**  
A: Run `grep -r '{{' context/ .github/ | grep -v '_examples'` from the repo root.

**Q: Does `/bootstrap` overwrite my existing `lessons.md`?**  
A: Never. `lessons.md` and `todo.md` are the two files that are **always preserved** regardless of mode (FRESH or UPGRADE). This is enforced in the installer code.

**Q: Can I add my own slash commands?**  
A: Yes — create a `.prompt.md` file in `.github/prompts/`. Add YAML frontmatter with `mode: agent` (or `chat`/`edit`) and a `description:`. It appears in the `/` menu immediately.
