#!/usr/bin/env bash
# migrate-tasks.sh — Migrate context/tasks files from a previous project installation
# Preserves existing lessons.md, todo.md, COPILOT_ERRORS.md when upgrading.
# Usage: bash scripts/migrate-tasks.sh [SOURCE_DIR] [DEST_DIR]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="${1:-}"
DEST_DIR="${2:-$SCRIPT_DIR}"

BOLD="\033[1m"; RESET="\033[0m"

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; }
warn() { printf "  ${WARN_SYM} %s\n" "$1"; }
fail() { printf "  ${FAIL_SYM} %s\n" "$1" >&2; ERRORS=$((ERRORS + 1)); }

ERRORS=0
MIGRATED=0
SKIPPED=0

printf "${BOLD}Copilot Brain Bootstrap — Task Migration${RESET}\n\n"

# Auto-detect source if not provided
if [ -z "$SOURCE_DIR" ]; then
  for candidate in "$HOME/.copilot-brain" "$HOME/.github" "$PWD/.github" \
                   "/tmp/copilot-brain-backup" "$DEST_DIR/context/tasks"; do
    if [ -d "$candidate" ] && [ -f "$candidate/../context/tasks/lessons.md" ] 2>/dev/null; then
      SOURCE_DIR="$candidate/.."
      break
    fi
  done
fi

CONTEXT_TASKS="$DEST_DIR/context/tasks"
mkdir -p "$CONTEXT_TASKS"

TASK_FILES=(
  "lessons.md"
  "todo.md"
  "COPILOT_ERRORS.md"
  "bootstrap-report.md"
  ".bootstrap-plan.txt"
  ".bootstrap-progress.txt"
  ".discovery.env"
  ".permission-denials.log"
)

if [ -z "$SOURCE_DIR" ]; then
  printf "No source directory found or provided.\n"
  printf "Usage: %s <source_dir> [dest_dir]\n" "$(basename "$0")"
  printf "  source_dir: directory containing context/tasks/\n"
  printf "  dest_dir:   defaults to repo root\n\n"

  printf "Checking for existing task files to preserve:\n"
  for f in "${TASK_FILES[@]}"; do
    DEST_FILE="$CONTEXT_TASKS/$f"
    if [ -f "$DEST_FILE" ]; then
      LINES=$(wc -l < "$DEST_FILE" | tr -d ' ')
      ok "$f ($LINES lines — preserved)"
    else
      warn "$f not found at $DEST_FILE"
    fi
  done
  exit 0
fi

SOURCE_TASKS="$SOURCE_DIR/context/tasks"
if [ ! -d "$SOURCE_TASKS" ]; then
  fail "Source tasks dir not found: $SOURCE_TASKS"
  exit 1
fi

printf "Source: %s\n" "$SOURCE_TASKS"
printf "Dest:   %s\n\n" "$CONTEXT_TASKS"

# Create backup of dest before migrating
BACKUP_FILE="$CONTEXT_TASKS/.pre-upgrade-backup.tar.gz"
if [ "$(ls -A "$CONTEXT_TASKS" 2>/dev/null)" ]; then
  tar -czf "$BACKUP_FILE" -C "$CONTEXT_TASKS" . 2>/dev/null \
    && ok "Backup created: context/tasks/.pre-upgrade-backup.tar.gz" \
    || warn "Could not create backup (non-fatal)"
fi

printf "\n${BOLD}Migrating task files:${RESET}\n"
for f in "${TASK_FILES[@]}"; do
  SRC="$SOURCE_TASKS/$f"
  DST="$CONTEXT_TASKS/$f"

  [ -f "$SRC" ] || continue

  if [ -f "$DST" ]; then
    SRC_SIZE=$(wc -c < "$SRC" | tr -d ' ')
    DST_SIZE=$(wc -c < "$DST" | tr -d ' ')
    if [ "$DST_SIZE" -ge "$SRC_SIZE" ]; then
      ok "$f — dest newer/equal (kept, skipped source)"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi
    warn "$f — source is larger; merging (appending new entries)"
    {
      printf "\n\n---\n<!-- Migrated from previous install on %s -->\n\n" "$(date +%Y-%m-%d)"
      cat "$SRC"
    } >> "$DST"
    MIGRATED=$((MIGRATED + 1))
  else
    cp "$SRC" "$DST"
    ok "$f — copied from source"
    MIGRATED=$((MIGRATED + 1))
  fi
done

# Update copilot-instructions.md references
INSTR_FILE="$DEST_DIR/.github/copilot-instructions.md"
if [ -f "$INSTR_FILE" ]; then
  printf "\n${BOLD}Updating copilot-instructions.md references:${RESET}\n"
  sed_inplace "s|claude/tasks/lessons\.md|context/tasks/lessons.md|g" "$INSTR_FILE"
  sed_inplace "s|claude/tasks/todo\.md|context/tasks/todo.md|g" "$INSTR_FILE"
  sed_inplace "s|CLAUDE_ERRORS\.md|COPILOT_ERRORS.md|g" "$INSTR_FILE"
  ok "Updated task file references in copilot-instructions.md"
fi

printf "\n${BOLD}Summary:${RESET} %d migrated, %d skipped.\n" "$MIGRATED" "$SKIPPED"
if [ "$ERRORS" -eq 0 ]; then
  printf "${PASS_SYM} Migration complete.\n\n"
  exit 0
else
  printf "${FAIL_SYM} Migration completed with %d error(s).\n\n" "$ERRORS" >&2
  exit 1
fi
