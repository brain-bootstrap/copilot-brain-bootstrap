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
2. Make changes
3. Run `bash validate.sh` — all checks must pass
4. Run shellcheck on any `.sh` files
5. Open a PR using the PR template

## Code of Conduct

Be kind. We're all here to make developer tooling better.
