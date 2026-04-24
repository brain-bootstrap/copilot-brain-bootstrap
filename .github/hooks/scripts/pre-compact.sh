#!/usr/bin/env bash
# pre-compact.sh — PreCompact hook
# Saves branch, open todos, and uncommitted files before context compaction.
# Outputs a systemMessage so the agent sees what was saved.

set -uo pipefail

TIMESTAMP=$(date '+%Y-%m-%d %H:%M' 2>/dev/null || echo "unknown")
BRANCH=$(git --no-pager branch --show-current 2>/dev/null || echo "unknown")

# Collect open todos
OPEN_TODOS=""
if [[ -f "claude/tasks/todo.md" ]]; then
  OPEN_TODOS=$(grep '^\- \[ \]' claude/tasks/todo.md 2>/dev/null | head -10 || true)
fi

# Collect uncommitted files
UNCOMMITTED=$(git status --short 2>/dev/null | head -10 || true)

# Build compact summary to preserve
SUMMARY="## Pre-Compact Snapshot — ${TIMESTAMP}\n"
SUMMARY+="Branch: ${BRANCH}\n"
if [[ -n "${OPEN_TODOS}" ]]; then
  SUMMARY+="Open todos:\n${OPEN_TODOS}\n"
fi
if [[ -n "${UNCOMMITTED}" ]]; then
  SUMMARY+="Uncommitted files:\n${UNCOMMITTED}\n"
fi
SUMMARY+="\nResume with /resume to restore context after compaction."

# Write snapshot to tasks dir (survives compaction)
mkdir -p claude/tasks
printf '%b\n' "${SUMMARY}" > claude/tasks/.pre-compact-snapshot.md 2>/dev/null || true

MSG="Context compaction starting. Snapshot saved to claude/tasks/.pre-compact-snapshot.md — Branch: ${BRANCH}"
MSG_ESCAPED=$(printf '%s' "${MSG}" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))' 2>/dev/null \
  || printf '"%s"' "${MSG}")

printf '{"systemMessage":%s}' "${MSG_ESCAPED}"
