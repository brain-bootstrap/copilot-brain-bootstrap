# Bootstrap Prompt — ᗺB Brain Bootstrap (Copilot Edition)

> **This file is read by GitHub Copilot Chat during `/bootstrap`.** Works on both fresh repos and repos with an existing Copilot configuration.
> Powered by [Brain Bootstrap](https://github.com/brain-bootstrap/copilot-brain-bootstrap) · by brain-bootstrap
> The AI will detect your tech stack, then either install from scratch or **intelligently upgrade** your existing config — preserving all your domain knowledge, lessons, and customizations.

---

## ⛔ READ THIS FIRST — FILES YOU MUST NEVER CREATE

Bootstrap is **READ + CONFIGURE**. You document what exists. You do not initialize or scaffold the project.

**Never create these files:**

- Any `*.lock` file (`yarn.lock`, `package-lock.json`, `pnpm-lock.yaml`, `bun.lockb`)
- Package manager configs for tools **not already in the project**
- Any `.env*` file

The ONLY paths you write to: `context/`, `.github/copilot-instructions.md`.

---

## ⭐ START HERE — READ · PLAN · EXECUTE (mandatory before any tool call)

**Three rules that govern the entire bootstrap:**

**1. SCAN EVERYTHING FIRST** — before running any command, skim all `### Phase` headings below. You need the full mental model before the first tool call. Takes 30 seconds. Prevents skipping steps.

**2. WRITE YOUR PLAN FIRST** — your very first action is to create `context/tasks/.bootstrap-plan.txt`:

```
MODE: TBD (Phase 1 will set this)
P1: discover stack + set MODE
P2: IF UPGRADE → read+execute context/bootstrap/UPGRADE_GUIDE.md (ALL steps A-D) — HARD GATE, cannot skip
    IF FRESH  → skip Phase 2 entirely, go directly to Phase 3
P3: fill all placeholders in copilot-instructions.md + context/*.md
P4: domain detection + domain docs
P5: validate + report
Risk: [one specific risk for THIS repo — fill in after Phase 1]
```

**You may NOT run any other command until the plan exists.** Update `Risk:` after Phase 1. Update `P2:` with actual MODE after Phase 1.

**3. ALWAYS BATCH PARALLEL READS** — reading N files sequentially costs N×3s. Reading N in parallel costs 3s once. Whenever you need ≥2 files: read them all in one parallel batch. Applies every phase.

---

## ⚡ AUTONOMOUS EXECUTION MODE — MANDATORY

**Execute all operations immediately and autonomously. Do NOT ask for permission. Do NOT pause between phases. Do NOT say "shall I proceed?" — just proceed.**

If you hit ambiguity, make the best choice and document it in the report. Only stop for genuine blockers.

---

## 📋 Phase Map

| Phase             | Applies to          | Core action                                     | Expected AI-work |
| :---------------- | :------------------ | :---------------------------------------------- | :--------------: |
| **1** Discovery   | Both                | Probe stack → set MODE                          |       ~2s        |
| **2** Smart Merge | **UPGRADE ONLY** ⛔ | Read guide → preserve + enhance — **HARD GATE** |     1–3 min      |
| **3** Populate    | Both                | Fill all placeholders across 6 files            |     3–5 min      |
| **4** Domains     | Both                | Detect + document project-specific patterns     |     2–3 min      |
| **5** Validate    | Both                | Run validate.sh · report from REFERENCE.md      |       30s        |

> ⚠️ **Phase 2 is mandatory for UPGRADE mode.** FRESH installs jump from Phase 1 → Phase 3 directly.

---

## 🔴 Quality Standards — memorize, apply every phase

- **NEVER lose user data** — lessons, domain docs, task state are irreplaceable. No exceptions.
- **Real patterns only** — read actual source files. Generic filler defeats the purpose.
- **First-session productive** — every file must work immediately after bootstrap.
- **UPGRADE = additive** — never remove or overwrite existing user-written content.
- **Stack-aware, not kitchen-sink** — only document tools ACTUALLY detected.
- **No phantom files** — NEVER create empty placeholder files.

---

### Phase 1: Discovery

Run the following in parallel to understand the stack:

```bash
find . -maxdepth 3 -name 'package.json' -not -path '*/node_modules/*' 2>/dev/null | head -20
find . -maxdepth 3 \( -name 'pyproject.toml' -o -name 'requirements.txt' -o -name 'Cargo.toml' -o -name 'go.mod' \) 2>/dev/null | head -10
ls -la
```

Then read in parallel (if they exist):

- `package.json` (top-level, first 40 lines)
- `.github/workflows/*.yml` (first CI file found)
- `context/tasks/lessons.md`
- `context/tasks/todo.md`

Determine:

- **MODE**: `FRESH` (no placeholders filled, no domain knowledge yet) or `UPGRADE` (existing content with real values)
- **Stack**: runtime, languages, package manager, test framework, build tools, CI
- **Architecture**: monorepo / single-app / dual-tier / library

Update `Risk:` in your bootstrap plan now.

> **⚠️ SELF-BOOTSTRAP CHECK (mandatory):** If you are running inside the `copilot-brain-bootstrap` repo itself, **STOP**. Install into your project repo, not the template.

**After Phase 1: check your plan. What is MODE?**

- MODE=FRESH → proceed to Phase 3 (skip Phase 2 entirely)
- MODE=UPGRADE → **you MUST do Phase 2 before Phase 3. Do NOT skip it.**

---

### Phase 2: Smart Merge — 🚨 UPGRADE ONLY (FRESH: skip to Phase 3)

> ⛔ **HARD GATE — DO NOT PROCEED TO PHASE 3 UNTIL THIS IS COMPLETE.**
> This phase exists to protect user data. Skipping it will overwrite or erase domain knowledge.

**If MODE=UPGRADE:**

Read the full upgrade guide now and follow ALL steps A through D before continuing:

```
read_file context/bootstrap/UPGRADE_GUIDE.md
```

Execute every step in the guide. Do not summarize or abbreviate — follow each step literally.

**✅ Phase 2 is complete when:**

- `bash validate.sh` passes
- No user-written content was modified or removed
- All remaining `{{PLACEHOLDER}}` tokens are identified (not yet filled — that's Phase 3)

Only after all three conditions are met: proceed to Phase 3.

---

### Phase 3: Fill Placeholders

> TL;DR: Fill all `{{PLACEHOLDER}}` tokens across 6 files. Read source files to get REAL values — not invented ones.

**Read all 6 files in parallel first:**

- `.github/copilot-instructions.md`
- `context/architecture.md`
- `context/build.md`
- `context/cve-policy.md`
- `context/rules.md`
- `context/plugins.md`

Then fill each file:

#### 3.1 `.github/copilot-instructions.md`

- `{{PROJECT_NAME}}` → actual project name (from `package.json`, `Cargo.toml`, `go.mod`, etc.)
- `{{CRITICAL_PATTERNS}}` → leave empty for now (Phase 4 will populate this)

#### 3.2 `context/architecture.md`

Fill all `{{DIR_N}}`, `{{SERVICE_N}}`, `{{INFRA_N}}` placeholders with REAL values from the repo:

```bash
ls -d */ 2>/dev/null | head -20
```

For monorepos, check each top-level dir for `package.json`, `Cargo.toml`, etc.

#### 3.3 `context/build.md`

Fill all `{{BUILD_CMD_*}}`, `{{TEST_CMD_*}}`, `{{LINT_*}}`, `{{RUNTIME}}`, `{{PACKAGE_MANAGER}}` with real commands. Derive them from `package.json` scripts, `Makefile`, `pyproject.toml`, etc. Do NOT invent commands — read the actual config files.

#### 3.4 `context/cve-policy.md`

Update the audit commands for detected runtimes:

- Node.js → `npm audit` / `pnpm audit` / `yarn audit`
- Python → `pip-audit` / `safety`
- Rust → `cargo audit`
- Go → `govulncheck`
- Java → `mvn dependency-check:check`

#### 3.5 `context/rules.md`

Add project-specific rules discovered. Look for:

- Hard constraints in README, CONTRIBUTING, or comments
- Dangerous patterns the codebase tries to avoid
- Non-obvious conventions enforced by linters or hooks

#### 3.6 `context/plugins.md`

Set each plugin to `ENABLED` or `DISABLED` based on detection:

```bash
ls -la .cocoindex_code/ .serena/ 2>/dev/null
find . -maxdepth 2 -name 'playwright.config.*' 2>/dev/null
```

---

### Phase 4: Domain Detection + Critical Patterns

> 🧠 **Most important phase.** Real patterns from real source files. Generic advice is worthless.

**Step 0 (BEFORE creative work): Run all domain greps in parallel:**

```bash
# Messaging (Kafka/RabbitMQ/SQS/NATS)
grep -rl 'KafkaConsumer\|KafkaProducer\|createTopic\|RabbitMQ\|SQSClient\|NATS\|publishMessage' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
# DB / multi-connection
grep -rl 'knex\|\.db\.\|createConnection\|getRepository\|DataSource\|prisma\.' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
# State machine / lifecycle
grep -rl 'StatusCode\|StatusEnum\|\.state\b\|transition\|workflow.*state\|state.*machine' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
# Auth / identity
grep -rl 'keycloak\|realm\|grant_type\|jwt\|bearer\|guard\|protect\|token.*verify' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
# Webhooks / callbacks
grep -rl 'onConflict\|delivery.*id\|idempotent\|webhook.*url\|callback.*endpoint' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
# API / HTTP layer
grep -rl 'router\.\|app\.get\|app\.post\|fastify\|express\|koa\|hono' . --include='*.js' --include='*.ts' 2>/dev/null | head -5 || true
```

For each domain with hits: read 2–3 actual source files, then create `context/<domain>.md` with REAL patterns. Update `{{CRITICAL_PATTERNS}}` in `.github/copilot-instructions.md` with 3–5 rules that are specific to THIS codebase.

**Depth rule**: A 20-line doc with 3 real patterns beats 100 lines of filler.

---

### Phase 5: Validate + Report

Run validation:

```bash
bash validate.sh 2>&1
```

Then read `context/bootstrap/REFERENCE.md` for the report template. Fill in ALL fields and present the final report to the user.

**Do NOT commit.** Present the summary and wait for user confirmation.

---

> 💡 **After bootstrap:** Every correction you make gets captured in `context/tasks/lessons.md` — the AI literally cannot make the same mistake twice.
