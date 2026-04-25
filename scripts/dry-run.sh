#!/usr/bin/env bash
# dry-run.sh — Simulate a Copilot Brain Bootstrap install/upgrade without writing files
# Usage: bash scripts/dry-run.sh [PROJECT_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-${BRAIN_PROJECT_DIR:-$SCRIPT_DIR}}"

BOLD="\033[1m"; RESET="\033[0m"; GREEN="\033[0;32m"; YELLOW="\033[0;33m"; RED="\033[0;31m"

note()  { printf "  ${YELLOW}--${RESET} %s\n" "$1"; }
pass()  { printf "  ${GREEN}${PASS_SYM}${RESET} %s\n" "$1"; }
fail()  { printf "  ${RED}${FAIL_SYM}${RESET} %s\n" "$1" >&2; ERRORS=$((ERRORS + 1)); }

ERRORS=0

printf "${BOLD}Copilot Brain Bootstrap — Dry Run${RESET}\n"
printf "Project: %s\n\n" "$PROJECT_DIR"

# ── Step 1: Task file migration check ────────────────────────────────────────
printf "${BOLD}[1] Task file migration${RESET}\n"
DISCOVERY_ENV="$PROJECT_DIR/context/tasks/.discovery.env"
if [ -f "$DISCOVERY_ENV" ]; then
  pass "context/tasks/.discovery.env found — tasks already migrated"
else
  note "context/tasks/.discovery.env not found — migration would run on install"
fi

# ── Step 2: Placeholder check ─────────────────────────────────────────────────
printf "\n${BOLD}[2] Placeholder detection${RESET}\n"
if [ -f "$PROJECT_DIR/.github/copilot-instructions.md" ]; then
  PH_COUNT=$(grep -Ec '\{\{[A-Z_]+\}\}' "$PROJECT_DIR/.github/copilot-instructions.md" 2>/dev/null || echo 0)
  if [ "$PH_COUNT" -gt 0 ]; then
    note "$PH_COUNT placeholder(s) in copilot-instructions.md — /bootstrap would fill them"
  else
    pass "No unfilled placeholders in copilot-instructions.md"
  fi
else
  note ".github/copilot-instructions.md not found — install would create it"
fi

# ── Step 3: Hooks validation ──────────────────────────────────────────────────
printf "\n${BOLD}[3] Hooks validation${RESET}\n"
if command -v jq &>/dev/null; then
  HOOK_ERRORS=0
  while IFS= read -r hook_json; do
    [ -z "$hook_json" ] && continue
    if jq . "$hook_json" > /dev/null 2>&1; then
      pass "$(basename "$hook_json") — valid JSON"
    else
      fail "$(basename "$hook_json") — INVALID JSON (install would fix)"
      HOOK_ERRORS=$((HOOK_ERRORS + 1))
    fi
  done < <(find "$PROJECT_DIR/.github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null)
  [ "$HOOK_ERRORS" -eq 0 ] && [ "$(find "$PROJECT_DIR/.github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')" -gt 0 ] \
    && pass "All hook JSON files valid" || true
  HOOK_COUNT=$(find "$PROJECT_DIR/.github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
  [ "$HOOK_COUNT" -lt 7 ] && note "Only $HOOK_COUNT/7 hook JSON files — install would add missing ones"
else
  note "jq not installed — cannot validate hook JSON"
fi

printf "\n"
if [ "$ERRORS" -eq 0 ]; then
  printf "${GREEN}${BOLD}Dry run complete — no blocking issues.${RESET}\n"
  printf "Run ${BOLD}bash install.sh${RESET} to apply.\n\n"
  exit 0
else
  printf "${RED}${BOLD}Dry run found $ERRORS issue(s). Fix before running install.sh.${RESET}\n\n"
  exit 1
fi
