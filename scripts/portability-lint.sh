#!/usr/bin/env bash
# portability-lint.sh — Lint shell scripts for portability issues
# Reports bash-isms and non-POSIX patterns that break on sh/dash/ash.
# Usage: bash scripts/portability-lint.sh [TARGET_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${1:-$SCRIPT_DIR}"

ERRORS=0
WARNINGS=0

pass()  { printf "  ${PASS_SYM} %s\n" "$1"; }
warn()  { printf "  ${WARN_SYM} %s\n" "$1"; WARNINGS=$((WARNINGS + 1)); }
fail()  { printf "  ${FAIL_SYM} %s\n" "$1" >&2; ERRORS=$((ERRORS + 1)); }

# ─── Pattern checks ───────────────────────────────────────────────
check() {
  local label="$1" pattern="$2" file="$3"
  if grep -Enq "$pattern" "$file" 2>/dev/null; then
    local lines
    lines=$(grep -En "$pattern" "$file" 2>/dev/null | head -3 | sed 's/^/    /')
    warn "$(basename "$file"): $label"
    printf "%s\n" "$lines"
  fi
}

printf "Copilot Brain Bootstrap — Portability Lint\n"
printf "Target: %s\n\n" "$TARGET_DIR"

SHELL_FILES=$(find "$TARGET_DIR" -name '*.sh' -not -path '*/.git/*' 2>/dev/null | sort)

if [ -z "$SHELL_FILES" ]; then
  printf "No .sh files found in %s\n" "$TARGET_DIR"
  exit 0
fi

while IFS= read -r f; do
  [ -f "$f" ] || continue

  SHEBANG=$(head -1 "$f" 2>/dev/null || echo "")
  if echo "$SHEBANG" | grep -q '#!/bin/sh'; then
    printf "[sh] Checking %s\n" "$(basename "$f")"

    check "bash array syntax"          '\[.*\]=\('                   "$f"
    check "double bracket [[ ]]"       '\[\['                        "$f"
    check "process substitution <()"   '<\s*\('                      "$f"
    check "bash (( )) arithmetic"      '\(\('                        "$f"
    check "local var in sh"            '^[[:space:]]*local '         "$f"
    check "source builtin"             '^[[:space:]]*source '        "$f"
    check "echo -e (non-portable)"     'echo[[:space:]]+-e'          "$f"
    check "print -f (ksh)"             'print[[:space:]]+-f'         "$f"
    check '${!var} indirect ref'       '\$\{![^}]+\}'                "$f"
    check '&>/dev/null (bash-ism)'     '&>/dev/null'                 "$f"
    check "declare builtin"            '^[[:space:]]*declare '       "$f"
    check "here-string <<<"            '<<<'                         "$f"
  else
    printf "[bash] %s — skipping POSIX-only checks\n" "$(basename "$f")"
  fi
done <<< "$SHELL_FILES"

printf "\n"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  printf "${PASS_SYM} No portability issues found.\n"
  exit 0
elif [ "$ERRORS" -eq 0 ]; then
  printf "${WARN_SYM} %d warning(s) found (no hard errors).\n" "$WARNINGS"
  exit 0
else
  printf "${FAIL_SYM} %d error(s), %d warning(s) found.\n" "$ERRORS" "$WARNINGS" >&2
  exit 1
fi
