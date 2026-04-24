---
description: 'Diff viewer with context. Shows what changed, when, and why. Filters by file, directory, or author.'
agent: agent
tools:
  - run_in_terminal
  - read_file
argument-hint: '[file or directory or branch]'
---

## Diff Operations

### Current changes (unstaged)
```bash
git --no-pager diff --color=never 2>&1 | head -100
```

### Staged changes
```bash
git --no-pager diff --staged --color=never 2>&1 | head -100
```

### Branch vs main
```bash
git --no-pager diff main...HEAD --color=never --stat 2>&1 | head -30
git --no-pager diff main...HEAD --color=never 2>&1 | head -200
```

### Specific file history
```bash
git --no-pager log --oneline --follow -- path/to/file 2>&1 | head -20
```

### Specific commit
```bash
git --no-pager show COMMIT_SHA --color=never 2>&1 | head -100
```
