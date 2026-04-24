# Contributing to Copilot Brain Bootstrap

Thank you for considering a contribution! This guide explains how to contribute effectively.

## What We're Looking For

- **New prompts** — high-quality, reusable slash commands for common developer workflows
- **New skills** — specialized behaviors that activate in the right context
- **New agents** — expert agents for specific review or analysis tasks
- **Hook improvements** — better safety checks, context injection, quality gates
- **Bug fixes** — any issue discovered in install.sh, validate.sh, or the CI pipeline
- **Documentation** — clearer explanations, better examples

## Contribution Standards

All contributions must:

1. **Follow the existing file format** — read 2-3 existing files before writing a new one
2. **Include proper frontmatter** — agents, prompts, and skills all have required fields
3. **Pass CI** — `bash validate.sh` must pass on all 3 platforms
4. **Have a clear description** in the frontmatter `description:` field
5. **Be named correctly** — skill `name:` frontmatter must match the directory name

## Skill Requirements

```yaml
---
name: my-skill # MUST match parent directory name exactly
description: 'What this skill does and when to use it'
user-invocable: true # true = user can invoke manually, false = auto-only
---
```

## Prompt Requirements

```yaml
---
description: 'What this prompt does (shown in / picker)'
mode: agent # agent | ask | edit — usually agent
tools: # list tools the prompt needs
  - read_file
argument-hint: '[argument]' # shown next to the prompt name
---
```

## Agent Requirements

```yaml
---
description: 'What this agent does'
tools:
  - read_file
model: ['Claude Opus 4 (copilot)']
---
```

## Hook Requirements

JSON format (VS Code PascalCase events):

```json
{
  "hooks": {
    "SessionStart": [
      { "type": "command", "command": "bash .github/hooks/scripts/my-hook.sh" }
    ]
  }
}
```

Hook scripts must:

- Use `set -uo pipefail`
- Exit code 2 to block tool use
- Print reason to stderr when blocking

## Pull Request Process

1. Fork and create a branch: `feat/my-feature` or `fix/my-bug`
2. Make changes — read existing files first, match conventions
3. Run `bash validate.sh` — all checks must pass
4. Run `shellcheck` on any `.sh` files you added or modified
5. Test install in a temp project (see Development Workflow above)
6. Open a PR using the PR template — include a clear description of what changed and why

## Code Style

- **Shell scripts**: `set -uo pipefail`; quote all variables; use `[[ ]]` not `[ ]`
- **Markdown**: ATX headings (`#`), no trailing spaces, one blank line between sections
- **YAML frontmatter**: always use single quotes for values with colons
- **JSON hooks**: 2-space indent, no trailing commas, camelCase event names (VS Code standard)

## Cross-Platform Requirements

All shell scripts must run on:

- macOS (zsh default, bash available)
- Linux (bash, POSIX sh)
- Windows (Git Bash)

Portability rules:

- Use `#!/usr/bin/env bash` (never `#!/bin/bash` — not present at that path on macOS)
- No GNU-specific flags (e.g., `sed -i ''` on macOS vs `sed -i` on Linux)
- Use `command -v tool` not `which tool` for binary detection
- Test on at least macOS and Linux before submitting

## CI Pipeline

The CI runs 5 checks on Ubuntu, macOS, and Windows:

| Check          | Command                             | What it verifies                          |
| :------------- | :---------------------------------- | :---------------------------------------- |
| Validation     | `bash validate.sh`                  | All files present, no broken placeholders |
| ShellCheck     | `shellcheck install.sh validate.sh` | Shell script quality                      |
| Portability    | `bash -n` on all scripts            | Syntax valid on bash                      |
| Cross-platform | macOS + Ubuntu + Windows matrix     | Scripts run on all 3 platforms            |
| Install smoke  | Install to temp project             | Full install cycle works end-to-end       |

## Development Workflow

```bash
# Clone the repo
git clone https://github.com/brain-bootstrap/copilot-brain-bootstrap.git
cd copilot-brain-bootstrap

# Validate your changes
bash validate.sh

# Test install in a temp project
mkdir /tmp/test-project && git init /tmp/test-project
bash install.sh /tmp/test-project
```

## Release Process (Maintainers only)

1. Update `CHANGELOG.md` — add version entry following Keep a Changelog format
2. Run full validation on macOS and Linux
3. Tag the release: `git tag vX.Y.Z -m "Release vX.Y.Z"`
4. Push tag — CI creates the GitHub release automatically

## Code of Conduct

Be kind. We're all here to make developer tooling better.
