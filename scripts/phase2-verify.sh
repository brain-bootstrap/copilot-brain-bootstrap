#!/usr/bin/env bash
# phase2-verify.sh — Verify phase-2 (post-upgrade) state for Copilot Brain Bootstrap
# Usage: bash scripts/phase2-verify.sh [PROJECT_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-${BRAIN_PROJECT_DIR:-$SCRIPT_DIR}}"
cd "$PROJECT_DIR"

pass() { printf "  ${PASS_SYM} %s\n" "$1"; }
fail() { printf "  ${FAIL_SYM} %s\n" "$1" >&2; ERRORS=$((ERRORS + 1)); }

ERRORS=0

printf "Phase 2 verification: %s\n\n" "$PROJECT_DIR"

# lessons.md
if [ -f "context/tasks/lessons.md" ]; then
  pass "context/tasks/lessons.md exists"
else
  fail "context/tasks/lessons.md missing"
fi

# todo.md
if [ -f "context/tasks/todo.md" ]; then
  pass "context/tasks/todo.md exists"
else
  fail "context/tasks/todo.md missing"
fi

# Hook JSON is valid
BACKUP=""
if [ -f "context/tasks/.pre-upgrade-backup.tar.gz" ]; then
  BACKUP=" · backup ✓"
fi

if command -v jq &>/dev/null; then
  HOOK_JSON_FAIL=0
  while IFS= read -r hook_json; do
    [ -z "$hook_json" ] && continue
    if ! jq . "$hook_json" > /dev/null 2>&1; then
      fail "Invalid JSON: $hook_json"
      HOOK_JSON_FAIL=$((HOOK_JSON_FAIL + 1))
    fi
  done < <(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null)
  [ "$HOOK_JSON_FAIL" -eq 0 ] && pass "All hook JSON valid"
else
  printf "  ⚠️  jq not installed — skipping hook JSON check\n"
fi

if [ "$ERRORS" -eq 0 ]; then
  printf "\n${PASS_SYM} Phase 2 OK: lessons.md ✓ · todo.md ✓ · hooks JSON ✓%s\n" "$BACKUP"
  exit 0
else
  printf "\n${FAIL_SYM} Phase 2: $ERRORS check(s) failed\n" >&2
  exit 1
fi
