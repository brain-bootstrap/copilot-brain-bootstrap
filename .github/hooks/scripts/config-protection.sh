#!/usr/bin/env bash
# config-protection.sh — PreToolUse hook for file write tools
# Blocks modifications to shared config files (biome.json, tsconfig, eslintrc, .vscode, .idea, etc.)
# unless explicitly approved by the user.
# Exit code 2 = block tool use. Stderr shown to Copilot as reason.

set -uo pipefail

INPUT=$(cat)

# Extract the file path — VS Code Copilot uses camelCase (filePath)
FILE_PATH=$(printf '%s' "${INPUT}" | jq -r '.tool_input.filePath // .tool_input.file_path // ""' 2>/dev/null || echo "")

if [[ -z "${FILE_PATH}" ]]; then
  exit 0  # No file path, allow
fi

# ── IDE / editor config files ────────────────────────────────────────────────
if echo "${FILE_PATH}" | grep -qE '\.vscode/|\.idea/|\.cursor/' 2>/dev/null; then
  printf '⛔ BLOCKED: Modification of IDE config files requires explicit user request.\nFile: %s\n' "${FILE_PATH}" >&2
  exit 2
fi

# ── Shared project config files ─────────────────────────────────────────────
PROTECTED_PATTERNS='biome\.json|tsconfig.*\.json|\.eslintrc|\.eslintrc\.js|\.eslintrc\.json|\.eslintrc\.yml|\.prettierrc|\.prettierrc\.json|webpack\.config|vite\.config|rollup\.config|babel\.config'

if echo "${FILE_PATH}" | grep -qE "${PROTECTED_PATTERNS}" 2>/dev/null; then
  printf '⚠️ WARNING: Modifying shared config: %s\nEnsure this change was explicitly requested and does not affect other team members.\n' "${FILE_PATH}" >&2
  # Non-blocking warning — agents should proceed carefully but aren't hard-blocked
  exit 0
fi

# ── CI/CD pipeline files ─────────────────────────────────────────────────────
if echo "${FILE_PATH}" | grep -qE '\.github/workflows/|\.gitlab-ci\.yml|Jenkinsfile|\.circleci/' 2>/dev/null; then
  printf '⚠️ WARNING: Modifying CI/CD pipeline: %s\nEnsure this change was explicitly requested.\n' "${FILE_PATH}" >&2
  exit 0
fi

exit 0
