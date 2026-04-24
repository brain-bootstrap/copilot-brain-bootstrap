# Changelog

All notable changes to Copilot Brain Bootstrap will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-04-24

### Added

- Initial release of Copilot Brain Bootstrap
- `.github/copilot-instructions.md` — main template, always injected by Copilot
- 5 custom agents: reviewer, researcher, plan-challenger, security-auditor, session-reviewer
- 7 lifecycle hooks with scripts: session-context, terminal-safety, config-protection, quality-gate, pre-commit-quality, subagent-stop, pre-compact
- 38 prompt files for common tasks
- 18 skills including tdd, root-cause-trace, brainstorming, careful, cross-layer-check
- 9 path-specific instruction files
- `context/` knowledge layer: 8 documentation files + tasks directory
- `install.sh` — smart fresh/upgrade installer
- `validate.sh` — post-install validation with ✅/❌ reporting
- CI pipeline: validate on ubuntu/macos/windows + shellcheck
