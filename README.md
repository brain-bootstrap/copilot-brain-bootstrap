<p align="center">
  <a href="https://github.com/brain-bootstrap/copilot-brain-bootstrap">
    <img src="https://img.shields.io/badge/ᗺB-Brain%20Bootstrap-6e40c9?style=for-the-badge&labelColor=1a0a3e" alt="ᗺB Brain Bootstrap" />
  </a>
</p>

<h1 align="center">ᗺB - Brain Bootstrap for GitHub Copilot</h1>
<p align="center"><em>Your AI coding assistant is brilliant.<br>It just forgets everything, ignores your rules, and breaks your conventions.<br><strong>Brain doesn't hope Copilot behaves — it makes it. Permanently.</strong></em></p>
<p align="center"><sub>by <a href="https://github.com/y-abs">y-abs</a> · no third-party installs without your explicit approval</sub></p>
<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://github.com/brain-bootstrap/copilot-brain-bootstrap/actions/workflows/ci.yml"><img src="https://github.com/brain-bootstrap/copilot-brain-bootstrap/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="#"><img src="https://img.shields.io/badge/GitHub_Copilot-Ready-6e40c9?logo=github" alt="GitHub Copilot"></a>
  <a href="#-write-once-read-everywhere"><img src="https://img.shields.io/badge/Any_AI_Tool-Knowledge_Portable-ff6f00" alt="Knowledge Portable"></a>
</p>

<p align="center">
  <a href="#-what-this-is">What This Is</a> &nbsp;·&nbsp;
  <a href="#-not-suggestions--guarantees">Guarantees</a> &nbsp;·&nbsp;
  <a href="#-what-changes-when-you-add-a-brain">Before & After</a> &nbsp;·&nbsp;
  <a href="#-get-started-in-5-minutes">5 Min Setup</a> &nbsp;·&nbsp;
  <a href="#-how-it-works-under-the-hood">Under the Hood</a> &nbsp;·&nbsp;
  <a href="#-whats-inside">What's Inside</a> &nbsp;·&nbsp;
  <a href="#-it-gets-smarter-over-time">Gets Smarter</a> &nbsp;·&nbsp;
  <a href="#-safety-defense-in-depth">Guardrails</a> &nbsp;·&nbsp;
  <a href="#-plugin-ecosystem">Superpowers</a> &nbsp;·&nbsp;
  <a href="#-make-it-yours">Make It Yours</a> &nbsp;·&nbsp;
  <a href="#-faq">FAQ</a> &nbsp;·&nbsp;
  <a href="#-contributing">Contribute</a>
</p>

---

## 💡 What This Is

**Brain Bootstrap is a project configuration template — a ready-made `.github/` folder you install once into your repo. It gives GitHub Copilot persistent memory, enforced guardrails, and 38 ready-to-use prompts so your AI assistant finally knows your project and stops repeating the same mistakes every session.**

---

**The problem it solves:**

You ask Copilot to add a feature. It uses `npm run build` — but you use `yarn turbo build`. It installs `date-fns` even though `@company/utils` already has `formatDate()`. It edits `tsconfig.json` to silence a type error — the file you explicitly said never to touch.

You add a `.github/copilot-instructions.md`. You correct it. It apologizes. Next session: same mistakes.

Copilot is stateless by design — each session starts blank. So you end up re-explaining your stack, re-enforcing the same rules, re-correcting the same errors. Every. Single. Session. **You become the AI's memory.**

---

**What Brain Bootstrap gives you instead:**

- **Persistent memory** — conventions, architecture, past mistakes embedded once and never forgotten
- **Enforced rules** — 7 lifecycle hooks that block violations _before_ they run, no AI judgment involved
- **Ready-to-use workflows** — 38 prompt files, 18 skills, 5 specialist agents covering every common task
- **Self-updating knowledge** — the knowledge layer grows with your codebase, session by session

**Install once. Correct once. It never happens again.**

---

## 🔒 Not Suggestions — Guarantees

Every other instruction system hopes the AI complies. Brain doesn't hope — it **enforces**.

Corrections become permanent rules. Forbidden patterns get blocked _before_ they run — by deterministic bash scripts, not AI judgment. The knowledge base updates itself as your codebase evolves. The same mistake cannot happen twice.

**You stop babysitting — Copilot just knows.**

---

## ✨ What Changes When You Add a Brain

Every AI coding tool reads instructions. None of them enforce those instructions on themselves. You write _"never edit tsconfig.json"_ — it edits `tsconfig.json` anyway. You correct it — same mistake next session.

**Instructions are text. Text is advisory. Advisory gets overridden.** Brain replaces text with mechanisms — hooks that block before execution, memory that persists across sessions, knowledge that stays current:

| 🔁 Every session today                                                                             | 🧠 With Brain — once, forever                                                                                                 |
| :------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| You repeat your conventions every session — package manager, build commands, code style            | Knows your entire toolchain from day one — conventions are documented, not repeated                                           |
| You re-explain your architecture after every context reset                                         | `context/architecture.md` is auto-loaded on session start — survives restarts, everything                                     |
| You correct a mistake, it apologizes, then does it again tomorrow                                  | Corrections are captured in `context/tasks/lessons.md` — read at every session start, never repeated                          |
| Copilot modifies config files to "fix" issues — linter settings, compiler configs, toolchain files | **Config protection** hook blocks edits to any protected file — forces fixing source code, not bypassing the toolchain        |
| A command opens a pager, launches an editor, or dumps unbounded output — VS Code terminal hangs    | **Terminal safety** hook intercepts dangerous patterns before they execute — pagers, `vi`, unbounded output, all blocked      |
| Code reviews vary wildly depending on how you prompted                                             | `/review` runs a consistent 10-point protocol every time — same rigor, zero prompt engineering                                |
| Research eats your main context window and you lose track                                          | `@researcher` subagent explores in an **isolated** context — your main window stays clean                                     |
| Knowledge docs slowly rot as the code evolves                                                      | Self-maintenance rule + `/maintain` command detect drift and fix stale references automatically                               |
| You push a PR and discover too late that your change broke 14 other files                          | **code-review-graph** skill scores every diff 0–100 before you push — blast radius, breaking changes, risk verdict in seconds |

**After a few sessions, Copilot will know things about your codebase that even some team members don't.**

---

> 🎯 **100+ files isn't complexity. It's the minimum architecture where instructions become guarantees.**

---

## 🚀 Get Started in 5 Minutes

### Step 1 — Install the template

**Prerequisites:** `git`, `bash` ≥ 3.2, `jq` ([install jq](https://jqlang.github.io/jq/download/) — `brew install jq` / `apt install jq`).

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

The `/bootstrap` prompt runs the discovery engine, detects your entire stack, fills 70+ placeholders, then has Copilot write architecture docs and domain knowledge specific to your codebase. Fully automated, ~5 minutes.

### Step 3 — Verify

```
/health
```

Confirms all hooks, agents, skills, and instructions are wired up correctly. Returns ✅/❌ per check.

---

## 📦 What's Inside

| Category                 | Count | Description                                                         |
| :----------------------- | :---: | :------------------------------------------------------------------ |
| 📋 **Prompts** (`/name`) |  38   | Slash commands for every task in the dev lifecycle                  |
| 🤖 **Agents** (`@name`)  |   5   | Specialized expert agents for review, research, security            |
| 🎓 **Skills**            |  18   | Auto-activating or on-demand specialist behaviors                   |
| 🪝 **Hooks**             |   7   | Lifecycle automation: session context, safety gates, quality checks |
| 📖 **Instructions**      |   9   | Path-specific coding standards (TS, React, Node.js, Python, etc.)   |
| 📚 **Knowledge docs**    |   9   | Persistent project memory in `context/`                             |

---

## 🧠 How It Works Under the Hood

Copilot Brain Bootstrap is **100+ files** of structured configuration that live in your repo, version-controlled alongside your code. It's not a wrapper, not a plugin, not a SaaS product — it's **a knowledge architecture** that teaches GitHub Copilot how your project actually works.

```
your-repo/
├── 📋 .github/copilot-instructions.md    ← Always injected by Copilot (<4KB)
├── 🤖 .github/agents/
│   ├── reviewer.agent.md                 ← @reviewer — 10-point code review
│   ├── researcher.agent.md               ← @researcher — read-only exploration
│   ├── plan-challenger.agent.md          ← @plan-challenger — adversarial review
│   ├── security-auditor.agent.md         ← @security-auditor — 6-category scan
│   └── session-reviewer.agent.md         ← @session-reviewer — extract lessons
├── 🪝 .github/hooks/
│   ├── session-context.json              ← SessionStart: inject branch + todos + lessons
│   ├── terminal-safety.json              ← PreToolUse: block pager/interactive/destructive
│   ├── config-protection.json            ← PreToolUse: warn on config file edits
│   ├── pre-commit-quality.json           ← PreToolUse: scan staged files for secrets
│   ├── quality-gate.json                 ← Stop: exit checklist nudge
│   ├── subagent-stop.json                ← SubagentStop: capture lessons + errors
│   ├── pre-compact.json                  ← PreCompact: save state before compaction
│   └── scripts/                          ← Deterministic bash — zero AI tokens
├── 📋 .github/prompts/                   ← 38 slash commands
│   ├── bootstrap.prompt.md               ← /bootstrap — autonomous project setup
│   ├── plan.prompt.md                    ← /plan — checkable todo list + risk analysis
│   ├── debug.prompt.md                   ← /debug — root cause first, always
│   ├── review.prompt.md                  ← /review — 10-point code review
│   ├── mr.prompt.md                      ← /mr — MR description after build passes
│   └── ...33 more
├── 🎓 .github/skills/                    ← 18 specialist behaviors
│   ├── tdd/SKILL.md                      ← Auto-activates on test files
│   ├── root-cause-trace/                 ← Iron Law: no fix without root cause
│   ├── brainstorming/                    ← Hard gate before any code
│   ├── careful/                          ← Extra confirmation for destructive ops
│   ├── cross-layer-check/                ← New fields consistent across all layers
│   ├── codeburn/                         ← Token cost observability
│   └── ...12 more
├── 📖 .github/instructions/              ← 9 path-scoped coding standards
│   ├── general.instructions.md           ← Applies to all files
│   ├── quality-gates.instructions.md     ← Lines/params/nesting limits
│   ├── typescript.instructions.md        ← Strict mode, Zod, interfaces
│   ├── nodejs-backend.instructions.md    ← Routes, repos, HTTP codes
│   ├── react.instructions.md             ← Hooks, TanStack Query, stable keys
│   ├── python.instructions.md            ← Type hints, Pydantic, pytest
│   └── testing.instructions.md           ← Applies to test files only
└── 📚 context/                           ← Persistent knowledge — updated once, read everywhere
    ├── architecture.md                   ← Service catalog + workspace layout
    ├── rules.md                          ← 14 non-negotiable working standards
    ├── build.md                          ← Build/test/lint/CI commands
    ├── templates.md                      ← MR/PR and ticket templates
    ├── terminal-safety.md                ← Terminal anti-patterns reference
    ├── cve-policy.md                     ← Dependency security decision tree
    ├── decisions.md                      ← Architectural decisions record (ADR)
    ├── plugins.md                        ← Active plugins and integration notes
    └── tasks/
        ├── todo.md                       ← 📝 Current task plan (survives session boundaries)
        ├── lessons.md                    ← 🧠 Accumulated wisdom (injected every session)
        └── COPILOT_ERRORS.md             ← 🐛 Recurring mistakes → promotes to rules at 3+
```

**Write your knowledge once. Every AI tool reads it.** ✍️

Because it lives in your repo, it's version-controlled, PR-reviewed, and shared across your team — no SaaS account, no sync, no drift.

### 🎯 The Three-Layer Context Strategy

The system minimizes token cost while maximizing context — Copilot doesn't drown in 50K tokens when you ask it to fix a typo:

| Layer                | What                                                              | When loaded               |     Cost     |
| :------------------- | :---------------------------------------------------------------- | :------------------------ | :----------: |
| 🟢 **Always on**     | `copilot-instructions.md` — operating protocol, critical patterns | Every session             | ~3-4K tokens |
| 🟡 **Auto-injected** | `todo.md` + `lessons.md` + git status — via session-start hook    | Every session start       | ~1-2K tokens |
| 🔵 **On-demand**     | Full domain docs — architecture, build, auth, database            | When the task requires it |  ~1-2K each  |

---

## 🔄 It Gets Smarter Over Time

This isn't a static config that rots. It's a **living system** with five feedback loops:

1. 📋 **Exit checklist** — captures corrections at the end of every turn, so they stick
2. 🧠 **`lessons.md`** — accumulated wisdom, injected at every session start — impossible to skip
3. 🐛 **Error promotion** — same mistake 3 times? Becomes a permanent rule in `COPILOT_ERRORS.md`
4. 🔁 **Session hooks** — context survives restarts and compaction — nothing gets lost
5. 🔍 **`/maintain`** — audits all docs for stale paths, dead references, drift from reality

---

## 🛡️ Safety: Defense in Depth

Security isn't one mechanism — it's **two layers** working together:

### 🪝 Layer 1: Hooks — What Gets Intercepted at Runtime

7 lifecycle hooks add runtime guardrails — deterministic bash scripts, zero tokens, zero AI reasoning:

| Hook                     | What it prevents                                                                                      |
| :----------------------- | :---------------------------------------------------------------------------------------------------- |
| 🚧 **Terminal safety**   | Blocks `vi`/`nano`, pagers, `docker exec -it`, unbounded output — 3 profiles: minimal/standard/strict |
| 🔒 **Config protection** | Warns before editing `tsconfig.json`, `.eslintrc`, `biome.json` — forces fixing source code instead   |
| 🧹 **Commit quality**    | Catches `debugger`, `console.log`, hardcoded secrets, `TODO FIXME` in staged files                    |
| 📦 **Pre-compact**       | Saves branch, open todos, and uncommitted files before context compaction                             |
| 🤖 **Subagent stop**     | Nudges lessons + error capture after every subagent run                                               |
| ✅ **Quality gate**      | Exit checklist nudge: uncommitted files, open todos, stale lessons                                    |
| 🌅 **Session context**   | Injects branch, open todos, recent lessons on every session start                                     |

### 🚫 Layer 2: Copilot Instructions — What the AI Can't Even Attempt

`.github/copilot-instructions.md` hard-codes the non-negotiables. Never git push autonomously. Never modify IDE config files. No fix without root cause. These aren't suggestions — they're **documented invariants** the model reads before every single interaction.

---

## 🔌 Plugin Ecosystem

Four VS Code / MCP plugins available — pick what fits your stack. Install via `/mcp` prompt:

| Tool                                                                       | Axis                                                                       |   Requires   |            Impact            |
| :------------------------------------------------------------------------- | :------------------------------------------------------------------------- | :----------: | :--------------------------: |
| **[code-review-graph](https://github.com/tirth8205/code-review-graph)**    | 🔴 Change risk analysis — risk score 0–100, blast radius, breaking changes | Python 3.10+ |      Pre-PR safety gate      |
| **[codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp)** | 🔍 Live structural graph — call traces, dead code, Cypher queries          |     curl     |  Fewer tokens vs file reads  |
| **[cocoindex-code](https://github.com/cocoindex-io/cocoindex-code)**       | 🔎 Semantic search — find code by meaning via local vector embeddings      | Python 3.11+ |    Finds what grep misses    |
| **[serena](https://github.com/oraios/serena)**                             | 🔧 LSP symbol refactoring — rename/move across entire codebase atomically  | uvx + Python | Atomic multi-file transforms |

> 📚 **Full plugin reference:** [context/plugins.md](context/plugins.md)

---

## 🔀 Write Once, Read Everywhere

| Tool               | What it reads                                       |           Depth           |
| :----------------- | :-------------------------------------------------- | :-----------------------: |
| **GitHub Copilot** | `copilot-instructions.md` + `.github/` + `context/` |       🟢 Everything       |
| **Claude Code**    | `context/*.md` as domain knowledge                  |    🟡 Knowledge layer     |
| **Codex / Cursor** | `context/*.md` — plain Markdown, zero setup         | 🔵 Drop-in knowledge base |

Subagents declare their preferred model (`Claude Opus 4` or `GPT-4o`). Falls back gracefully to whatever you're running.

---

## ⚙️ Make It Yours

Extending the Brain is simple — one file, one registration:

| To add…             | Create…                                           | Registration                                  |
| :------------------ | :------------------------------------------------ | :-------------------------------------------- |
| 📚 Domain knowledge | `context/<domain>.md`                             | Add to `copilot-instructions.md` lookup table |
| 🎓 Skill            | `.github/skills/<name>/SKILL.md`                  | Automatic (Copilot discovers by directory)    |
| 🪝 Lifecycle hook   | `.github/hooks/<name>.json` + `scripts/<name>.sh` | Automatic (loaded by VS Code)                 |
| 🤖 AI agent         | `.github/agents/<name>.agent.md`                  | Automatic (invocable via `@name`)             |

Three worked examples in `context/_examples/` — API domain, database domain, messaging domain.

### Personal override

Copy `.copilot-instructions.local.md.example` → `.copilot-instructions.local.md` (gitignored) for personal instructions that don't belong in the shared `copilot-instructions.md`.

---

## 📋 The Prompts

Type `/` in Copilot Chat to see all 38 available prompts.

| Prompt            | What it does                                                     |
| :---------------- | :--------------------------------------------------------------- |
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
| `/status`         | Branch, uncommitted changes, open todos                          |
| `/generate-tests` | TDD-first test generation                                        |
| `/caveman`        | Think out loud before coding (hard gate)                         |
| `/maintain`       | Detect stale docs, fix cross-references                          |
| + 23 more         | See `.github/prompts/`                                           |

---

## 🤖 The Agents

Invoke with `@agent-name` in Copilot Chat.

| Agent               | What it does                                                                      |
| :------------------ | :-------------------------------------------------------------------------------- |
| `@reviewer`         | 10-point review: cross-layer consistency, transaction safety, test coverage       |
| `@researcher`       | Read-only exploration with structured findings: evidence, data flow, pitfalls     |
| `@plan-challenger`  | Adversarial plan review: 5 attack dimensions + self-refutation                    |
| `@security-auditor` | 6-category scan: secrets, auth, input validation, deps, data handling, infra      |
| `@session-reviewer` | Extract lessons from session patterns; feed to `lessons.md` + `COPILOT_ERRORS.md` |

---

## 🎓 The Skills

Skills are auto-activating or on-demand specialist behaviors. Load them by mentioning their name in chat.

| Skill                   | Activates             | What it enforces                                   |
| :---------------------- | :-------------------- | :------------------------------------------------- |
| `tdd`                   | On test files         | 3-phase: Explore → Plan → Act                      |
| `root-cause-trace`      | On-demand             | Iron Law: no fix without root cause                |
| `brainstorming`         | On-demand             | Hard gate — no code without structured analysis    |
| `careful`               | On-demand             | Blocks destructive ops until explicit confirmation |
| `cross-layer-check`     | On-demand             | New fields must be consistent across all layers    |
| `changelog`             | On-demand             | Keep a Changelog format, user-facing descriptions  |
| `receiving-code-review` | On-demand             | Triage, fix, respond to review comments            |
| `writing-skills`        | On-demand             | Clear, evidence-based technical writing            |
| + 10 more               | See `.github/skills/` |                                                    |

---

## ❓ FAQ

<details>
<summary><strong>💻 What platforms and languages are supported?</strong></summary>

**Platforms:** Linux ✅, macOS ✅, Windows ✅ (with bash via Git Bash or WSL).

**Prerequisites:** VS Code with GitHub Copilot, `git`, `bash` ≥ 3.2, `jq`. Optional: Python 3.10+ for MCP plugins.

**Languages:** Any — TypeScript, Python, Go, Rust, Java, Ruby, PHP, C#, and more. The knowledge docs are language-agnostic; stack-specific details are filled in during `/bootstrap`.

> 💡 Run `bash install.sh --check` to verify all prerequisites.

</details>

<details>
<summary><strong>🔄 I already have a copilot-instructions.md / context/ — will this overwrite it?</strong></summary>

Never. The installer detects your existing config and enters **upgrade mode** — it adds only what's missing and never touches your knowledge files. Existing files stay untouched.

</details>

<details>
<summary><strong>💰 How much does it cost in tokens?</strong></summary>

Very little. The system is cheap by default:

- **Always on:** ~3-4K tokens (`copilot-instructions.md`)
- **Auto-injected:** ~1-2K tokens (session hook: `todo.md` + `lessons.md` + git status)
- **On-demand:** ~1-2K tokens per doc (only when the task needs it)

</details>

<details>
<summary><strong>🪝 What are hooks and do I need them?</strong></summary>

Hooks are VS Code Copilot lifecycle events that fire bash scripts at key moments (session start, before/after tool use, before stopping). They're what make Brain's guarantees possible — terminal safety, config protection, exit checklist.

They're enabled automatically when VS Code loads them from `.github/hooks/`. No configuration needed.

</details>

<details>
<summary><strong>👥 Is this just for solo developers?</strong></summary>

Works great solo, but it's designed for teams. Everything is version-controlled and shared by default. The whole team gets the same Copilot behavior, the same safety hooks, the same prompts.

Not ready to share? Add `context/` to `.gitignore` and keep it local — the `.github/` system still works for everyone.

</details>

<details>
<summary><strong>⚖️ How is this different from just writing a good copilot-instructions.md?</strong></summary>

Scope. A hand-written `copilot-instructions.md` is a flat instruction file — the AI reads it _if it feels like it_. Brain is a **multi-layered enforcement architecture** with lifecycle hooks that block before execution, agents that run in isolated contexts, 18 skills that activate per task, and session memory that persists across restarts.

It's the difference between a sticky note and an operating system.

</details>

---

## ✅ Validation

```bash
bash validate.sh
```

Checks: core instruction file, knowledge layer, prompts, agents, hooks, skills, instructions, placeholder detection. Returns ✅/❌ per check.

---

## 🤝 Contributing

PRs welcome! All contributions must be **domain-agnostic** — no project-specific content.

👉 **[Full guide → CONTRIBUTING.md](CONTRIBUTING.md)** · 🐛 **[Report a bug](https://github.com/brain-bootstrap/copilot-brain-bootstrap/issues/new/choose)**

---

## 📄 License

MIT — see [LICENSE](LICENSE).

---

<p align="center">
  <em>Built by developers who were tired of re-explaining the same things to Copilot every session.</em><br>
  <sub>Part of the <a href="https://github.com/brain-bootstrap">ᗺB Brain Bootstrap</a> family — also available for <a href="https://github.com/brain-bootstrap/claude-code-brain-bootstrap">Claude Code</a> and <a href="https://github.com/brain-bootstrap/codex-brain-bootstrap">OpenAI Codex</a>.</sub>
</p>
