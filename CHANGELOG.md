# Changelog

All notable changes to Copilot Brain Bootstrap will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-04-25 — Skills Parity & Scripts Layer

### Added

#### Skills — 31 new skills (18 → 49, full parity with Codex and Claude)

- **`ask`** — route codebase questions to structural graph, semantic search, or risk analysis
- **`bootstrap`** — auto-configure copilot-instructions.md and context/ knowledge docs for a new project
- **`build`** — build the project and verify it compiles cleanly after changes
- **`checkpoint`** — save session state before context gets full; write task state to context/tasks/todo.md
- **`clean-worktrees`** — remove all git worktrees for merged branches; accepts --dry-run
- **`cleanup`** — clean workspace: build artifacts, dependencies, caches, Docker volumes, or temp files
- **`context`** — load all relevant context/ knowledge files for a domain area at session start
- **`db`** — query the database: list schemas, tables, describe a table, or run SQL
- **`debug`** — root cause analysis for bugs using 5-step investigation method
- **`deps`** — manage dependencies and fix CVEs; check outdated packages, run security audit
- **`diff`** — analyze branch diff against merge-base; stat overview, full diff, file list, commit list
- **`docker`** — Docker workflow helpers: list containers, build, run, logs, compose up/down, prune
- **`git`** — git workflow helpers: status, rebase, commit, amend, log, stash, branch management
- **`health`** — verify Copilot configuration health with pass/warn/fail per component
- **`lint`** — run the linter and formatter check before opening a PR
- **`maintain`** — detect and fix stale context/*.md knowledge docs
- **`mcp`** — manage MCP servers: list tools, check status, add a new server to mcp.json
- **`migrate`** — run database or schema migrations: up, down, rollback, status, create new migration
- **`mr`** — generate a PR/MR description after review passes
- **`plan`** — plan a non-trivial task before implementing; writes checkable plan to context/tasks/todo.md
- **`research`** — isolated codebase exploration that preserves main context; spawns explorer subagent
- **`resume`** — resume previous session from context/tasks/todo.md
- **`review`** — full 10-point expert code review; spawns reviewer subagent for isolation
- **`serve`** — start service(s) locally for development; reads commands from context/build.md
- **`squad-plan`** — generate parallel workstream plan for multi-agent Copilot work
- **`status`** — project status dashboard: instructions budget, unfilled placeholders, hooks health
- **`test`** — run the test suite and report results; reads test command from context/build.md
- **`ticket`** — create a ticket/issue description with evidence-backed proof sections
- **`update-code-index`** — scan codebase exports and generate CODE_INDEX.md organized by capability
- **`worktree`** — manage git worktrees for parallel work on multiple branches simultaneously
- **`worktree-status`** — show all active git worktrees with branch name, dirty/clean status, last commit

#### Lifecycle Scripts — 9 new scripts (2 → 11, operational parity)

- **`scripts/populate-templates.sh`** — fills `{{PLACEHOLDER}}` values in copilot-instructions.md and context/*.md using context/tasks/.discovery.env as source
- **`scripts/canary-check.sh`** — fast health check: copilot-instructions.md exists, skills count ≥5, hooks executable, jq present
- **`scripts/phase2-verify.sh`** — post-/bootstrap verification: all placeholders filled, context docs populated, skills accessible
- **`scripts/dry-run.sh`** — dry run install.sh with --dry-run: report what would change without modifying anything
- **`scripts/post-bootstrap-validate.sh`** — run after /bootstrap completes: verify no unfilled placeholders, validate context docs
- **`scripts/portability-lint.sh`** — check shell scripts for portability issues: bashisms, pager triggers, interactive flags
- **`scripts/migrate-tasks.sh`** — migrate task files from old context structure; archive old lessons
- **`scripts/setup-plugins.sh`** — install/check MCP tool prerequisites (uvx, npx); report status per plugin
- **`scripts/integration-test.sh`** — end-to-end: simulate bootstrap on tmp dir, verify all phases complete cleanly

#### Bootstrap Templates

- **`context/bootstrap/_copilot-instructions.md.template`** — canonical template for copilot-instructions.md with `{{DOMAIN_LOOKUP_TABLE}}` placeholder; used by populate-templates.sh during /bootstrap

### Fixed

- **`scripts/_platform.sh`** — `supports_unicode()` now detects `*utf8*` locale variant, macOS auto-pass (modern macOS Terminal always supports Unicode), and `WT_SESSION` Windows Terminal detection; aligns with Claude and Codex implementations

### Changed

- **`validate.sh`** — expanded from 181 lines (8 sections) to 330 lines (11 sections): added template integrity check, community files guard, hooks JSON syntax validation via jq, copilot-instructions.md size guard (4KB budget), lessons.md line count guard, and reference integrity check

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
