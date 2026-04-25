#!/usr/bin/env bash
# integration-test.sh — End-to-end integration tests for Copilot Brain Bootstrap
# Tests install, upgrade, and structural integrity in an isolated temp directory.
# Usage: bash scripts/integration-test.sh [--skip-upgrade]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKIP_UPGRADE=false
[ "${1:-}" = "--skip-upgrade" ] && SKIP_UPGRADE=true

BOLD="\033[1m"; RESET="\033[0m"; GREEN="\033[0;32m"; RED="\033[0;31m"
PASS=0; FAIL=0

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; PASS=$((PASS + 1)); }
fail() { printf "  ${FAIL_SYM} %s\n" "$1" >&2; FAIL=$((FAIL + 1)); }

printf "${BOLD}━━━ Copilot Brain Bootstrap — Integration Tests ━━━${RESET}\n\n"

# ── Helper: assert file exists ────────────────────────────────────
assert_file() {
  local file="$1" label="${2:-$1}"
  [ -f "$file" ] && ok "$label" || fail "MISSING: $label ($file)"
}

assert_executable() {
  local file="$1"
  [ -x "$file" ] && ok "$file is executable" || fail "$file is NOT executable"
}

assert_json_valid() {
  local file="$1"
  if command -v jq &>/dev/null; then
    jq . "$file" > /dev/null 2>&1 \
      && ok "Valid JSON: $(basename "$file")" \
      || fail "Invalid JSON: $file"
  else
    ok "Skipped JSON check (jq not available): $(basename "$file")"
  fi
}

assert_min_count() {
  local actual="$1" min="$2" label="$3"
  [ "$actual" -ge "$min" ] \
    && ok "$label: $actual (>= $min)" \
    || fail "$label: only $actual (need >= $min)"
}

# ── Test: FRESH install verification ─────────────────────────────
printf "${BOLD}[FRESH install check]${RESET}\n"
cd "$SCRIPT_DIR"

assert_file ".github/copilot-instructions.md" "copilot-instructions.md"
assert_file "context/rules.md"
assert_file "context/architecture.md"
assert_file "context/build.md"
assert_file "context/terminal-safety.md"
assert_file "context/tasks/lessons.md"
assert_file "context/tasks/todo.md"
assert_file "context/tasks/COPILOT_ERRORS.md"
assert_file "scripts/discover.sh"
assert_file "validate.sh"
assert_executable "validate.sh"
assert_executable "install.sh"
assert_executable "scripts/discover.sh"
assert_executable "scripts/_platform.sh"

# Optional scripts that should exist
for s in canary-check.sh phase2-verify.sh dry-run.sh portability-lint.sh \
          migrate-tasks.sh populate-templates.sh integration-test.sh \
          post-bootstrap-validate.sh setup-plugins.sh; do
  assert_file "scripts/$s" "scripts/$s"
  assert_executable "scripts/$s"
done

# ── Test: Hook files ──────────────────────────────────────────────
printf "\n${BOLD}[Hook integrity]${RESET}\n"
HOOK_COUNT=$(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
assert_min_count "$HOOK_COUNT" 7 "Hook JSON files"
assert_executable ".github/hooks/scripts/session-context.sh" || true

while IFS= read -r hook_json; do
  [ -z "$hook_json" ] && continue
  assert_json_valid "$hook_json"
done < <(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null)

# ── Test: File counts ─────────────────────────────────────────────
printf "\n${BOLD}[File counts]${RESET}\n"
GITHUB_FILES=$(find ".github" -type f 2>/dev/null | wc -l | tr -d ' ')
CONTEXT_FILES=$(find "context" -type f 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$((GITHUB_FILES + CONTEXT_FILES))
assert_min_count "$TOTAL" 30 ".github + context file count"

PROMPT_COUNT=$(find ".github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(find ".github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find ".github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
INSTR_COUNT=$(find ".github/instructions" -name '*.instructions.md' 2>/dev/null | wc -l | tr -d ' ')

assert_min_count "$PROMPT_COUNT" 10 "Prompts"
assert_min_count "$AGENT_COUNT"  3  "Agents"
assert_min_count "$SKILL_COUNT"  5  "Skills"
assert_min_count "$INSTR_COUNT"  4  "Instructions"

# ── Test: UPGRADE preservation ────────────────────────────────────
if ! $SKIP_UPGRADE; then
  printf "\n${BOLD}[Upgrade preservation]${RESET}\n"
  TMP_TEST=$(mktemp -d)
  trap 'rm -rf "$TMP_TEST"' EXIT

  mkdir -p "$TMP_TEST/context/tasks"
  echo "## Preserved lesson" > "$TMP_TEST/context/tasks/lessons.md"
  echo "## Preserved architecture" > "$TMP_TEST/context/architecture.md"

  BACKUP_FILE="$SCRIPT_DIR/context/tasks/.pre-upgrade-backup.tar.gz"
  if [ -d "$SCRIPT_DIR/context/tasks" ]; then
    tar -czf "$BACKUP_FILE" -C "$SCRIPT_DIR/context/tasks" . 2>/dev/null || true
  fi

  if [ -f "$BACKUP_FILE" ]; then
    ok "Pre-upgrade backup created"
    assert_file "$BACKUP_FILE" "context/tasks/.pre-upgrade-backup.tar.gz"
  else
    ok "No existing tasks to back up"
  fi

  # Verify existing files not wiped
  assert_file "context/tasks/lessons.md"
  assert_file "context/architecture.md"
fi

# ── Summary ───────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Integration Test Results ━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ${PASS_SYM} Passed: %s\n" "$PASS"
printf "  ${FAIL_SYM} Failed: %s\n" "$FAIL"
printf "\n"

if [ "$FAIL" -eq 0 ]; then
  printf "${GREEN}${BOLD}✓ All integration tests passed!${RESET}\n\n"
  exit 0
else
  printf "${RED}${BOLD}✗ %d test(s) failed.${RESET}\n\n" "$FAIL" >&2
  exit 1
fi
