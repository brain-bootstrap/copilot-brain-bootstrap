#!/usr/bin/env bash
# validate.sh — Copilot Brain Bootstrap validation
# Checks that all required Brain components are installed and configured.
# Usage: bash validate.sh [target-dir]

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

ok()   { printf "${GREEN}✅${RESET} %s\n" "$*"; ((PASS++)) || true; }
fail() { printf "${RED}❌${RESET} %s\n" "$*"; ((FAIL++)) || true; }
warn() { printf "${YELLOW}⚠️${RESET}  %s\n" "$*"; ((WARN_COUNT++)) || true; }

cd "${TARGET_DIR}" || exit 1

printf "\n${BOLD}━━━ Copilot Brain Validation ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "Target: %s\n\n" "${TARGET_DIR}"

# ── 1. Core instruction file ──────────────────────────────────────────────────
printf "${BOLD}[1] Core instruction file${RESET}\n"
if [[ -f ".github/copilot-instructions.md" ]]; then
  ok ".github/copilot-instructions.md exists"
  # Check size (Copilot budget is ~4KB)
  SIZE=$(wc -c < ".github/copilot-instructions.md" 2>/dev/null || echo "0")
  if [[ "${SIZE}" -gt 4096 ]]; then
    warn "copilot-instructions.md is ${SIZE} bytes — Copilot budget is ~4KB. Consider trimming."
  else
    ok "Size: ${SIZE} bytes (within 4KB budget)"
  fi
else
  fail ".github/copilot-instructions.md missing — run install.sh"
fi

# ── 2. Knowledge layer ────────────────────────────────────────────────────────
printf "\n${BOLD}[2] Knowledge layer (context/)${RESET}\n"
REQUIRED_DOCS="rules.md architecture.md build.md templates.md terminal-safety.md cve-policy.md"
for DOC in ${REQUIRED_DOCS}; do
  if [[ -f "context/${DOC}" ]]; then
    ok "context/${DOC}"
  else
    fail "context/${DOC} missing"
  fi
done

REQUIRED_TASKS="todo.md lessons.md COPILOT_ERRORS.md"
for T in ${REQUIRED_TASKS}; do
  if [[ -f "context/tasks/${T}" ]]; then
    ok "context/tasks/${T}"
  else
    fail "context/tasks/${T} missing"
  fi
done

# ── 3. Prompts ────────────────────────────────────────────────────────────────
printf "\n${BOLD}[3] Prompts (.github/prompts/)${RESET}\n"
PROMPT_COUNT=$(find ".github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${PROMPT_COUNT}" -ge 10 ]]; then
  ok "${PROMPT_COUNT} prompts installed"
else
  fail "Only ${PROMPT_COUNT} prompts found (minimum: 10) — run install.sh"
fi

# Check key prompts
for P in plan debug review mr bootstrap health; do
  if [[ -f ".github/prompts/${P}.prompt.md" ]]; then
    ok "  /prompt: ${P}"
  else
    warn "  Missing key prompt: ${P}.prompt.md"
  fi
done

# ── 4. Agents ─────────────────────────────────────────────────────────────────
printf "\n${BOLD}[4] Agents (.github/agents/)${RESET}\n"
AGENT_COUNT=$(find ".github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${AGENT_COUNT}" -ge 3 ]]; then
  ok "${AGENT_COUNT} agents installed"
else
  fail "Only ${AGENT_COUNT} agents found (minimum: 3) — run install.sh"
fi

for A in reviewer researcher security-auditor; do
  if [[ -f ".github/agents/${A}.agent.md" ]]; then
    ok "  @${A}"
  else
    warn "  Missing key agent: ${A}.agent.md"
  fi
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
if [[ -d ".github/hooks/scripts" ]]; then
  NOT_EXEC=0
  while IFS= read -r _f; do
    [[ -x "${_f}" ]] || NOT_EXEC=$((NOT_EXEC + 1))
  done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
  if [[ "${NOT_EXEC}" -gt 0 ]]; then
    fail "${NOT_EXEC} hook script(s) not executable — run: chmod +x .github/hooks/scripts/*.sh"
  else
    ok "All hook scripts are executable"
  fi
fi

# ── 6. Skills ─────────────────────────────────────────────────────────────────
printf "\n${BOLD}[6] Skills (.github/skills/)${RESET}\n"
SKILL_COUNT=$(find ".github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${SKILL_COUNT}" -ge 18 ]]; then
  ok "${SKILL_COUNT} skills installed"
elif [[ "${SKILL_COUNT}" -ge 5 ]]; then
  warn "${SKILL_COUNT} skills (full set is 18) — consider re-running install.sh"
else
  fail "Only ${SKILL_COUNT} skills found (minimum: 5) — run install.sh"
fi

# Verify skill name frontmatter matches directory
SKILL_NAME_ERRORS=0
while IFS= read -r -d '' SKILL_FILE; do
  DIR_NAME=$(basename "$(dirname "${SKILL_FILE}")")
  FRONTMATTER_NAME=$(grep -m1 '^name:' "${SKILL_FILE}" 2>/dev/null | sed 's/^name:[[:space:]]*//' | tr -d '"' || echo "")
  if [[ "${FRONTMATTER_NAME}" != "${DIR_NAME}" ]]; then
    warn "Skill name mismatch: ${DIR_NAME}/ has name: '${FRONTMATTER_NAME}'"
    ((SKILL_NAME_ERRORS++)) || true
  fi
done < <(find ".github/skills" -name 'SKILL.md' -print0 2>/dev/null)
if [[ "${SKILL_NAME_ERRORS}" -eq 0 ]]; then
  ok "All skill names match their directory names"
fi

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

# ── 8. Placeholder check ──────────────────────────────────────────────────────
printf "\n${BOLD}[8] Placeholder detection${RESET}\n"
PLACEHOLDER_COUNT=$(grep -r '{{' .github/copilot-instructions.md context/ 2>/dev/null | grep -v '^Binary' | grep -v PLACEHOLDER | wc -l | tr -d ' ')
if [[ "${PLACEHOLDER_COUNT}" -eq 0 ]]; then
  ok "No unfilled placeholders found"
else
  warn "${PLACEHOLDER_COUNT} unfilled placeholder(s) found — run /bootstrap to fill them"
fi

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
