#!/usr/bin/env bash
# pre-commit-quality.sh — PreToolUse hook
# Checks staged files for debugger statements, hardcoded secrets, console.log.
# Validates conventional commit message format.
# Exit code 2 = block. Stderr shown to Copilot as reason.

set -uo pipefail

INPUT=$(cat)

# Extract command using jq (camelCase for VS Code Copilot)
COMMAND=$(printf '%s' "${INPUT}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "${COMMAND}" ]]; then
  if ! command -v jq &>/dev/null; then
    printf '⚠️ pre-commit-quality: jq not installed — quality checks skipped. Install jq to enable.\n' >&2
  fi
  exit 0
fi

# Only trigger on git commit commands
if ! printf '%s' "${COMMAND}" | grep -qE 'git[[:space:]]+commit'; then
  exit 0
fi

PROJECT_DIR="${PWD}"
IS_AMEND=false
if printf '%s' "${COMMAND}" | grep -q '\-\-amend'; then
  IS_AMEND=true
fi

# Get staged files
if [[ "${IS_AMEND}" == "true" ]]; then
  STAGED=$(cd "${PROJECT_DIR}" && git diff --name-only HEAD~1 HEAD 2>/dev/null) || STAGED=""
else
  STAGED=$(cd "${PROJECT_DIR}" && git diff --cached --name-only 2>/dev/null) || STAGED=""
fi

if [[ -z "${STAGED}" ]]; then
  exit 0
fi

ISSUES=""

# Check for debugger statements
DEBUGGER_HITS=$(printf '%s\n' "${STAGED}" | grep -E '\.(js|ts|tsx|jsx|py|rb|go|rs)$' | while IFS= read -r f; do
  [[ -f "${PROJECT_DIR}/${f}" ]] && grep -nE '(debugger;|breakpoint\(\)|import pdb|binding\.pry)' "${PROJECT_DIR}/${f}" 2>/dev/null | head -3 || true
done || true)
if [[ -n "${DEBUGGER_HITS}" ]]; then
  ISSUES="${ISSUES}🛑 DEBUGGER statements found in staged files:\n${DEBUGGER_HITS}\n\n"
fi

# Check for hardcoded secrets
SECRET_HITS=$(printf '%s\n' "${STAGED}" | grep -E '\.(js|ts|tsx|jsx|py|rb|go|rs|json|yaml|yml)$' | while IFS= read -r f; do
  [[ -f "${PROJECT_DIR}/${f}" ]] && grep -nEi '(api[_-]?key|secret[_-]?key|password|private[_-]?key)[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9+/=]{20,}' "${PROJECT_DIR}/${f}" 2>/dev/null | head -3 || true
done || true)
if [[ -n "${SECRET_HITS}" ]]; then
  ISSUES="${ISSUES}🛑 Possible HARDCODED SECRETS in staged files:\n${SECRET_HITS}\n\n"
fi

# Warn on console.log (non-blocking)
LOG_HITS=$(printf '%s\n' "${STAGED}" | grep -E '\.(js|ts|tsx|jsx)$' | while IFS= read -r f; do
  [[ -f "${PROJECT_DIR}/${f}" ]] && grep -n 'console\.log' "${PROJECT_DIR}/${f}" 2>/dev/null | head -3 || true
done || true)
if [[ -n "${LOG_HITS}" ]]; then
  printf '⚠️ console.log found in staged files (review before pushing):\n%s\n' "${LOG_HITS}" | head -8
fi

# Block if critical issues found
if [[ -n "${ISSUES}" ]]; then
  printf '%b\n' "${ISSUES}" >&2
  printf 'Fix the issues above before committing.\n' >&2
  exit 2
fi

# Validate conventional commit format (non-amend only)
if [[ "${IS_AMEND}" == "false" ]]; then
  COMMIT_MSG=$(printf '%s\n' "${COMMAND}" | sed -nE 's/.*-m[[:space:]]+"([^"]+)".*/\1/p')
  [[ -z "${COMMIT_MSG}" ]] && COMMIT_MSG=$(printf '%s\n' "${COMMAND}" | sed -nE "s/.*-m[[:space:]]+'([^']+)'.*/\\1/p")
  if [[ -n "${COMMIT_MSG}" ]]; then
    if ! printf '%s' "${COMMIT_MSG}" | grep -qE '^(feat|fix|docs|refactor|test|chore|build|ci|perf|revert)(\(.+\))?!?:[[:space:]].+'; then
      printf '⚠️ Commit message does not follow conventional format: <type>(<scope>): <description>\n' >&2
      printf '   Types: feat|fix|docs|refactor|test|chore|build|ci|perf|revert\n' >&2
    fi
  fi
fi

exit 0
