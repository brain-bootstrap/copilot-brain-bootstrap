---
description: 'Full project health check: validate all hooks, agents, skills, instructions are properly loaded. Check for placeholder tokens, missing files, and stale knowledge.'
mode: agent
tools:
  - read_file
  - run_in_terminal
  - file_search
  - grep_search
---

## Health Check Protocol

### 1. Validate knowledge layer

- [ ] `context/architecture.md` — no `{{PLACEHOLDER}}` tokens remaining
- [ ] `context/build.md` — build commands are real (not `{{BUILD_CMD_ALL}}`)
- [ ] `context/rules.md` — readable
- [ ] `context/tasks/todo.md` — readable

### 2. Validate Copilot system files

- [ ] `.github/copilot-instructions.md` — exists, <4KB
- [ ] `.github/agents/*.agent.md` — count ≥ 3
- [ ] `.github/prompts/*.prompt.md` — count ≥ 10
- [ ] `.github/hooks/*.json` — count ≥ 2
- [ ] `.github/hooks/scripts/*.sh` — executable

### 3. Validate skills

- [ ] `.github/skills/*/SKILL.md` — count ≥ 5
- [ ] No skill has broken `name:` frontmatter

### 4. Validate instructions

- [ ] `.github/instructions/general.instructions.md` — exists

### 5. Run validate.sh (if present)

```bash
bash validate.sh 2>&1 | tail -40
```

## Report Format

```
## Health Report — [project name]

| Check | Status | Note |
|-------|--------|------|
| Knowledge layer | ✅/❌ | |
| Copilot files | ✅/❌ | |
| Skills | ✅/❌ | |
| Hooks | ✅/❌ | |
| Instructions | ✅/❌ | |

**Overall: HEALTHY / NEEDS ATTENTION**
```
