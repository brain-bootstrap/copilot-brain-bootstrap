#!/usr/bin/env bash
# terminal-safety.sh — PreToolUse hook for run_in_terminal
# Blocks dangerous terminal patterns: pager-triggering commands, interactive programs, etc.
# Exit code 2 = block tool use. Stderr shown to Copilot as reason.
#
# Supports COPILOT_HOOK_PROFILE: minimal | standard (default) | strict

set -uo pipefail

# Read tool input from stdin (Copilot passes JSON via stdin)
INPUT=$(cat)

# Extract the command using jq (camelCase for VS Code Copilot)
COMMAND=$(printf '%s' "${INPUT}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "${COMMAND}" ]]; then
  if ! command -v jq &>/dev/null; then
    printf '⚠️ terminal-safety: jq not installed — safety checks skipped. Install jq to enable.\n' >&2
  fi
  exit 0  # Not a terminal command, allow
fi

PROFILE="${COPILOT_HOOK_PROFILE:-standard}"

# ── ALWAYS BLOCKED (regardless of profile) ───────────────────────────────────

# Interactive editors
if printf '%s' "${COMMAND}" | grep -qE '(^|[[:space:]])(vi|vim|nano|emacs|pico)([[:space:]]|$)'; then
  printf '⛔ BLOCKED: Interactive editor detected. Use file-writing tools instead.\n' >&2
  exit 2
fi

# Interactive docker exec
if printf '%s' "${COMMAND}" | grep -qE 'docker[[:space:]]+exec[[:space:]]+-it'; then
  printf '⛔ BLOCKED: Interactive docker exec. Use: docker exec container command\n' >&2
  exit 2
fi

# Bare interactive psql (no -c flag)
if printf '%s' "${COMMAND}" | grep -qE '(^|[[:space:]])psql[[:space:]]*$'; then
  printf '⛔ BLOCKED: Interactive psql. Use: psql -c "SQL" dbname | cat\n' >&2
  exit 2
fi

# Bare REPL / interpreter
for REPL in python3 python node ruby irb; do
  if printf '%s' "${COMMAND}" | grep -qE "(^|[[:space:]])${REPL}[[:space:]]*$"; then
    printf "⛔ BLOCKED: bare '%s' opens an interactive REPL. Use '%s -c \"...\"' instead.\n" "${REPL}" "${REPL}" >&2
    exit 2
  fi
done

# Force push to main/master
if printf '%s' "${COMMAND}" | grep -qiE 'git[[:space:]]+push.*--force.*(main|master)'; then
  printf '⛔ BLOCKED: Force push to main/master. Confirm intent explicitly.\n' >&2
  exit 2
fi

# Catastrophic rm -rf targeting root/home/all
if printf '%s' "${COMMAND}" | grep -qiE 'rm[[:space:]]+-rf[[:space:]]+(\/|~|\.\*)'; then
  printf '⛔ BLOCKED: Catastrophic rm -rf. Confirm intent explicitly.\n' >&2
  exit 2
fi

# ── STANDARD PROFILE (default): broader destructive ops ──────────────────────
if [[ "${PROFILE}" == "standard" || "${PROFILE}" == "strict" ]]; then

  # Destructive SQL
  if printf '%s' "${COMMAND}" | grep -qiE 'DROP[[:space:]]+(TABLE|DATABASE)|TRUNCATE[[:space:]]+TABLE'; then
    printf '⛔ BLOCKED: Destructive SQL detected. Confirm intent explicitly.\n' >&2
    exit 2
  fi

  # git reset --hard, chmod -R 777, docker system prune
  if printf '%s' "${COMMAND}" | grep -qiE 'git[[:space:]]+reset[[:space:]]+--hard|chmod[[:space:]]+-R[[:space:]]+777|docker[[:space:]]+system[[:space:]]+prune[[:space:]]+-a'; then
    printf '⛔ BLOCKED: Destructive system command. Confirm intent explicitly.\n' >&2
    exit 2
  fi

fi

# ── STRICT PROFILE: risky execution patterns ─────────────────────────────────
if [[ "${PROFILE}" == "strict" ]]; then

  # Pipe-to-shell execution (SECURITY CRITICAL)
  if printf '%s' "${COMMAND}" | grep -qiE 'curl.*\|[[:space:]]*(ba)?sh|wget.*\|[[:space:]]*(ba)?sh'; then
    printf '⛔ BLOCKED [strict]: Pipe-to-shell execution is a security risk. Download first, inspect, then run.\n' >&2
    exit 2
  fi

  # eval, dd to device, write to /etc
  if printf '%s' "${COMMAND}" | grep -qiE '(^|[[:space:]])eval[[:space:]]|dd[[:space:]]+if=.*of=/dev/|>[[:space:]]*/etc/|tee[[:space:]]*/etc/'; then
    printf '⛔ BLOCKED [strict]: Dangerous system command detected.\n' >&2
    exit 2
  fi

fi

# ── WARN (non-blocking): risky but sometimes needed ──────────────────────────

# sleep
if printf '%s' "${COMMAND}" | grep -qE '^sleep[[:space:]]+[0-9]+[smhd]?[[:space:]]*$'; then
  printf '⚠️ WARNING: standalone sleep. Avoid blocking — use async mode instead.\n' >&2
fi

# Git commands without --no-pager
if printf '%s' "${COMMAND}" | grep -qE 'git[[:space:]]+(log|diff|show|branch)\b'; then
  if ! printf '%s' "${COMMAND}" | grep -qE '\-\-no-pager|\|[[:space:]]*(cat|head|tail)'; then
    printf '⚠️ WARNING: git command may trigger pager. Use --no-pager or pipe to | cat\n' >&2
  fi
fi

# Docker/kubectl logs without --tail
if printf '%s' "${COMMAND}" | grep -qE '(docker|kubectl)[[:space:]]+logs\b'; then
  if ! printf '%s' "${COMMAND}" | grep -qE '\-\-tail|\|[[:space:]]*(head|tail)'; then
    printf '⚠️ WARNING: Unbounded logs. Use --tail 50 or pipe to | head -N\n' >&2
  fi
fi

exit 0
