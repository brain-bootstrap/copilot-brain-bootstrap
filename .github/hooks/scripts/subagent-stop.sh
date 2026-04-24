#!/usr/bin/env bash
# subagent-stop.sh — SubagentStop hook
# Nudges the agent to update lessons.md and check the exit checklist after subagent work.
# Uses systemMessage (common output format) to display a reminder.

set -uo pipefail

INPUT=$(cat)

# Extract agent info if available
AGENT_TYPE=$(printf '%s' "${INPUT}" | jq -r '.agent_type // "subagent"' 2>/dev/null || echo "subagent")

MSG="Subagent completed (${AGENT_TYPE}). Exit checklist: "
MSG+="(1) New codebase discoveries → update claude/tasks/lessons.md. "
MSG+="(2) Bugs found → record in claude/tasks/COPILOT_ERRORS.md. "
MSG+="(3) Open todos from this run → update claude/tasks/todo.md."

MSG_ESCAPED=$(printf '%s' "${MSG}" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))' 2>/dev/null \
  || printf '"%s"' "${MSG}")

printf '{"systemMessage":%s}' "${MSG_ESCAPED}"
