# Terminal Safety Reference

## #1 Rule: The Pipe Character

> The `|` pipe character is the **#1 recurring source of bugs** in AI-generated terminal commands. Five absolute rules — memorize and apply immediately:

### 🚨 PIPE RULE 1 — Terminal Regex

```bash
grep -E 'pattern_a|pattern_b' file    # ✅ single quotes — safe
grep -E "pattern_a|pattern_b" file    # ❌ double quotes — shell may interpret |
```

### 🚨 PIPE RULE 2 — Writing Files

Use the file-writing tool. **NEVER** use a heredoc in the terminal to write files containing `|` — the terminal strips pipe characters.

### 🚨 PIPE RULE 3 — Verifying Files

```bash
grep -c '|' file                      # ✅ count pipe chars safely
cat file                              # ❌ terminal display STRIPS | characters
```

### 🚨 PIPE RULE 4 — Markdown Tables

- `\|` inside Markdown table cells (inside the terminal)
- Bare `|` only outside terminal contexts

### 🚨 PIPE RULE 5 — Shell Scripts

```bash
case "$F" in *.js|*.ts) ...;;  esac   # ✅ case statement is pipe-immune
grep -E '\.(js|ts)$'                   # ❌ grep in terminal — use single quotes
```

---

## Pager Rules (ALWAYS apply)

```bash
git --no-pager log --oneline -20      # ✅ disable pager explicitly
git log | cat                          # ✅ pipe to cat
helm list 2>&1 | head -20              # ✅ bounded output
kubectl get pods 2>&1 | cat            # ✅ pipe to cat
```

**Never use pagers:** `git log`, `git show`, `git diff`, `git stash list`, `helm`, `kubectl describe`, `man`, `less`, `more`.

---

## Interactive Program Rules (NEVER open)

```bash
# ❌ NEVER — will hang the session
vi file.txt
nano file.txt
psql                           # use: psql -c "SQL" | cat
node                           # use: node -e "..."
python                         # use: python3 -c "..."
docker exec -it container sh   # use: docker exec container command
```

---

## Output Bounding Rules (ALWAYS apply)

```bash
command | head -50             # ✅ bounded
command | tail -20             # ✅ bounded
command 2>&1 | head -100       # ✅ stderr + bounded
find . -name '*.ts' | head -20 # ✅ bounded
```

Never dump unbounded output from: `find`, `grep -r`, `cat` on large files, `npm ls`, `pip list`.

---

## Color / ANSI Rules

```bash
git --no-pager diff --color=never      # ✅
grep --color=never pattern file        # ✅
ls --color=never                       # ✅
```

Always add `--color=never` or `NO_COLOR=1` to prevent ANSI escape codes corrupting output.

---

## stderr Capture

```bash
command 2>&1                   # ✅ capture stderr with stdout
command 2>/dev/null            # ✅ discard stderr when expected
command 2>&1 | head -50        # ✅ capture + bound
```

---

## Long-Running Commands

```bash
# Short-lived (test, grep, git) → foreground (sync)
bash run-tests.sh

# Long-running (server, watch, background task) → async/background
npm run dev &
```

---

## Directory Safety

```bash
# ✅ Use absolute paths
bash /path/to/script.sh

# ❌ NEVER chain cd + command — use absolute paths instead
cd /path && command
```

---

## After Any Terminal Issue

Update `claude/terminal-safety.md` + `claude/tasks/lessons.md` immediately.
