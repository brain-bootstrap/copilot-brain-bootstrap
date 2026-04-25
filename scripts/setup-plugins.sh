#!/usr/bin/env bash
# setup-plugins.sh — Install optional plugins for Copilot Brain Bootstrap
# Supports: graphify, cocoindex, code-review-graph, serena, playwright
# Usage: bash scripts/setup-plugins.sh [--all] [--cocoindex] [--review-graph] [--serena] [--playwright]
set -euo pipefail
source "$(dirname "$0")/_platform.sh"

BOLD="\033[1m"; RESET="\033[0m"; GREEN="\033[0;32m"; YELLOW="\033[0;33m"

ok()   { printf "  ${PASS_SYM} %s\n" "$1"; }
warn() { printf "  ${WARN_SYM} %s\n" "$1"; }
note() { printf "  ${YELLOW}→${RESET} %s\n" "$1"; }

INSTALL_ALL=false
INSTALL_COCOINDEX=false
INSTALL_REVIEW_GRAPH=false
INSTALL_SERENA=false
INSTALL_PLAYWRIGHT=false

for arg in "$@"; do
  case "$arg" in
    --all)          INSTALL_ALL=true ;;
    --cocoindex)    INSTALL_COCOINDEX=true ;;
    --review-graph) INSTALL_REVIEW_GRAPH=true ;;
    --serena)       INSTALL_SERENA=true ;;
    --playwright)   INSTALL_PLAYWRIGHT=true ;;
  esac
done

if ! $INSTALL_ALL && ! $INSTALL_COCOINDEX && ! $INSTALL_REVIEW_GRAPH \
   && ! $INSTALL_SERENA && ! $INSTALL_PLAYWRIGHT; then
  printf "${BOLD}Copilot Brain Bootstrap — Plugin Setup${RESET}\n\n"
  printf "Usage: %s [--all] [--cocoindex] [--review-graph] [--serena] [--playwright]\n\n" \
    "$(basename "$0")"
  printf "Available plugins:\n"
  printf "  --cocoindex     CocoIndex: structural code queries and semantic search\n"
  printf "  --review-graph  code-review-graph: dependency graphs and drift detection\n"
  printf "  --serena        Serena: language server semantic navigation\n"
  printf "  --playwright    Playwright: E2E browser automation testing\n"
  printf "  --all           Install all of the above\n\n"
  exit 0
fi

printf "${BOLD}Copilot Brain Bootstrap — Plugin Setup${RESET}\n\n"

require_tool "npm" "Node.js package manager"

# ── CocoIndex ─────────────────────────────────────────────────────
install_cocoindex() {
  printf "\n${BOLD}[cocoindex]${RESET} Structural code query engine\n"
  if command -v cocoindex &>/dev/null; then
    ok "cocoindex already installed ($(cocoindex --version 2>/dev/null || echo 'version unknown'))"
    return
  fi
  note "Installing cocoindex via pip..."
  if command -v pip3 &>/dev/null; then
    pip3 install cocoindex --quiet && ok "cocoindex installed via pip3" \
      || warn "pip3 install failed — try: pip3 install cocoindex"
  else
    warn "pip3 not found — install Python 3, then: pip3 install cocoindex"
  fi
}

# ── code-review-graph ─────────────────────────────────────────────
install_review_graph() {
  printf "\n${BOLD}[code-review-graph]${RESET} Dependency graphs via MCP\n"
  note "Installing @yoannabbes/code-review-graph MCP server..."
  if npx --yes @yoannabbes/code-review-graph --version &>/dev/null 2>&1; then
    ok "code-review-graph available via npx"
  else
    npm install -g @modelcontextprotocol/server-code-review-graph 2>/dev/null \
      && ok "code-review-graph installed globally" \
      || warn "Install manually: npm install -g @modelcontextprotocol/server-code-review-graph"
  fi
}

# ── Serena ────────────────────────────────────────────────────────
install_serena() {
  printf "\n${BOLD}[serena]${RESET} Semantic navigation via language server\n"
  if command -v serena &>/dev/null; then
    ok "serena already installed"
    return
  fi
  note "Installing serena via pip..."
  if command -v pip3 &>/dev/null; then
    pip3 install serena --quiet && ok "serena installed via pip3" \
      || warn "pip3 install failed — try: pip3 install serena"
  else
    warn "pip3 not found — install Python 3, then: pip3 install serena"
  fi
}

# ── Playwright ────────────────────────────────────────────────────
install_playwright() {
  printf "\n${BOLD}[playwright]${RESET} E2E browser automation\n"
  if npm list -g playwright &>/dev/null 2>&1; then
    ok "playwright already installed globally"
    return
  fi
  note "Installing @playwright/test..."
  npm install -g @playwright/test --quiet 2>/dev/null \
    && ok "playwright installed" \
    || warn "npm install failed — try: npm install -g @playwright/test"
  note "Installing browser binaries (this may take a minute)..."
  npx playwright install --with-deps chromium 2>/dev/null \
    && ok "Chromium browser installed" \
    || warn "Browser install failed — run: npx playwright install"
}

$INSTALL_ALL || $INSTALL_COCOINDEX   && install_cocoindex
$INSTALL_ALL || $INSTALL_REVIEW_GRAPH && install_review_graph
$INSTALL_ALL || $INSTALL_SERENA      && install_serena
$INSTALL_ALL || $INSTALL_PLAYWRIGHT  && install_playwright

printf "\n${GREEN}${BOLD}Plugin setup complete.${RESET}\n\n"
