# Changelog

All notable changes to Copilot Brain Bootstrap will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-04-24

### Added

#### Core Configuration

- **`.github/copilot-instructions.md`** — master system prompt injected automatically by Copilot into every session; includes model selection guidance, golden rules, exit checklist, and terminal safety reference

#### Agents (5)

- **`@reviewer`** — 10-point code review: cross-layer consistency, transaction safety, enum completeness, test coverage; runs in isolated context window
- **`@researcher`** — read-only codebase exploration subagent; explores 20+ files without polluting main conversation context
- **`@plan-challenger`** — adversarial plan review across 5 dimensions with self-refutation to eliminate false positives
- **`@security-auditor`** — 6-category security scan: secrets, auth, input validation, dependencies, data handling, compliance
- **`@session-reviewer`** — detects recurring frustrations and corrections; feeds findings to `COPILOT_ERRORS.md` and `lessons.md`

#### Lifecycle Hooks (7)

- **`session-context`** — `SessionStart`: injects current branch, open todos, accumulated lessons, recent commits
- **`terminal-safety`** — `PreToolUse`: blocks pagers (`less`, `more`, `man`), interactive editors (`vi`, `nano`), unbounded output; 3 strictness profiles
- **`config-protection`** — `PreToolUse`: warns before editing `tsconfig.json`, `.eslintrc`, `biome.json`, and other IDE config files
- **`pre-commit-quality`** — `PreToolUse`: catches `debugger`, secret patterns, and `console.log` in staged files before commit
- **`quality-gate`** — `Stop`: 6-item exit checklist nudge before Copilot yields control
- **`subagent-stop`** — `SubagentStop`: nudges lessons capture and error logging after every subagent run
- **`pre-compact`** — `PreCompact`: saves branch state, open todos, and uncommitted files before context compaction

#### Slash Commands / Prompts (38)

- Full development lifecycle coverage: `/plan`, `/review`, `/debug`, `/mr`, `/test`, `/build`, `/lint`, `/checkpoint`, `/resume`, `/health`, `/status`, `/bootstrap`, `/caveman`, `/maintain`, `/generate-tests`, and 23 more
- All prompts include proper YAML frontmatter with `mode:`, `tools:`, and `description:` fields

#### Skills (18)

- **`tdd`** — 3-phase test-driven development: Explore → Plan → Act; test-first gate
- **`root-cause-trace`** — Iron Law enforcement: no fix without stated root cause
- **`brainstorming`** — hard gate before implementation; forces structured option analysis
- **`careful`** — explicit confirmation gate for destructive operations
- **`cross-layer-check`** — consistency enforcement across DB → service → DTO → API → tests
- **`changelog`** — Keep a Changelog format with user-facing descriptions
- **`codebase-memory`** — live structural graph via MCP; 120× fewer tokens than file reads
- **`cocoindex-code`** — semantic search via local vector embeddings
- **`code-review-graph`** — risk score 0–100, blast radius, breaking change detection
- **`serena`** — LSP rename/move/inline across entire codebase
- **`playwright`** — browser automation via MCP: navigate, click, fill, screenshot
- Plus 7 more: `codeburn`, `receiving-code-review`, `writing-skills`, `issue-triage`, `pr-triage`, `repo-recap`, `subagent-driven-development`

#### Instruction Files (9)

- **`general`** — applies to all files: match conventions, comment WHY not WHAT
- **`quality-gates`** — applies to all files: 50 lines/fn, 4 params, 400 lines/file, complexity ≤15
- **`terminal-safety`** — applies to shell scripts: `set -euo pipefail`, quote variables
- **`typescript`** — strict mode, Zod at boundaries, no barrel re-exports
- **`nodejs-backend`** — repository pattern, typed routes, async middleware
- **`react`** — TanStack Query, stable keys, custom hook extraction
- **`python`** — type hints, Pydantic, pytest, ruff
- **`testing`** — test behavior not implementation; cover all branches
- **`_template`** — starter template: copy → set `applyTo:` → customize

#### Knowledge Layer (`context/`)

- **`architecture.md`** — service catalog, workspace layout, infrastructure map
- **`rules.md`** — 14 non-negotiable working standards
- **`build.md`** — build, test, lint, CI commands reference
- **`templates.md`** — MR/PR and commit message templates
- **`terminal-safety.md`** — terminal safety reference: pipes, pagers, interactive programs
- **`cve-policy.md`** — dependency vulnerability response process
- **`decisions.md`** — architectural decisions record (ADR-lite)
- **`plugins.md`** — MCP plugin documentation and configuration
- **`tasks/todo.md`** — current task state, updated every session
- **`tasks/lessons.md`** — accumulated wisdom from past sessions
- **`tasks/COPILOT_ERRORS.md`** — recurring mistake tracker with promotion lifecycle
- **`_examples/`** — three worked domain examples (API, database, messaging) to use as templates

#### Installer & Validation

- **`install.sh`** — smart fresh/upgrade installer; detects existing config, preserves `lessons.md` and `todo.md` always, smart-merges everything else
- **`validate.sh`** — 100+ post-install checks with ✅/❌ reporting; detects remaining `{{PLACEHOLDER}}` values
- **CI pipeline** — validate on Ubuntu, macOS, Windows + shellcheck on all shell scripts
