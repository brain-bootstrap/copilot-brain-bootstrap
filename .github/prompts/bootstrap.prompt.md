---
description: 'Autonomous bootstrap: detect project type, fill all {{PLACEHOLDERS}} in knowledge layer, generate architecture.md, build.md, and configure available plugins. Run once per project.'
agent: agent
tools:
  - read_file
  - replace_string_in_file
  - run_in_terminal
  - grep_search
  - file_search
  - list_dir
argument-hint: '[optional: project description override]'
---

You are performing a **full autonomous bootstrap** of this project's AI knowledge layer.

## Phase A — Read the bootstrap reference

Read `context/bootstrap/PROMPT.md` if it exists, otherwise proceed with the standard protocol below.

## Phase B — Discover project structure

1. Run `find . -maxdepth 3 -name 'package.json' -not -path '*/node_modules/*' 2>/dev/null | head -20`
2. Run `find . -maxdepth 3 -name 'pyproject.toml' -o -name 'requirements.txt' -o -name 'Cargo.toml' -o -name 'go.mod' 2>/dev/null | head -10`
3. Run `ls -la`
4. Identify: runtime, package manager, services, test framework, build tools

## Phase C — Fill copilot-instructions.md

Replace `{{PROJECT_NAME}}` with the project name.
Replace `{{CRITICAL_PATTERNS}}` with up to 5 project-specific critical rules discovered during bootstrap.

## Phase D — Fill context/architecture.md

Replace all `{{DIR_N}}`, `{{SERVICE_N}}`, `{{INFRA_N}}` placeholders with real values discovered.

## Phase E — Fill context/build.md

Replace all `{{BUILD_CMD_*}}`, `{{TEST_CMD_*}}`, `{{LINT_*}}` placeholders with real commands.
Test each command to confirm it works.

## Phase F — Fill context/cve-policy.md

Update the audit commands table to match the detected runtimes.

## Phase G — Detect plugins

Check for:
- `.cocoindex_code/` → enable CocoIndex skill
- `.serena/` → enable Serena skill
- `playwright.config.*` → enable Playwright skill
Update `context/plugins.md` with detected plugins.

## Phase H — Verify

Run `bash validate.sh` if it exists. Report ✅/❌ for each check.

## Phase I — Commit

Do NOT commit automatically. Present a summary and wait for user confirmation.

---

**Output:** Summary table of all placeholders filled + validate.sh results.
