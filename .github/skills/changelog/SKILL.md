---
name: changelog
description: 'Generate or update CHANGELOG.md following Keep a Changelog format. Groups changes by type: Added, Changed, Fixed, Removed, Security.'
user-invocable: true
---

# Changelog Skill

## Format: Keep a Changelog

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New feature description

### Changed
- What was changed and why

### Fixed
- Bug fix description

### Removed
- Removed functionality

### Security
- CVE fixes, security patches
```

## Protocol

### Update CHANGELOG for a new release:

1. Get all commits since last tag: `git --no-pager log $(git describe --tags --abbrev=0)..HEAD --oneline 2>&1 | head -50`
2. Categorize by conventional commit type:
   - `feat:` → Added
   - `fix:` → Fixed
   - `refactor:` → Changed
   - `chore:` + `build:` → Changed
   - `security:` → Security
3. Write human-readable descriptions (not commit hashes)
4. Move `[Unreleased]` entries to new `[version]` section

## Rules

- Never include internal AI tooling notes in CHANGELOG
- Keep descriptions user-facing and concise (1 line per item)
- Always date releases: `## [1.2.0] - YYYY-MM-DD`
