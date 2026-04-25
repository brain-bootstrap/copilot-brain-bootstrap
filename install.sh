#!/usr/bin/env bash
# install.sh — Smart installer for Copilot Brain Bootstrap
# Safely handles FRESH installs and upgrades of existing configurations.
#
# Usage:
#   git clone https://github.com/brain-bootstrap/copilot-brain-bootstrap.git /tmp/copilot-brain
#   bash /tmp/copilot-brain/install.sh /path/to/your-repo
#   rm -rf /tmp/copilot-brain
#
# FRESH mode:  No Copilot-related files exist → copies entire template.
# UPGRADE mode: Any Copilot-related file exists → smart merge:
#   - NEVER overwrites user files (knowledge, config, tasks, custom docs)
#   - Updates Brain infrastructure (scripts, prompts, agents, skills, hooks, instructions)
#   - Adds missing Brain components
#   - Preserves user-only files even in infrastructure directories

# ─── Source guard — prevent env corruption if sourced ─────────────
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "❌ install.sh must be EXECUTED, not sourced." >&2
  echo "   Wrong:  source install.sh /path/to/repo" >&2
  echo "   Right:  bash install.sh /path/to/repo" >&2
  return 1 2>/dev/null || exit 1
fi

set -euo pipefail

# ── Platform helpers ───────────────────────────────────────────────
# shellcheck disable=SC1091
source "$(dirname "$0")/scripts/_platform.sh"

# ── Pre-flight check mode ─────────────────────────────────────────
if [ "${1:-}" = "--check" ]; then
  echo ""
  echo "🔍 Copilot Brain Bootstrap — Pre-flight Check"
  echo ""
  echo "  Platform: $BRAIN_PLATFORM"
  require_tool git "required for repo detection" && echo "  ✅ git $(git --version 2>/dev/null | head -1)" || true
  if command -v jq &>/dev/null; then
    echo "  ✅ jq $(jq --version 2>/dev/null)"
  else
    echo "  ❌ jq not found — STRONGLY RECOMMENDED"
    echo "     Without jq: safety hooks (config protection, terminal safety gate,"
    echo "     commit quality) silently pass through."
    case "$BRAIN_PLATFORM" in
      macos)   echo "     Install: brew install jq" ;;
      linux)   echo "     Install: sudo apt install jq  OR  sudo dnf install jq" ;;
      windows) echo "     Install: scoop install jq  OR  choco install jq" ;;
    esac
  fi
  bash_ver="${BASH_VERSINFO[0]:-0}"
  if [ "$bash_ver" -ge 4 ]; then
    echo "  ✅ bash $BASH_VERSION (≥4 — full support)"
  else
    echo "  ⚠️  bash $BASH_VERSION (<4 — discover.sh and populate-templates.sh need Bash 4+)"
    echo '     Fix: brew install bash && export PATH="$(brew --prefix)/bin:$PATH"'
  fi
  PY_FOUND=false
  for py_cmd in python3 python; do
    if command -v "$py_cmd" &>/dev/null; then
      PY_VER=$("$py_cmd" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null || true)
      PY_MAJOR="${PY_VER%%.*}"
      PY_MINOR="${PY_VER##*.}"
      if [ "${PY_MAJOR:-0}" -ge 3 ] && [ "${PY_MINOR:-0}" -ge 10 ]; then
        echo "  ✅ $py_cmd $PY_VER (≥3.10 — graphify knowledge graph ready)"
        PY_FOUND=true
        break
      else
        echo "  ⚠️  $py_cmd $PY_VER (<3.10 — graphify needs 3.10+)"
      fi
    fi
  done
  if [ "$PY_FOUND" = "false" ]; then
    echo "  ⚠️  Python 3.10+ not found — graphify knowledge graph won't be available"
    case "$BRAIN_PLATFORM" in
      macos)   echo "     Install: brew install python@3.12" ;;
      windows) echo "     Install: winget install Python.Python.3.12" ;;
      linux)   echo "     Install: sudo apt install python3" ;;
    esac
  fi
  if command -v uvx &>/dev/null; then
    echo "  ✅ uvx (MCP tools available)"
  else
    echo "  ⚠️  uvx not found — optional MCP tools (cocoindex, code-review-graph, serena) unavailable"
    echo "     Install: pip install uv"
  fi
  echo ""
  exit 0
fi

# ── Resolve paths ──────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Parse flags ────────────────────────────────────────────────────
POSITIONAL_ARGS=()
for arg in "$@"; do
  case "$arg" in
    --claude|--codex)
      echo "⚠️  $arg flag is not valid for copilot-brain-bootstrap." >&2
      echo "   Usage: bash install.sh /path/to/your-repo" >&2
      exit 1
      ;;
    *) POSITIONAL_ARGS+=("$arg") ;;
  esac
done
TARGET="${POSITIONAL_ARGS[0]:?Usage: bash install.sh /path/to/your-repo}"

# ── Git repo root guard ───────────────────────────────────────────
# Brain files belong at the ROOT of a git repository.

# Check 1: Target must exist
if [ ! -d "$TARGET" ]; then
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  Copilot Brain Bootstrap — Smart Installer           ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "  Target:  $TARGET"
  echo ""
  echo "❌ ERROR: Target directory does not exist."
  echo "   Brain Bootstrap must be installed at the root of an existing git repo."
  echo ""
  echo "   Create and initialize your project first:"
  echo "     mkdir -p $TARGET"
  echo "     git init $TARGET"
  echo "     bash $0 $TARGET"
  echo ""
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

# Check 2: Must be inside a git repository
if ! git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  Copilot Brain Bootstrap — Smart Installer           ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "  Target:  $TARGET"
  echo ""
  echo "❌ ERROR: Target is not inside a git repository."
  echo "   Brain Bootstrap must be installed at the root of a git repo."
  echo ""
  echo "   Initialize git first:"
  echo "     git init $TARGET"
  echo "     bash $0 $TARGET"
  echo ""
  exit 1
fi

# Check 3: Must be the REPO ROOT, not a subdirectory
GIT_CDUP="$(git -C "$TARGET" rev-parse --show-cdup 2>/dev/null)" || true
if [ -n "$GIT_CDUP" ]; then
  GIT_ROOT="$(git -C "$TARGET" rev-parse --show-toplevel 2>/dev/null || true)"
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  Copilot Brain Bootstrap — Smart Installer           ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "  Target:     $TARGET"
  echo "  Repo root:  $GIT_ROOT"
  echo ""
  echo "❌ ERROR: Target is a subdirectory of a git repo, not the root."
  echo "   Brain Bootstrap must be installed at the REPOSITORY ROOT."
  echo ""
  echo "   Use the repo root instead:"
  echo "     bash $0 $GIT_ROOT"
  echo ""
  exit 1
fi

# ── Self-bootstrap guard ──────────────────────────────────────────
if [ -f "$TARGET/CONTRIBUTING.md" ]; then
  if grep -q 'copilot-brain-bootstrap' "$TARGET/CONTRIBUTING.md" 2>/dev/null; then
    echo "❌ ERROR: Target appears to be the Brain Bootstrap template repo itself."
    echo "   Install into your PROJECT repo, not into the template."
    echo "   Usage: bash install.sh /path/to/your-actual-project"
    exit 1
  fi
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  Copilot Brain Bootstrap — Smart Installer           ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  Source:    $SCRIPT_DIR"
echo "  Target:    $TARGET"
echo "  Platform:  $BRAIN_PLATFORM"
echo ""

# ── Detect mode ───────────────────────────────────────────────────
# PRINCIPLE: If Brain Bootstrap-related content exists, it's UPGRADE.
# FRESH only happens when absolutely nothing Brain-related is present.

has_copilot_content() {
  # Any copilot-instructions.md (hand-crafted, Brain, or template)
  [ -f "$TARGET/.github/copilot-instructions.md" ] && return 0

  # Any context/ directory with Brain files
  if [ -d "$TARGET/context" ]; then
    local count
    count=$(find "$TARGET/context" -type f ! -name '.gitkeep' 2>/dev/null | head -1)
    [ -n "$count" ] && return 0
  fi

  # Any scripts/discover.sh
  [ -f "$TARGET/scripts/discover.sh" ] && return 0

  return 1
}

if has_copilot_content; then
  MODE="UPGRADE"
else
  MODE="FRESH"
fi

echo "  Mode:    $MODE"
echo ""

# ── Helpers ────────────────────────────────────────────────────────

# Copy file only if target does not exist. Returns 0 if copied, 1 if skipped.
copy_if_missing() {
  local src="$1" dest="$2"
  if [ ! -e "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    return 0
  fi
  return 1
}

# Recursively add only files that don't exist in dest. Never overwrites.
# Echoes the count of files added.
add_missing_files() {
  local src_dir="$1" dest_dir="$2"
  local added=0
  [ -d "$src_dir" ] || { echo 0; return; }
  mkdir -p "$dest_dir"
  local _tmplist
  _tmplist=$(mktemp)
  find "$src_dir" -type f > "$_tmplist" 2>/dev/null
  while IFS= read -r src_file; do
    [ -z "$src_file" ] && continue
    local rel="${src_file#"$src_dir/"}"
    local dest_file="$dest_dir/$rel"
    if [ ! -e "$dest_file" ]; then
      mkdir -p "$(dirname "$dest_file")"
      cp "$src_file" "$dest_file"
      added=$((added + 1))
    fi
  done < "$_tmplist"
  rm -f "$_tmplist"
  echo "$added"
}

# Smart sync: update files that exist in BOTH source and dest (template-originated),
# add files that exist only in source (new template files),
# PRESERVE files that exist only in dest (user-created files — never touched).
# Echoes "updated:added:preserved" counts.
sync_dir() {
  local src_dir="$1" dest_dir="$2"
  local updated=0 added=0 preserved=0
  [ -d "$src_dir" ] || { echo "0:0:0"; return; }
  mkdir -p "$dest_dir"

  # Pass 1: Sync from template → dest (update existing + add new)
  local _tmplist1
  _tmplist1=$(mktemp)
  find "$src_dir" -type f > "$_tmplist1" 2>/dev/null
  while IFS= read -r src_file; do
    [ -z "$src_file" ] && continue
    local rel="${src_file#"$src_dir/"}"
    local dest_file="$dest_dir/$rel"
    mkdir -p "$(dirname "$dest_file")"
    if [ -e "$dest_file" ]; then
      if ! diff -q "$src_file" "$dest_file" >/dev/null 2>&1; then
        cp "$src_file" "$dest_file"
        updated=$((updated + 1))
      fi
    else
      cp "$src_file" "$dest_file"
      added=$((added + 1))
    fi
  done < "$_tmplist1"
  rm -f "$_tmplist1"

  # Pass 2: Count user-only files (exist in dest but not in source — NEVER touched)
  if [ -d "$dest_dir" ]; then
    local _tmplist2
    _tmplist2=$(mktemp)
    find "$dest_dir" -type f > "$_tmplist2" 2>/dev/null
    while IFS= read -r dest_file; do
      [ -z "$dest_file" ] && continue
      local rel="${dest_file#"$dest_dir/"}"
      local src_file="$src_dir/$rel"
      if [ ! -e "$src_file" ]; then
        preserved=$((preserved + 1))
      fi
    done < "$_tmplist2"
    rm -f "$_tmplist2"
  fi

  echo "$updated:$added:$preserved"
}

# ── FRESH: Copy everything ────────────────────────────────────────
if [ "$MODE" = "FRESH" ]; then
  echo "📦 Fresh install — copying full template..."
  echo ""

  # .github/ directory (copilot-instructions, hooks, agents, prompts, skills, instructions)
  n="$(add_missing_files "$SCRIPT_DIR/.github" "$TARGET/.github")"
  echo "  ✅ .github/     — $n files"

  # context/ directory (knowledge base)
  n="$(add_missing_files "$SCRIPT_DIR/context" "$TARGET/context")"
  echo "  ✅ context/     — $n files"

  # scripts/ directory (discover.sh + helpers)
  n="$(add_missing_files "$SCRIPT_DIR/scripts" "$TARGET/scripts")"
  echo "  ✅ scripts/     — $n files"

  # Root files
  if [ -f "$SCRIPT_DIR/validate.sh" ]; then
    copy_if_missing "$SCRIPT_DIR/validate.sh" "$TARGET/validate.sh"
    echo "  ✅ validate.sh"
  fi

  # Make scripts executable
  chmod +x "$TARGET/.github/hooks/scripts/"*.sh 2>/dev/null || true
  chmod +x "$TARGET/scripts/"*.sh 2>/dev/null || true
  [ -f "$TARGET/validate.sh" ] && chmod +x "$TARGET/validate.sh" || true

  # Count ALL installed files
  total=0
  for _count_dir in "$TARGET/.github" "$TARGET/context" "$TARGET/scripts"; do
    [ -d "$_count_dir" ] && total=$((total + $(find "$_count_dir" -type f 2>/dev/null | wc -l)))
  done
  [ -f "$TARGET/validate.sh" ] && total=$((total + 1))
  echo ""

  echo "✅ Fresh install complete! $total files installed."
  echo ""
  echo "👉 Next step:"
  echo "   Open VS Code, open GitHub Copilot Chat, and run /bootstrap"
  echo ""
  exit 0

# ══════════════════════════════════════════════════════════════════
# UPGRADE MODE — Smart merge: never lose user data
# ══════════════════════════════════════════════════════════════════
else
  echo "🔄 Upgrade detected — smart merge in progress..."
  echo "   Existing Copilot configuration found. Every user file will be preserved."
  echo ""

  PRESERVED_COUNT=0
  UPDATED_COUNT=0
  ADDED_COUNT=0

  # ── Pre-upgrade backup ─────────────────────────────────────────────
  mkdir -p "$TARGET/context/tasks"
  if (cd "$TARGET" && tar czf "context/tasks/.pre-upgrade-backup.tar.gz" \
    .github/ context/ scripts/ validate.sh 2>/dev/null); then
    true
  fi
  echo "  💾 Safety backup → context/tasks/.pre-upgrade-backup.tar.gz"
  echo "     Restore: tar xzf context/tasks/.pre-upgrade-backup.tar.gz"
  echo ""

  # ── Phase A: Inventory & protect ALL user content ─────────────────
  # Dynamically scans everything the user has. No hardcoded file lists.
  # REPORTING ONLY — preservation is enforced structurally by sync_dir
  # (preserves user-only files) and copy_if_missing (never overwrites).

  echo "🛡️  Phase A — Inventorying your data (NEVER overwritten):"

  # All user files in context/ EXCEPT infrastructure dirs
  # (infrastructure dirs handled by sync_dir in Phase B)
  if [ -d "$TARGET/context" ]; then
    _tmpinv1=$(mktemp)
    find "$TARGET/context" -type f ! -name '.gitkeep' > "$_tmpinv1" 2>/dev/null
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      rel="${f#"$TARGET/"}"
      # Skip infrastructure dirs — Phase B handles them with sync_dir
      case "$rel" in
        context/bootstrap/*|context/docs/*|context/_examples/*) continue ;;
      esac
      case "$rel" in
        context/tasks/lessons.md|context/tasks/todo.md|context/tasks/COPILOT_ERRORS.md)
          echo "  🔒 $rel (sacred — never modified)" ;;
        *)
          echo "  🔒 $rel" ;;
      esac
      PRESERVED_COUNT=$((PRESERVED_COUNT + 1))
    done < "$_tmpinv1"
    rm -f "$_tmpinv1"
  fi

  # copilot-instructions.md and other .github/ user files
  if [ -d "$TARGET/.github" ]; then
    _tmpinv2=$(mktemp)
    find "$TARGET/.github" -type f > "$_tmpinv2" 2>/dev/null
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      rel="${f#"$TARGET/"}"
      # Skip infrastructure dirs — Phase B handles them with sync_dir
      case "$rel" in
        .github/hooks/*|.github/agents/*|.github/prompts/*|.github/skills/*|.github/instructions/*) continue ;;
      esac
      case "$rel" in
        .github/copilot-instructions.md)
          echo "  🔒 $rel (AI identity — never overwritten)" ;;
        *)
          echo "  🔒 $rel" ;;
      esac
      PRESERVED_COUNT=$((PRESERVED_COUNT + 1))
    done < "$_tmpinv2"
    rm -f "$_tmpinv2"
  fi

  echo ""
  echo "  → $PRESERVED_COUNT existing files protected"
  echo ""

  # ── Phase B: Sync infrastructure dirs ─────────────────────────────
  # Uses sync_dir: updates template files, adds new template files,
  # PRESERVES user-only files. No rm -rf. No data loss. Ever.

  echo "⬆️  Phase B — Updating Brain infrastructure (user-only files preserved):"

  for dir_pair in \
    ".github/hooks:hooks" \
    ".github/agents:agents" \
    ".github/prompts:prompts" \
    ".github/skills:skills" \
    ".github/instructions:instructions" \
    "scripts:discovery & build tools" \
    "context/bootstrap:bootstrap process" \
    "context/docs:reference documentation" \
    "context/_examples:domain examples"; do

    dir_name="${dir_pair%%:*}"
    dir_label="${dir_pair#*:}"
    src="$SCRIPT_DIR/$dir_name"
    dest="$TARGET/$dir_name"

    if [ -d "$src" ]; then
      result=$(sync_dir "$src" "$dest")
      u="${result%%:*}"; rest="${result#*:}"; a="${rest%%:*}"; p="${rest#*:}"
      UPDATED_COUNT=$((UPDATED_COUNT + u))
      ADDED_COUNT=$((ADDED_COUNT + a))

      status=""
      [ "$u" -gt 0 ] && status="${status}${u} updated"
      [ "$a" -gt 0 ] && status="${status:+$status, }${a} added"
      [ "$p" -gt 0 ] && status="${status:+$status, }${p} user files kept"
      [ -z "$status" ] && status="up to date"

      echo "  ⬆️  $dir_name/ → $status ($dir_label)"
    fi
  done

  # Make hook scripts executable
  chmod +x "$TARGET/.github/hooks/scripts/"*.sh 2>/dev/null || true
  chmod +x "$TARGET/scripts/"*.sh 2>/dev/null || true

  echo ""

  # ── Phase C: Add missing individual files ─────────────────────────
  # copilot-instructions.md and validate.sh — add if missing; NEVER overwrite.

  echo "➕ Phase C — Adding missing files:"

  phase_c_added=0

  if [ -f "$SCRIPT_DIR/.github/copilot-instructions.md" ]; then
    if copy_if_missing "$SCRIPT_DIR/.github/copilot-instructions.md" \
                       "$TARGET/.github/copilot-instructions.md"; then
      echo "  ➕ .github/copilot-instructions.md (new)"
      phase_c_added=$((phase_c_added + 1))
    else
      echo "  ✅ .github/copilot-instructions.md — present (user's version kept)"
    fi
  fi

  if copy_if_missing "$SCRIPT_DIR/validate.sh" "$TARGET/validate.sh"; then
    echo "  ➕ validate.sh (new)"
    phase_c_added=$((phase_c_added + 1))
  fi

  ADDED_COUNT=$((ADDED_COUNT + phase_c_added))

  if [ "$phase_c_added" -eq 0 ]; then
    echo "  ✅ All files present — nothing to add"
  fi

  echo ""

  # ── Phase D: Add missing user knowledge files ─────────────────────
  # Context docs, task templates. ALL add-if-missing. NEVER overwrites existing files.

  echo "➕ Phase D — Adding missing files:"

  phase_d_added=0

  # context/ root *.md docs (add missing only)
  mkdir -p "$TARGET/context"
  for f in "$SCRIPT_DIR/context"/*.md; do
    [ -f "$f" ] || continue
    fname="$(basename "$f")"
    if copy_if_missing "$f" "$TARGET/context/$fname"; then
      echo "  ➕ context/$fname (new)"
      phase_d_added=$((phase_d_added + 1))
    fi
  done

  # Task template files (add missing — NEVER overwrite)
  # Uses find instead of glob to catch dotfiles (.gitignore, .gitkeep)
  mkdir -p "$TARGET/context/tasks"
  _tmptasks=$(mktemp)
  find "$SCRIPT_DIR/context/tasks" -maxdepth 1 -type f > "$_tmptasks" 2>/dev/null
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    fname="$(basename "$f")"
    if copy_if_missing "$f" "$TARGET/context/tasks/$fname"; then
      echo "  ➕ context/tasks/$fname (new)"
      phase_d_added=$((phase_d_added + 1))
    fi
  done < "$_tmptasks"
  rm -f "$_tmptasks"

  ADDED_COUNT=$((ADDED_COUNT + phase_d_added))

  if [ "$phase_d_added" -eq 0 ]; then
    echo "  ✅ All files present — nothing to add"
  fi

  echo ""

  # ── Phase E: Gitignore guard for generated files ──────────────────
  # Ensure Brain-generated files that should stay out of version control
  # are listed in .gitignore.
  echo "🔒 Phase E — Gitignore guard:"

  GITIGNORE_FILE="$TARGET/.gitignore"
  GITIGNORE_ADDED=0

  if [ -f "$GITIGNORE_FILE" ]; then
    BRAIN_GENERATED="context/tasks/.pre-upgrade-backup.tar.gz context/tasks/.discovery.env"
    MISSING_ENTRIES=""
    for pf in $BRAIN_GENERATED; do
      if ! grep -qF "$pf" "$GITIGNORE_FILE" 2>/dev/null; then
        MISSING_ENTRIES="$MISSING_ENTRIES$pf
"
        GITIGNORE_ADDED=$((GITIGNORE_ADDED + 1))
      fi
    done
    if [ -n "$MISSING_ENTRIES" ]; then
      printf '\n# Copilot Brain Bootstrap — local/generated files (added by install.sh)\n' >> "$GITIGNORE_FILE"
      printf '%s' "$MISSING_ENTRIES" >> "$GITIGNORE_FILE"
      echo "  ➕ Added $GITIGNORE_ADDED entry/entries to .gitignore"
    else
      echo "  ✅ All Brain-generated files already gitignored"
    fi
  else
    echo "  ⏭️  Skipped — no .gitignore found"
  fi

  echo ""

  # ── Summary ───────────────────────────────────────────────────────
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  ✅  Smart merge complete!                           ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "  🔒 Preserved:  $PRESERVED_COUNT user files (knowledge, tasks, config)"
  echo "  ⬆️  Updated:    $UPDATED_COUNT infrastructure files"
  echo "  ➕ Added:      $ADDED_COUNT new Brain components"
  echo ""
  PROMPT_COUNT=$(find "$TARGET/.github/prompts" -name '*.prompt.md' 2>/dev/null | wc -l | tr -d ' ')
  AGENT_COUNT=$(find "$TARGET/.github/agents" -name '*.agent.md' 2>/dev/null | wc -l | tr -d ' ')
  HOOK_COUNT=$(find "$TARGET/.github/hooks" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')
  SKILL_COUNT=$(find "$TARGET/.github/skills" -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')
  INSTRUCTION_COUNT=$(find "$TARGET/.github/instructions" -name '*.instructions.md' 2>/dev/null | wc -l | tr -d ' ')
  echo "  Prompts:      $PROMPT_COUNT"
  echo "  Agents:       $AGENT_COUNT"
  echo "  Hooks:        $HOOK_COUNT"
  echo "  Skills:       $SKILL_COUNT"
  echo "  Instructions: $INSTRUCTION_COUNT"
  echo ""
  echo "  Every file you created — lessons, architecture docs, domain"
  echo "  knowledge, custom instructions, settings — is exactly as you left it."
fi

# ── Make scripts executable ───────────────────────────────────────
find "$TARGET/.github/hooks/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
find "$TARGET/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
[ -f "$TARGET/validate.sh" ] && chmod +x "$TARGET/validate.sh" || true

# ── Next steps ────────────────────────────────────────────────────
echo ""
echo "┌──────────────────────────────────────────────────────┐"
echo "│  👉 Next step:                                       │"
echo "│                                                      │"
echo "│  Open VS Code and run /bootstrap in Copilot Chat     │"
echo "│     Phase 2 (Smart Merge) will:                      │"
echo "│     • Fill all {{PLACEHOLDER}} values                │"
echo "│     • Tailor instructions to your project            │"
echo "│     • Verify with /health                            │"
echo "│  All additive. Never destructive.                    │"
echo "└──────────────────────────────────────────────────────┘"

if ! command -v jq &>/dev/null; then
  echo ""
  echo "⚠️  jq is not installed — safety hooks will be degraded."
  echo "   Without jq, config-protection, terminal-safety-gate, and commit-quality"
  echo "   hooks cannot parse tool input and will silently pass through."
  echo ""
  case "$BRAIN_PLATFORM" in
    macos)   echo "   Install now:  brew install jq" ;;
    windows) echo "   Install now:  scoop install jq  OR  choco install jq" ;;
    linux)   echo "   Install now:  sudo apt install jq  OR  sudo dnf install jq" ;;
  esac
  echo ""
fi
echo ""
