#!/usr/bin/env bash
# quality-gate.sh — Stop hook
# Warns about uncommitted changes, unchecked todos, and stale lessons before the session ends.

set -uo pipefail

WARNINGS=()

# ── Uncommitted changes ───────────────────────────────────────────────────────
UNCOMMITTED=$(git --no-pager status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [[ "${UNCOMMITTED}" -gt 0 ]]; then
  WARNINGS+=("⚠️ ${UNCOMMITTED} uncommitted file(s) — consider committing or stashing before ending the session.")
fi

# ── Unchecked todos ───────────────────────────────────────────────────────────
if [[ -f "context/tasks/todo.md" ]]; then
  OPEN_TODOS=$(grep -c '^\- \[ \]' context/tasks/todo.md 2>/dev/null || echo "0")
  if [[ "${OPEN_TODOS}" -gt 0 ]]; then
    WARNINGS+=("⚠️ ${OPEN_TODOS} open todo item(s) in context/tasks/todo.md — mark complete or defer to next session.")
  fi
fi

# ── Lessons freshness ─────────────────────────────────────────────────────────
if [[ -f "context/tasks/lessons.md" ]]; then
  LESSONS_MODIFIED=$(git --no-pager log --oneline -1 -- context/tasks/lessons.md 2>/dev/null || echo "")
  if [[ -z "${LESSONS_MODIFIED}" ]]; then
    WARNINGS+=("💡 context/tasks/lessons.md has never been committed — confirm lessons are being captured.")
  fi
fi

# ── Output ────────────────────────────────────────────────────────────────────
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  printf '\n━━━ Quality Gate ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
  for W in "${WARNINGS[@]}"; do
    printf '  %s\n' "${W}"
  done
  printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'
fi

exit 0  # Non-blocking — warn only
