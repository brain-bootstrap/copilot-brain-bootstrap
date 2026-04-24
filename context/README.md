# context/ Knowledge Layer

This directory is the **persistent brain** of your project — structured knowledge that GitHub Copilot (and any AI assistant) reads on demand.

## Contents

| File                      | Purpose                                                   | When to read                              |
| ------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| `architecture.md`         | Service catalog, workspace layout, infrastructure map     | Any task touching project structure       |
| `rules.md`                | 14 non-negotiable working standards                       | Every session (injected via instructions) |
| `build.md`                | Build, test, lint, CI commands reference                  | Before any build/test/lint task           |
| `templates.md`            | MR/PR and ticket description templates                    | Before generating PR descriptions         |
| `terminal-safety.md`      | Terminal safety rules — pipe, pager, interactive programs | Before any terminal command               |
| `cve-policy.md`           | Dependency security audit process                         | Before any dependency change              |
| `decisions.md`            | Architectural decisions record (ADR)                      | When considering architectural changes    |
| `plugins.md`              | Active plugins and integration notes                      | When using plugin features                |
| `tasks/todo.md`           | Current task state — what's in progress                   | Every session start                       |
| `tasks/lessons.md`        | Accumulated wisdom from past sessions                     | Every session start                       |
| `tasks/COPILOT_ERRORS.md` | Recurring mistakes to avoid                               | Every session start                       |

## Philosophy: Write Once, Read Everywhere

This knowledge layer is **AI-agnostic**. The same `context/*.md` files are read by:

- GitHub Copilot (via `.github/copilot-instructions.md`)
- Claude Code (via `CLAUDE.md` — if you also use it)
- Codex (via `AGENTS.md` — if you also use it)
- Any other AI assistant that can read files

Update a doc once → all your AI assistants are up to date.

## Maintenance Rules

1. When a lesson is learned, add it to `tasks/lessons.md`
2. When a recurring error is identified, add it to `tasks/COPILOT_ERRORS.md`
3. When an architectural decision is made, add it to `decisions.md`
4. When build commands change, update `build.md`
5. Never let `architecture.md` drift from reality
