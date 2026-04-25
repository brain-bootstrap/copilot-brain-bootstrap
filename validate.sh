#!/usr/bin/env bash
# validate.sh — Copilot Brain Bootstrap validation
# Checks template completeness, component integrity, and configuration health.
# Usage: bash validate.sh [target-dir]
# Exit: 0 if all checks pass, 1 if any fail

# ─── Source guard — prevent env corruption if sourced ─────────────
if [[  "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "❌ validate.sh must be EXECUTED, not sourced." >&2
  return 1 2>/dev/null || exit 1
fi

set -uo pipefail

TARGET_DIR="${1:-$PWD}"
PASS=0
FAIL=0
WARN_COUNT=0

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

ok()   { printf "${GREEN}✅${RESET} %s\n" "$*"; PASS=$((PASS + 1)); }
fail() { printf "${RED}❌${RESET} %s\n" "$*"; FAIL=$((FAIL + 1)); }
warn() { printf "${YELLOW}⚠️${RESET}  %s\n" "$*"; WARN_COUNT=$((WARN_COUNT + 1)); }

cd "${TARGET_DIR}" || exit 1

printf "\n${BOLD}━━━ Copilot Brain Validation ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ᗺB  Brain Bootstrap  ·  Copilot  ·  by brain-bootstrap\n"
printf "Target: %s\n\n" "${TARGET_DIR}"

# ── 0. Template integrity ────────────────────────────────────────────────────
IS_TEMPLATE=false
if [ -f "context/bootstrap/PROMPT.md" ] && [ -f "context/bootstrap/REFERENCE.md" ] && \
   [ -d "context/_examples" ] && [ -f "scripts/discover.sh" ] && \
   [ -f "context/docs/DETAILED_GUIDE.md" ]; then
  _HAS_MANIFEST=false
  for _m in package.json Cargo.toml go.mod pyproject.toml pom.xml build.gradle \
            pubspec.yaml mix.exs setup.py requirements.txt composer.json Gemfile \
            CMakeLists.txt Makefile deno.json; do
    [ -f "$_m" ] && _HAS_MANIFEST=true && break
  done
  if ! $_HAS_MANIFEST; then IS_TEMPLATE=true; fi
fi

if $IS_TEMPLATE; then
  printf "${BOLD}[0] Template integrity (template repo self-check)${RESET}\n"
  if grep -q '{{PROJECT_NAME}}' .github/copilot-instructions.md 2>/dev/null; then
    ok "copilot-instructions.md {{PROJECT_NAME}} placeholder intact"
  else
    fail "copilot-instructions.md missing {{PROJECT_NAME}} — template corrupted! Restore: git checkout -- .github/copilot-instructions.md"
  fi
  _PH_COUNT=$(grep -rEc '\{\{[A-Z_]+\}\}' .github/copilot-instructions.md context/ .github/ 2>/dev/null \
    | awk -F: '{s+=$2} END {print s+0}' || echo 0)
  if [ "$_PH_COUNT" -ge 20 ]; then
    ok "Template has $_PH_COUNT placeholders (healthy)"
  else
    fail "Template only has $_PH_COUNT placeholders (expected 20+) — likely corrupted"
  fi
  printf "\n${BOLD}[0b] Community files (template repo only)${RESET}\n"
  for _cf in ".github/PULL_REQUEST_TEMPLATE.md" \
             ".github/ISSUE_TEMPLATE/bug-report.yml" \
             ".github/workflows/ci.yml"; do
    [ -f "$_cf" ] && ok "$_cf" || fail "MISSING: $_cf"
  done
  for _cf in CONTRIBUTING.md .shellcheckrc; do
    [ -f "$_cf" ] && ok "$_cf" || warn "MISSING: $_cf (template admin file — optional in user repos)"
  done
  printf "\n"
fi

# ── 1. Core instruction file ──────────────────────────────────────────────────
printf "${BOLD}[1] Core instruction file${RESET}\n"
if [ -f ".github/copilot-instructions.md" ]; then
  ok ".github/copilot-instructions.md exists"
  SIZE=$(wc -c < ".github/copilot-instructions.md" 2>/dev/null || echo "0")
  if [ "${SIZE}" -gt 4096 ]; then
    warn "copilot-instructions.md is ${SIZE} bytes — Copilot budget is ~4KB. Consider trimming."
  else
    ok "Size: ${SIZE} bytes (within 4KB budget)"
  fi
  INSTR_LINES=$(wc -l < ".github/copilot-instructions.md" 2>/dev/null || echo "0")
  if [ "${INSTR_LINES}" -le 120 ]; then
    ok "copilot-instructions.md: ${INSTR_LINES} lines (healthy)"
  else
    warn "copilot-instructions.md: ${INSTR_LINES} lines (>120 — context budget risk)"
  fi
else
  fail ".github/copilot-instructions.md missing — run install.sh"
fi

# ── 2. Knowledge layer ────────────────────────────────────────────────────────
printf "\n${BOLD}[2] Knowledge layer (context/)${RESET}\n"
REQUIRED_DOCS="rules.md architecture.md build.md templates.md terminal-safety.md cve-policy.md decisions.md plugins.md"
for DOC in ${REQUIRED_DOCS}; do
  [ -f "context/${DOC}" ] && ok "context/${DOC}" || fail "context/${DOC} missing"
done

REQUIRED_TASKS="todo.md lessons.md COPILOT_ERRORS.md"
for T in ${REQUIRED_TASKS}; do
  [ -f "context/tasks/${T}" ] && ok "context/tasks/${T}" || fail "context/tasks/${T} missing"
done

if [ -f "context/tasks/lessons.md" ]; then
  LESSON_LINES=$(wc -l < "context/tasks/lessons.md")
  if [ "$LESSON_LINES" -gt 500 ]; then
    warn "context/tasks/lessons.md exceeds 500 lines ($LESSON_LINES) — archive old entries"
  else
    ok "context/tasks/lessons.md size OK ($LESSON_LINES lines)"
  fi
fi

# ── 3. Prompts ────────────────────────────────────────────────────────────────
printf "\n${BOLD}[3] Prompts (.github/prompts/)${RESET}\n"
PROMPT_COUNT=$(find ".github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${PROMPT_COUNT}" -ge 10 ]]; then
  ok "${PROMPT_COUNT} prompts installed"
else
  fail "Only ${PROMPT_COUNT} prompts found (minimum: 10) — run install.sh"
fi

for P in plan debug review mr bootstrap health lint test; do
  [ -f ".github/prompts/${P}.prompt.md" ] && ok "  /prompt: ${P}" \
    || warn "  Missing key prompt: ${P}.prompt.md"
done

# ── 4. Agents ─────────────────────────────────────────────────────────────────
printf "\n${BOLD}[4] Agents (.github/agents/)${RESET}\n"
AGENT_COUNT=$(find ".github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${AGENT_COUNT}" -ge 3 ]]; then
  ok "${AGENT_COUNT} agents installed"
else
  fail "Only ${AGENT_COUNT} agents found (minimum: 3) — run install.sh"
fi

for A in reviewer researcher security-auditor plan-challenger; do
  [ -f ".github/agents/${A}.agent.md" ] && ok "  @${A}" \
    || warn "  Missing key agent: ${A}.agent.md"
done

# ── 5. Hooks ──────────────────────────────────────────────────────────────────
printf "\n${BOLD}[5] Hooks (.github/hooks/)${RESET}\n"
HOOK_COUNT=$(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${HOOK_COUNT}" -ge 7 ]]; then
  ok "${HOOK_COUNT} hook JSON files installed"
elif [[ "${HOOK_COUNT}" -ge 4 ]]; then
  warn "${HOOK_COUNT} hook files (full set is 7) — consider re-running install.sh"
else
  fail "Only ${HOOK_COUNT} hook files found (minimum: 4) — run install.sh"
fi

# Check hook scripts are executable
if [ -d ".github/hooks/scripts" ]; then
  NOT_EXEC=0
  while IFS= read -r _f; do
    [ -x "${_f}" ] || NOT_EXEC=$((NOT_EXEC + 1))
  done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
  if [ "${NOT_EXEC}" -gt 0 ]; then
    fail "${NOT_EXEC} hook script(s) not executable — run: chmod +x .github/hooks/scripts/*.sh"
  else
    ok "All hook scripts are executable"
  fi
fi

# Validate hook JSON files
if command -v jq &>/dev/null; then
  HOOK_JSON_ERRORS=0
  while IFS= read -r hook_json; do
    [ -z "$hook_json" ] && continue
    if ! jq . "$hook_json" > /dev/null 2>&1; then
      fail "Invalid JSON: $hook_json"
      HOOK_JSON_ERRORS=$((HOOK_JSON_ERRORS + 1))
    fi
  done < <(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null)
  [ "$HOOK_JSON_ERRORS" -eq 0 ] && ok "All hook JSON files are valid JSON"
else
  warn "jq not installed — cannot validate hook JSON files"
fi

# ── 6. Skills ─────────────────────────────────────────────────────────────────
printf "\n${BOLD}[6] Skills (.github/skills/)${RESET}\n"
SKILL_COUNT=$(find ".github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${SKILL_COUNT}" -ge 49 ]]; then
  ok "${SKILL_COUNT} skills installed"
elif [[ "${SKILL_COUNT}" -ge 18 ]]; then
  warn "${SKILL_COUNT} skills (full set is 49) — consider re-running install.sh"
else
  fail "Only ${SKILL_COUNT} skills found (minimum: 5) — run install.sh"
fi

# Verify skill name frontmatter matches directory
SKILL_NAME_ERRORS=0
while IFS= read -r -d '' SKILL_FILE; do
  DIR_NAME=$(basename "$(dirname "${SKILL_FILE}")")
  FRONTMATTER_NAME=$(grep -m1 '^name:' "${SKILL_FILE}" 2>/dev/null \
    | sed 's/^name:[[:space:]]*//' | tr -d '"' || echo "")
  if [ "${FRONTMATTER_NAME}" != "${DIR_NAME}" ]; then
    warn "Skill name mismatch: ${DIR_NAME}/ has name: '${FRONTMATTER_NAME}'"
    SKILL_NAME_ERRORS=$((SKILL_NAME_ERRORS + 1))
  fi
done < <(find ".github/skills" -name 'SKILL.md' -print0 2>/dev/null)
[ "${SKILL_NAME_ERRORS}" -eq 0 ] && ok "All skill names match their directory names"

# ── 7. Instructions ───────────────────────────────────────────────────────────
printf "\n${BOLD}[7] Instructions (.github/instructions/)${RESET}\n"
INSTR_COUNT=$(find ".github/instructions" -name '*.instructions.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${INSTR_COUNT}" -ge 9 ]]; then
  ok "${INSTR_COUNT} instruction file(s) installed"
elif [[ "${INSTR_COUNT}" -ge 4 ]]; then
  warn "${INSTR_COUNT} instruction files (full set is 9) — consider re-running install.sh"
else
  fail "Only ${INSTR_COUNT} instruction files found (minimum: 4) — run install.sh"
fi

# ── 8. Scripts ──────────────────────────────────────────────────────────────────────────
printf "\n${BOLD}[8] Scripts (scripts/)${RESET}\n"
REQUIRED_SCRIPTS=(
  "scripts/discover.sh"
  "scripts/_platform.sh"
  "scripts/canary-check.sh"
  "scripts/phase2-verify.sh"
  "scripts/populate-templates.sh"
  "scripts/portability-lint.sh"
  "scripts/post-bootstrap-validate.sh"
  "scripts/integration-test.sh"
  "scripts/migrate-tasks.sh"
  "scripts/setup-plugins.sh"
  "scripts/dry-run.sh"
  "validate.sh"
)
for script in "${REQUIRED_SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    if [ -x "$script" ]; then
      ok "$script (executable)"
    else
      fail "$script exists but NOT executable — run: chmod +x $script"
    fi
  else
    fail "MISSING: $script"
  fi
done

# ── 9. Placeholder check ───────────────────────────────────────────────────────────
printf "\n${BOLD}[9] Placeholder detection${RESET}\n"
if [ -f ".github/copilot-instructions.md" ] && \
   ! grep -q '{{PROJECT_NAME}}' .github/copilot-instructions.md 2>/dev/null; then
  ok "Bootstrapped instance detected — placeholder check not applicable"
else
  PLACEHOLDER_COUNT=$(grep -rEc '\{\{[A-Z_]+\}\}' \
    .github/copilot-instructions.md context/ 2>/dev/null \
    | awk -F: '{s+=$2} END {print s+0}' || echo 0)
  if [ "${PLACEHOLDER_COUNT}" -eq 0 ]; then
    ok "No unfilled placeholders found"
  else
    warn "${PLACEHOLDER_COUNT} unfilled placeholder(s) found — run /bootstrap to fill them"
  fi
fi

# ── 10. Domain-free check ────────────────────────────────────────────────────────
printf "\n${BOLD}[10] Domain-free verification${RESET}\n"
if [ -f ".github/copilot-instructions.md" ] && \
   ! grep -q '{{PROJECT_NAME}}' .github/copilot-instructions.md 2>/dev/null; then
  ok "Domain-free check SKIPPED (bootstrapped — {{PROJECT_NAME}} replaced)"
else
  FORBIDDEN_TERMS='my-company|my-project|example\.com|TODO_REPLACE'
  HITS=$(grep -rniE "$FORBIDDEN_TERMS" \
    .github/copilot-instructions.md context/ .github/prompts/ \
    --include='*.md' --include='*.json' 2>/dev/null \
    | grep -v '.git/' \
    | grep -v 'validate.sh' \
    | grep -v '_template' \
    | grep -v '_examples' \
    | grep -v 'context/tasks/' \
    | grep -v 'context/docs/' \
    | grep -v 'CONTRIBUTING' \
    || true)
  if [ -z "$HITS" ]; then
    ok "No forbidden domain references found"
  else
    fail "Forbidden domain references found:"
    echo "$HITS" | head -10
  fi
fi

# ── 11. Reference integrity ────────────────────────────────────────────────────────
printf "\n${BOLD}[11] Reference integrity${RESET}\n"
DOC_WARNINGS=0
if [ -f ".github/copilot-instructions.md" ]; then
  REFERENCED_DOCS=$(grep -oE 'context/[a-z_/-]+\.md' .github/copilot-instructions.md 2>/dev/null \
    | sort -u || true)
  for DOC in $REFERENCED_DOCS; do
    if [ ! -f "$DOC" ]; then
      warn "copilot-instructions.md references '$DOC' but file does not exist"
      DOC_WARNINGS=$((DOC_WARNINGS + 1))
    fi
  done
  [ "$DOC_WARNINGS" -eq 0 ] && ok "All referenced context docs exist"
fi

STALE_FOUND=0
while IFS= read -r hook_script; do
  [ -f "$hook_script" ] || continue
  BASENAME=$(basename "$hook_script")
  if grep -nE 'git[[:space:]]+(log|show|stash)' "$hook_script" 2>/dev/null \
     | grep -v '^[0-9]*:[[:space:]]*#' \
     | grep -vE -- '--no-pager|\| cat' \
     | grep -q '.'; then
    warn "Hook $BASENAME has bare git log/show/stash without --no-pager — may trigger pager"
    STALE_FOUND=$((STALE_FOUND + 1))
  fi
done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
[ "$STALE_FOUND" -eq 0 ] && ok "No pager-unsafe patterns in hook scripts"

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Results ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ✅ Passed: %s\n" "${PASS}"
printf "  ❌ Failed: %s\n" "${FAIL}"
printf "  ⚠️  Warnings: %s\n" "${WARN_COUNT}"
printf "\n"

if [[ "${FAIL}" -eq 0 ]]; then
  printf "${GREEN}${BOLD}✓ Brain Bootstrap validation passed!${RESET}\n\n"
  exit 0
else
  printf "${RED}${BOLD}✗ ${FAIL} check(s) failed. Run install.sh to fix.${RESET}\n\n"
  exit 1
fi
