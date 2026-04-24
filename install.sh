#!/usr/bin/env bash
# install.sh — Copilot Brain Bootstrap installer
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/brain-bootstrap/copilot-brain-bootstrap/main/install.sh) [target-dir]
#
# Installs or upgrades the Copilot Brain Bootstrap into a target project directory.
# FRESH install: copies everything to a clean repo
# UPGRADE: adds missing files without overwriting existing customizations

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Config ────────────────────────────────────────────────────────────────────
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$PWD}"
MIN_PROMPTS=10
MIN_AGENTS=3
MIN_HOOKS=2
MIN_SKILLS=5

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { printf "${BLUE}[info]${RESET} %s\n" "$*"; }
success() { printf "${GREEN}[✓]${RESET} %s\n" "$*"; }
warn()    { printf "${YELLOW}[⚠]${RESET} %s\n" "$*"; }
error()   { printf "${RED}[✗]${RESET} %s\n" "$*"; }
bold()    { printf "${BOLD}%s${RESET}\n" "$*"; }

copy_if_missing() {
  local src="$1"
  local dst="$2"
  if [[ ! -f "${dst}" ]]; then
    mkdir -p "$(dirname "${dst}")"
    cp "${src}" "${dst}"
    success "Created: $(basename "${dst}")"
  else
    info "Skipped (exists): $(basename "${dst}")"
  fi
}

copy_dir_missing() {
  local src_dir="$1"
  local dst_dir="$2"
  if [[ ! -d "${src_dir}" ]]; then return; fi
  mkdir -p "${dst_dir}"
  local count=0
  while IFS= read -r -d '' f; do
    local rel="${f#${src_dir}/}"
    local dst="${dst_dir}/${rel}"
    if [[ ! -f "${dst}" ]]; then
      mkdir -p "$(dirname "${dst}")"
      cp "${f}" "${dst}"
      ((count++)) || true
    fi
  done < <(find "${src_dir}" -type f -print0 2>/dev/null)
  if [[ "${count}" -gt 0 ]]; then
    success "Installed ${count} file(s) into $(basename "${dst_dir}")"
  fi
}

# ── Validate target ──────────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Copilot Brain Bootstrap ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

if [[ ! -d "${TARGET_DIR}" ]]; then
  error "Target directory not found: ${TARGET_DIR}"
  exit 1
fi

cd "${TARGET_DIR}"

if [[ ! -d ".git" ]]; then
  error "${TARGET_DIR} is not a git repository. Run 'git init' first."
  exit 1
fi

# ── Detect FRESH vs UPGRADE ───────────────────────────────────────────────────
MODE="fresh"
if [[ -f ".github/copilot-instructions.md" ]] || [[ -d "claude" && -f "claude/rules.md" ]]; then
  MODE="upgrade"
fi

if [[ "${MODE}" == "fresh" ]]; then
  bold "Mode: FRESH INSTALL"
  info "Target: ${TARGET_DIR}"
else
  bold "Mode: UPGRADE"
  info "Target: ${TARGET_DIR}"
  info "Existing customizations will be preserved."
fi
printf "\n"

# ── Install core instruction file ─────────────────────────────────────────────
info "Installing .github/copilot-instructions.md..."
copy_if_missing "${BOOTSTRAP_DIR}/.github/copilot-instructions.md" ".github/copilot-instructions.md"

# ── Install agents ────────────────────────────────────────────────────────────
info "Installing agents..."
copy_dir_missing "${BOOTSTRAP_DIR}/.github/agents" ".github/agents"

# ── Install hooks ─────────────────────────────────────────────────────────────
info "Installing hooks..."
copy_dir_missing "${BOOTSTRAP_DIR}/.github/hooks" ".github/hooks"

# Make hook scripts executable
if [[ -d ".github/hooks/scripts" ]]; then
  find ".github/hooks/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
  success "Hook scripts made executable"
fi

# ── Install prompts ───────────────────────────────────────────────────────────
info "Installing prompts..."
copy_dir_missing "${BOOTSTRAP_DIR}/.github/prompts" ".github/prompts"

# ── Install skills ────────────────────────────────────────────────────────────
info "Installing skills..."
copy_dir_missing "${BOOTSTRAP_DIR}/.github/skills" ".github/skills"

# ── Install instructions ──────────────────────────────────────────────────────
info "Installing instructions..."
copy_dir_missing "${BOOTSTRAP_DIR}/.github/instructions" ".github/instructions"

# ── Install knowledge layer (claude/) ────────────────────────────────────────
info "Installing claude/ knowledge layer..."
copy_dir_missing "${BOOTSTRAP_DIR}/claude" "claude"

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n${BOLD}━━━ Installation Summary ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

PROMPT_COUNT=$(find ".github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(find ".github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
HOOK_COUNT=$(find ".github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find ".github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
INSTRUCTION_COUNT=$(find ".github/instructions" -name '*.instructions.md' 2>/dev/null | wc -l | tr -d ' ')

printf "  Prompts:      %s\n" "${PROMPT_COUNT}"
printf "  Agents:       %s\n" "${AGENT_COUNT}"
printf "  Hooks:        %s\n" "${HOOK_COUNT}"
printf "  Skills:       %s\n" "${SKILL_COUNT}"
printf "  Instructions: %s\n" "${INSTRUCTION_COUNT}"
printf "\n"

# ── Next steps ────────────────────────────────────────────────────────────────
bold "Next steps:"
printf "  1. Open VS Code in ${TARGET_DIR}\n"
printf "  2. Open GitHub Copilot Chat\n"
printf "  3. Run: /bootstrap to fill project-specific placeholders\n"
printf "  4. Run: /health to verify everything is loaded\n"
printf "\n"

if [[ "${MODE}" == "fresh" ]]; then
  printf "${GREEN}✓ Fresh installation complete!${RESET}\n\n"
else
  printf "${GREEN}✓ Upgrade complete!${RESET}\n\n"
fi
