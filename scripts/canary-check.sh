#!/usr/bin/env bash
# canary-check.sh — Deep structural health check for Copilot Brain Bootstrap
# Checks wiring, references, and config integrity without modifying anything.
# Usage: bash scripts/canary-check.sh [PROJECT_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-${BRAIN_PROJECT_DIR:-$SCRIPT_DIR}}"
cd "$PROJECT_DIR"

BOLD="\033[1m"; RESET="\033[0m"
PASS=0; FAIL=0; WARN_COUNT=0

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; PASS=$((PASS + 1)); }
fail() { printf "  ${FAIL_SYM} %s\n" "$1" >&2; FAIL=$((FAIL + 1)); }
warn() { printf "  ${WARN_SYM} %s\n" "$1"; WARN_COUNT=$((WARN_COUNT + 1)); }

printf "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${BOLD}  ᗺB Copilot Canary Check${RESET}\n"
printf "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

# ── [1] Core instruction file ─────────────────────────────────────────────────
printf "\n${BOLD}[1] Core instruction file${RESET}\n"
INSTR=".github/copilot-instructions.md"
if [ -f "$INSTR" ]; then
  ok "$INSTR present"
  INSTR_SIZE=$(wc -c < "$INSTR" || echo 0)
  [ "$INSTR_SIZE" -gt 500 ]  && ok "Non-trivial content ($INSTR_SIZE bytes)" \
    || warn "$INSTR looks empty or tiny ($INSTR_SIZE bytes)"
  [ "$INSTR_SIZE" -le 4096 ] && ok "Within 4KB budget" \
    || warn "Exceeds 4KB budget ($INSTR_SIZE bytes) — trim it"
  INSTR_LINES=$(wc -l < "$INSTR" || echo 0)
  [ "$INSTR_LINES" -ge 30 ]  && ok "Has $INSTR_LINES lines" \
    || warn "Only $INSTR_LINES lines — may be incomplete"
else
  fail "$INSTR missing — run install.sh"
fi

# ── [2] Sections/headers check ────────────────────────────────────────────────
printf "\n${BOLD}[2] Required sections in copilot-instructions.md${RESET}\n"
REQUIRED_SECTIONS=("Golden Rules" "Operating Protocol" "Exit Checklist" "Terminal Safety")
for sec in "${REQUIRED_SECTIONS[@]}"; do
  grep -q "$sec" "$INSTR" 2>/dev/null \
    && ok "Section: $sec" \
    || warn "Missing section: $sec — bootstrap may be incomplete"
done

# ── [3] Knowledge layer ───────────────────────────────────────────────────────
printf "\n${BOLD}[3] Knowledge layer (context/)${RESET}\n"
REQUIRED_DOCS=(
  "context/rules.md"
  "context/architecture.md"
  "context/build.md"
  "context/templates.md"
  "context/terminal-safety.md"
  "context/cve-policy.md"
  "context/decisions.md"
  "context/plugins.md"
  "context/tasks/todo.md"
  "context/tasks/lessons.md"
  "context/tasks/COPILOT_ERRORS.md"
)
for doc in "${REQUIRED_DOCS[@]}"; do
  [ -f "$doc" ] && ok "$doc" || fail "$doc missing"
done

# ── [4] Prompts ───────────────────────────────────────────────────────────────
printf "\n${BOLD}[4] Prompts (.github/prompts/)${RESET}\n"
PROMPT_COUNT=$(find ".github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$PROMPT_COUNT" -ge 10 ] && ok "$PROMPT_COUNT prompts installed" \
  || warn "Only $PROMPT_COUNT prompts (expected 10+)"
for P in plan debug review mr bootstrap health lint test; do
  [ -f ".github/prompts/${P}.prompt.md" ] && ok "  /prompt: $P" \
    || warn "  Missing: ${P}.prompt.md"
done

# ── [5] Agents ────────────────────────────────────────────────────────────────
printf "\n${BOLD}[5] Agents (.github/agents/)${RESET}\n"
AGENT_COUNT=$(find ".github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$AGENT_COUNT" -ge 3 ] && ok "$AGENT_COUNT agents installed" \
  || warn "Only $AGENT_COUNT agents (expected 3+)"
for A in reviewer researcher security-auditor plan-challenger; do
  [ -f ".github/agents/${A}.agent.md" ] && ok "  @$A" \
    || warn "  Missing: ${A}.agent.md"
done

# ── [6] Skills ────────────────────────────────────────────────────────────────
printf "\n${BOLD}[6] Skills (.github/skills/)${RESET}\n"
SKILL_COUNT=$(find ".github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$SKILL_COUNT" -ge 5 ] && ok "$SKILL_COUNT skills installed" \
  || warn "Only $SKILL_COUNT skills (expected 5+)"

# ── [7] Hook JSON files ───────────────────────────────────────────────────────
printf "\n${BOLD}[7] Hooks (.github/hooks/)${RESET}\n"
HOOK_COUNT=$(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
[ "$HOOK_COUNT" -ge 7 ] && ok "$HOOK_COUNT hook JSON files" \
  || warn "Only $HOOK_COUNT/7 hook JSON files — re-run install.sh"
if command -v jq &>/dev/null; then
  HOOK_JSON_ERRORS=0
  while IFS= read -r hook_json; do
    [ -z "$hook_json" ] && continue
    if ! jq . "$hook_json" > /dev/null 2>&1; then
      fail "Invalid JSON: $(basename "$hook_json")"
      HOOK_JSON_ERRORS=$((HOOK_JSON_ERRORS + 1))
    fi
  done < <(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null)
  [ "$HOOK_JSON_ERRORS" -eq 0 ] && ok "All hook JSON is valid"
else
  warn "jq not installed — skipping JSON validation"
fi
HOOK_SCRIPT_COUNT=$(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null | wc -l | tr -d ' ')
[ "$HOOK_SCRIPT_COUNT" -ge 3 ] && ok "$HOOK_SCRIPT_COUNT hook scripts" \
  || warn "Only $HOOK_SCRIPT_COUNT hook scripts"
NOT_EXEC=0
while IFS= read -r _f; do
  [ -x "$_f" ] || NOT_EXEC=$((NOT_EXEC + 1))
done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
[ "$NOT_EXEC" -eq 0 ] && ok "All hook scripts executable" \
  || fail "$NOT_EXEC hook script(s) not executable — chmod +x .github/hooks/scripts/*.sh"

# ── [8] Shell safety in hook scripts ─────────────────────────────────────────
printf "\n${BOLD}[8] Shell safety in hook scripts${RESET}\n"
HOOK_SAFETY_ERRORS=0
while IFS= read -r hook_script; do
  [ -f "$hook_script" ] || continue
  BASENAME=$(basename "$hook_script")
  if grep -nE 'git[[:space:]]+(log|show|stash)' "$hook_script" 2>/dev/null \
     | grep -v '^[0-9]*:[[:space:]]*#' \
     | grep -vE -- '--no-pager|\| cat' \
     | grep -q '.'; then
    warn "  $BASENAME: bare git log/show without --no-pager (may hang)"
    HOOK_SAFETY_ERRORS=$((HOOK_SAFETY_ERRORS + 1))
  fi
done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
[ "$HOOK_SAFETY_ERRORS" -eq 0 ] && ok "No pager-unsafe git commands in hooks"

# ── [9] Scripts ───────────────────────────────────────────────────────────────
printf "\n${BOLD}[9] Scripts (scripts/)${RESET}\n"
REQUIRED_SCRIPTS=(
  "scripts/discover.sh"
  "scripts/_platform.sh"
  "scripts/canary-check.sh"
  "scripts/phase2-verify.sh"
  "scripts/dry-run.sh"
  "validate.sh"
)
for script in "${REQUIRED_SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    [ -x "$script" ] && ok "$script" \
      || fail "$script not executable — chmod +x $script"
  else
    fail "MISSING: $script"
  fi
done

# ── [10] Instructions ─────────────────────────────────────────────────────────
printf "\n${BOLD}[10] Instructions (.github/instructions/)${RESET}\n"
INSTR_COUNT=$(find ".github/instructions" -name '*.instructions.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$INSTR_COUNT" -ge 4 ] && ok "$INSTR_COUNT instruction files" \
  || warn "Only $INSTR_COUNT instruction files"

# ── [11] Lessons.md size ─────────────────────────────────────────────────────
printf "\n${BOLD}[11] context/tasks/lessons.md health${RESET}\n"
if [ -f "context/tasks/lessons.md" ]; then
  LESSON_LINES=$(wc -l < "context/tasks/lessons.md")
  [ "$LESSON_LINES" -le 500 ] && ok "lessons.md has $LESSON_LINES lines (healthy)" \
    || warn "lessons.md has $LESSON_LINES lines (>500 — archive old entries)"
fi

# ── [12] Reference integrity ─────────────────────────────────────────────────
printf "\n${BOLD}[12] Reference integrity${RESET}\n"
if [ -f "$INSTR" ]; then
  REF_ERRORS=0
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    [ -f "$ref" ] || { warn "Dead reference: $INSTR → '$ref'"; REF_ERRORS=$((REF_ERRORS + 1)); }
  done < <(grep -oE 'context/[a-z_/-]+\.md' "$INSTR" 2>/dev/null | sort -u || true)
  [ "$REF_ERRORS" -eq 0 ] && ok "All referenced context docs exist"
fi

# ── [13] Placeholder detection ────────────────────────────────────────────────
printf "\n${BOLD}[13] Placeholder detection${RESET}\n"
if [ -f "$INSTR" ] && ! grep -q '{{PROJECT_NAME}}' "$INSTR" 2>/dev/null; then
  ok "Bootstrapped instance — placeholder check skipped"
else
  TOTAL_PH=$(grep -rEc '\{\{[A-Z_]+\}\}' \
    "$INSTR" context/ .github/ 2>/dev/null \
    | awk -F: '{s+=$2} END {print s+0}' || echo 0)
  [ "$TOTAL_PH" -eq 0 ] && ok "No unfilled placeholders" \
    || warn "$TOTAL_PH placeholder(s) still unfilled — run /bootstrap"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Canary Results ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ${PASS_SYM} Passed: %s\n" "$PASS"
printf "  ${FAIL_SYM} Failed: %s\n" "$FAIL"
printf "  ${WARN_SYM} Warnings: %s\n" "$WARN_COUNT"
printf "\n"

if [ "$FAIL" -eq 0 ]; then
  printf "${PASS_SYM} Canary check passed!\n\n"
  exit 0
else
  printf "${FAIL_SYM} %d check(s) failed.\n\n" "$FAIL" >&2
  exit 1
fi
