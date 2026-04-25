#!/usr/bin/env bash
# populate-templates.sh — Fill {{PLACEHOLDER}} values in config files after /bootstrap
# Replaces PROJECT_NAME, TECH_STACK, TEAM_NAME, etc. from .discovery.env or interactive input.
# Usage: bash scripts/populate-templates.sh [PROJECT_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:-${BRAIN_PROJECT_DIR:-$SCRIPT_DIR}}"
cd "$PROJECT_DIR"

BOLD="\033[1m"; RESET="\033[0m"; YELLOW="\033[0;33m"

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; }
warn() { printf "  ${WARN_SYM} %s\n" "$1"; }
note() { printf "  ${YELLOW}--${RESET} %s\n" "$1"; }

# ─── Self-bootstrap guard ─────────────────────────────────────────
REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if echo "$REMOTE" | grep -q 'copilot-brain-bootstrap'; then
  printf "${WARN_SYM} This script should not be run on the template repo itself.\n"
  printf "   Run it in a bootstrapped project instead.\n"
  exit 1
fi

printf "${BOLD}Copilot Brain Bootstrap — Populate Templates${RESET}\n"
printf "Project: %s\n\n" "$PROJECT_DIR"

# ─── Load values from .discovery.env ─────────────────────────────
DISCOVERY_ENV="context/tasks/.discovery.env"
declare -A VARS

if [ -f "$DISCOVERY_ENV" ]; then
  # shellcheck disable=SC1090
  source "$DISCOVERY_ENV"
  ok "Loaded values from $DISCOVERY_ENV"
fi

# Key variables to replace
PROJECT_NAME="${PROJECT_NAME:-${VARS[PROJECT_NAME]:-}}"
TECH_STACK="${TECH_STACK:-${VARS[TECH_STACK]:-}}"
TEAM_NAME="${TEAM_NAME:-${VARS[TEAM_NAME]:-}}"

# Prompt for missing values
if [ -z "$PROJECT_NAME" ]; then
  printf "Enter PROJECT_NAME (e.g. my-awesome-app): "
  read -r PROJECT_NAME
fi
if [ -z "$TECH_STACK" ]; then
  printf "Enter TECH_STACK (e.g. Node.js + TypeScript): "
  read -r TECH_STACK
fi
if [ -z "$TEAM_NAME" ]; then
  printf "Enter TEAM_NAME (e.g. Platform Team): "
  read -r TEAM_NAME
fi

printf "\n${BOLD}Values:${RESET}\n"
printf "  PROJECT_NAME = %s\n" "$PROJECT_NAME"
printf "  TECH_STACK   = %s\n" "$TECH_STACK"
printf "  TEAM_NAME    = %s\n\n" "$TEAM_NAME"

# ─── Target files ─────────────────────────────────────────────────
TARGET_FILES=(
  ".github/copilot-instructions.md"
  "context/architecture.md"
  "context/rules.md"
  "context/build.md"
  "context/templates.md"
)

REPLACED=0
SKIPPED=0

for file in "${TARGET_FILES[@]}"; do
  [ -f "$file" ] || { warn "$file not found — skipping"; SKIPPED=$((SKIPPED + 1)); continue; }

  PH_COUNT=$(grep -cE '\{\{[A-Z_]+\}\}' "$file" 2>/dev/null || echo 0)
  if [ "$PH_COUNT" -eq 0 ]; then
    note "$file — no placeholders (already filled or N/A)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  sed_inplace "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$file"
  sed_inplace "s/{{TECH_STACK}}/$TECH_STACK/g"     "$file"
  sed_inplace "s/{{TEAM_NAME}}/$TEAM_NAME/g"       "$file"

  REMAINING=$(grep -cE '\{\{[A-Z_]+\}\}' "$file" 2>/dev/null || echo 0)
  if [ "$REMAINING" -gt 0 ]; then
    warn "$file — $REMAINING placeholder(s) still unfilled (need manual fill)"
  else
    ok "$file — all placeholders filled"
    REPLACED=$((REPLACED + 1))
  fi
done

printf "\n${BOLD}Summary:${RESET} %d files updated, %d skipped.\n" "$REPLACED" "$SKIPPED"
STILL_OPEN=$(grep -rEc '\{\{[A-Z_]+\}\}' \
  .github/copilot-instructions.md context/ 2>/dev/null \
  | awk -F: '{s+=$2} END {print s+0}' || echo 0)
if [ "$STILL_OPEN" -gt 0 ]; then
  warn "$STILL_OPEN placeholder(s) still need manual attention."
else
  printf "${PASS_SYM} All placeholders filled!\n\n"
fi
