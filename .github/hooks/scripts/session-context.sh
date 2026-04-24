#!/usr/bin/env bash
# session-context.sh — SessionStart hook
# Outputs branch, open todos, uncommitted files, recent commits, and lessons as
# additionalContext for Copilot.
# Output format: {"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "..."}}

set -euo pipefail

CONTEXT=""
TIMESTAMP=$(date '+%Y-%m-%d %H:%M' 2>/dev/null || echo "unknown")

CONTEXT+="## Session Context — ${TIMESTAMP}\n\n"

# jq check — three safety hooks depend on it; warn loudly if absent
if ! command -v jq &>/dev/null; then
  CONTEXT+="⚠️ **WARNING:** \`jq\` not found — config-protection, terminal-safety, and commit-quality hooks are INACTIVE.\n"
  CONTEXT+="Install: \`brew install jq\` (macOS) or \`sudo apt-get install jq\` (Linux)\n\n"
fi

# Current branch
BRANCH=$(git --no-pager branch --show-current 2>/dev/null || echo "unknown")
CONTEXT+="**Branch:** \`${BRANCH}\`\n\n"

# Uncommitted changes
UNCOMMITTED=$(git status --short 2>/dev/null | head -10 || true)
if [[ -n "${UNCOMMITTED}" ]]; then
  CONTEXT+="**Uncommitted files:**\n\`\`\`\n${UNCOMMITTED}\n\`\`\`\n\n"
fi

# Recent commits
RECENT_COMMITS=$(git --no-pager log --oneline -5 2>/dev/null || echo "(no commits)")
CONTEXT+="**Recent commits:**\n\`\`\`\n${RECENT_COMMITS}\n\`\`\`\n\n"

# Open todos (unchecked items from todo.md)
if [[ -f "claude/tasks/todo.md" ]]; then
  OPEN_TODOS=$(grep -c '^\- \[ \]' claude/tasks/todo.md 2>/dev/null || echo "0")
  CONTEXT+="**Open todos:** ${OPEN_TODOS} (see \`claude/tasks/todo.md\`)\n"
  if [[ "${OPEN_TODOS}" -gt 0 ]]; then
    CONTEXT+="\n**Pending items:**\n"
    while IFS= read -r line; do
      CONTEXT+="  ${line}\n"
    done < <(grep '^\- \[ \]' claude/tasks/todo.md 2>/dev/null | head -5 || true)
  fi
  CONTEXT+="\n"
fi

# Recent lessons (last 5 entries from lessons.md)
if [[ -f "claude/tasks/lessons.md" ]]; then
  LESSON_LINES=$(grep -v '^#' claude/tasks/lessons.md 2>/dev/null | grep -v '^$' | tail -10 | head -5 || true)
  if [[ -n "${LESSON_LINES}" ]]; then
    CONTEXT+="**Recent lessons:**\n${LESSON_LINES}\n\n"
  fi
fi

# Recent errors (last 3 from COPILOT_ERRORS.md)
if [[ -f "claude/tasks/COPILOT_ERRORS.md" ]]; then
  ERROR_HEADERS=$(grep '^## ERROR-' claude/tasks/COPILOT_ERRORS.md 2>/dev/null | tail -3 || true)
  if [[ -n "${ERROR_HEADERS}" ]]; then
    CONTEXT+="**Active error patterns:**\n${ERROR_HEADERS}\n\n"
  fi
fi

CONTEXT+="⚡ First steps: read \`claude/tasks/lessons.md\` + \`claude/architecture.md\` + \`claude/rules.md\`\n"
CONTEXT+="⚡ NEVER \`git push\` autonomously — present summary, wait for confirmation\n"
CONTEXT+="⚡ Temp files → \`./claude/tasks/\` — never \`/tmp/\`\n"

# Build the JSON output for Copilot's SessionStart hook format
CONTEXT_ESCAPED=$(printf '%s' "${CONTEXT}" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '%s' "${CONTEXT}" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/' | tr -d '\n')

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}' "${CONTEXT_ESCAPED}"
