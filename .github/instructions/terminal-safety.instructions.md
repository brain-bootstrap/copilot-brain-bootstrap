---
applyTo: '**/*.{sh,bash}'
---

# Terminal & Shell Safety Instructions

Apply these rules to EVERY shell script and terminal command.

## Pipe Character Rules

```bash
grep -E 'pattern_a|pattern_b' file    # ✅ single quotes
grep -E "pattern_a|pattern_b" file    # ❌ double quotes
```

## Pager Prevention

```bash
git --no-pager log --oneline -20      # ✅
git --no-pager diff --color=never     # ✅
helm list 2>&1 | cat                  # ✅
```

## Output Bounding

```bash
command | head -50                    # ✅
command 2>&1 | head -100              # ✅
find . -name '*.ts' | head -20        # ✅
```

## Interactive Programs — NEVER

- `vi`, `vim`, `nano`, `emacs` → use file write tools
- `python`, `node` bare → use `-c "..."` flag
- `psql` bare → use `-c "SQL"` flag

## Error Capture

```bash
command 2>&1 | head -50               # ✅ capture stderr
```

## Color

```bash
git --no-pager diff --color=never     # ✅
grep --color=never pattern file       # ✅
```
