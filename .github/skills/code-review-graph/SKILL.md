---
name: code-review-graph
description: 'Generate architectural dependency graphs. Visualize module relationships, detect circular dependencies, spot architectural drift.'
user-invocable: true
---

# Code Review Graph Skill

Visualize your codebase architecture to detect dependency issues and architectural drift.

## Use Cases

- Spot circular dependencies before they become a maintenance nightmare
- Visualize which modules depend on which
- Detect architecture drift from the intended design in `claude/architecture.md`
- Understand blast radius of a change

## Operations

### Generate dependency graph
```bash
# Install if needed
npm install -g dependency-cruiser 2>&1 | tail -5

# Generate graph (Graphviz dot format)
npx depcruise src --include-only '^src' --output-type dot 2>&1 | head -50
```

### Check for circular dependencies
```bash
npx depcruise src --include-only '^src' --output-type err 2>&1 | head -30
```

## Reading the Output

- Arrows point from importer to imported
- Circular dependency = cycle in the graph → 🔴 refactor needed
- "God module" (many incoming arrows) → candidate for splitting
- Isolated module (no connections) → may be dead code

## Rules

- Circular dependencies between domain layers are always a bug
- Cross-layer imports (API layer importing from DB layer) → architecture violation
