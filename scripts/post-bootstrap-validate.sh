#!/usr/bin/env bash
# post-bootstrap-validate.sh — Run after /bootstrap to auto-fix common issues
# and confirm the repo is in a valid state for use.
# Usage: bash scripts/post-bootstrap-validate.sh [PROJECT_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-${BRAIN_PROJECT_DIR:-$SCRIPT_DIR}}"
cd "$PROJECT_DIR"

BOLD="\033[1m"; RESET="\033[0m"; GREEN="\033[0;32m"; RED="\033[0;31m"

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; PASS=$((PASS + 1)); }
warn() { printf "  ${WARN_SYM} %s\n" "$1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { printf "  ${FAIL_SYM} %s\n" "$1" >&2; FAIL=$((FAIL + 1)); }
fixed(){ printf "  ${PASS_SYM} AUTO-FIXED: %s\n" "$1"; FIXES=$((FIXES + 1)); }

PASS=0; FAIL=0; WARN_COUNT=0; FIXES=0

printf "${BOLD}━━━ Copilot Brain Bootstrap — Post-Bootstrap Validation ━━━${RESET}\n"
printf "Project: %s\n\n" "$PROJECT_DIR"

# ── IS_TEMPLATE detection ─────────────────────────────────────────
IS_TEMPLATE=false
if [ -f "context/bootstrap/PROMPT.md" ] && [ -d "context/_examples" ] && \
   [ -f "scripts/discover.sh" ] && [ -f "context/docs/DETAILED_GUIDE.md" ]; then
  _HAS_MANIFEST=false
  for _m in package.json Cargo.toml go.mod pyproject.toml pom.xml build.gradle \
            pubspec.yaml mix.exs requirements.txt composer.json Gemfile CMakeLists.txt; do
    [ -f "$_m" ] && _HAS_MANIFEST=true && break
  done
  $_HAS_MANIFEST || IS_TEMPLATE=true
fi

if $IS_TEMPLATE; then
  warn "Running in template repo — skipping project-specific checks"
  warn "Run this script in a bootstrapped project directory instead"
fi

# ── [1] Fix hook script permissions ──────────────────────────────
printf "${BOLD}[1] Hook script permissions${RESET}\n"
if [ -d ".github/hooks/scripts" ]; then
  FIXED_PERMS=0
  while IFS= read -r hook_script; do
    [ -x "$hook_script" ] && continue
    chmod +x "$hook_script"
    fixed "chmod +x $(basename "$hook_script")"
    FIXED_PERMS=$((FIXED_PERMS + 1))
  done < <(find ".github/hooks/scripts" -name '*.sh' 2>/dev/null)
  [ "$FIXED_PERMS" -eq 0 ] && ok "All hook scripts already executable"
else
  warn ".github/hooks/scripts not found — run install.sh first"
fi

# Fix validate.sh permissions
[ -x "validate.sh" ] || { chmod +x validate.sh 2>/dev/null && fixed "chmod +x validate.sh" || true; }

# ── [2] Placeholder check ─────────────────────────────────────────
printf "\n${BOLD}[2] Placeholder detection${RESET}\n"
if ! $IS_TEMPLATE && [ -f ".github/copilot-instructions.md" ]; then
  OPEN_PH=$(grep -rEc '\{\{[A-Z_]+\}\}' \
    .github/copilot-instructions.md context/ 2>/dev/null \
    | awk -F: '{s+=$2} END {print s+0}' || echo 0)
  if [ "$OPEN_PH" -eq 0 ]; then
    ok "No unfilled placeholders"
  else
    warn "$OPEN_PH placeholder(s) still unfilled — run: bash scripts/populate-templates.sh"
  fi
fi

# ── [3] Domain doc stubs ──────────────────────────────────────────
printf "\n${BOLD}[3] Domain doc stubs${RESET}\n"
if [ -f ".github/copilot-instructions.md" ]; then
  REFERENCED=$(grep -oE 'context/[a-z_/-]+\.md' .github/copilot-instructions.md 2>/dev/null \
    | sort -u || true)
  MISSING_REFS=0
  for doc_ref in $REFERENCED; do
    if [ ! -f "$doc_ref" ]; then
      warn "Referenced doc missing: $doc_ref — create a stub"
      MISSING_REFS=$((MISSING_REFS + 1))
    fi
  done
  [ "$MISSING_REFS" -eq 0 ] && ok "All referenced context docs exist"
fi

# ── [4] Phantom file check ────────────────────────────────────────
printf "\n${BOLD}[4] Phantom file check${RESET}\n"
PHANTOM_PATTERNS=(".DS_Store" "Thumbs.db" "*.swp" "*.swo" "*.orig" "*.bak" "*.tmp")
PHANTOM_FOUND=0
for pattern in "${PHANTOM_PATTERNS[@]}"; do
  while IFS= read -r pf; do
    [ -z "$pf" ] && continue
    warn "Phantom file found: $pf"
    PHANTOM_FOUND=$((PHANTOM_FOUND + 1))
  done < <(find . -name "$pattern" -not -path './.git/*' 2>/dev/null)
done
[ "$PHANTOM_FOUND" -eq 0 ] && ok "No phantom files found"

# ── [5] Run validate.sh ───────────────────────────────────────────
printf "\n${BOLD}[5] Running validate.sh${RESET}\n"
if [ -f "validate.sh" ]; then
  if bash validate.sh "$PROJECT_DIR" 2>&1; then
    ok "validate.sh passed"
  else
    fail "validate.sh reported failures — see above"
  fi
else
  fail "validate.sh not found — run install.sh"
fi

# ── [6] Run canary-check.sh ───────────────────────────────────────
if [ -f "scripts/canary-check.sh" ]; then
  printf "\n${BOLD}[6] Running canary-check.sh${RESET}\n"
  if bash scripts/canary-check.sh "$PROJECT_DIR" 2>&1; then
    ok "canary-check.sh passed"
  else
    fail "canary-check.sh reported failures"
  fi
fi

# ── Summary ───────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Post-Bootstrap Results ━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ${PASS_SYM} Passed:    %s\n" "$PASS"
printf "  ${FAIL_SYM} Failed:    %s\n" "$FAIL"
printf "  ${WARN_SYM} Warnings:  %s\n" "$WARN_COUNT"
printf "  Auto-fixed: %s\n" "$FIXES"
printf "\n"

if [ "$FAIL" -eq 0 ]; then
  printf "${GREEN}${BOLD}✓ Post-bootstrap validation passed!${RESET}\n\n"
  exit 0
else
  printf "${RED}${BOLD}✗ %d check(s) failed — fix before committing.${RESET}\n\n" "$FAIL" >&2
  exit 1
fi
