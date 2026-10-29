# 01. The 4-Pillar Synergy Architecture

## Overview

Modern AI coding agents fail not from a lack of reasoning intelligence, but from **architectural amnesia, unconstrained blast radius, and unstructured context pollution**. 

**Antigravity-OS** solves this by establishing a **deterministic 4-Pillar non-overlap contract**. Each pillar owns an exclusive concern:

```
┌────────────────────────────────────────────────────────┐
│  Pillar 1: /docs/ (PRD, Specs, System Architecture)   │  WHAT & WHY to build
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│  Pillar 2: codebase-memory-mcp (Tree-sitter AST Graph) │  HOW code is wired
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│  Pillar 3: Trail-Code (.trail/learnings/ + ai-memory)  │  WHAT failed & was learned
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│  Pillar 4: Specialist Execution + Mechanical Gates     │  HOW code is safely mutated
│  (Ponytail YAGNI + Superpowers TDD + Gravitas Runtime) │
└────────────────────────────────────────────────────────┘
```

---

## The Non-Overlap Responsibility Matrix

| Pillar | Engine / Location | Strict Non-Overlap Responsibility | Replaced Fragile Workaround |
| :--- | :--- | :--- | :--- |
| **Pillar 1: Prescriptive Specs** | `/docs/01_PRD.md` → `06_Plan.md` | **WHAT & WHY to build:** Product scope, UI tokens, CSS class contracts, API schemas, and milestone checklists. | Replaces guessing architectural intent by scraping entire repos. |
| **Pillar 2: Structural AST Graph** | `codebase-memory-mcp` (Tree-sitter + SQLite) | **HOW code is wired right now:** 158-language AST graph. Query for symbols, callers, callees, and blast radius. | Replaces naive full-file reads (35,000 tokens down to 350 tokens). |
| **Pillar 3: Episodic Session Memory** | `Trail-Code` (`.trail/learnings/`) & `ai-memory` | **WHAT was tried, ruled out, & learned:** Stores debugging dead-ends, rejected hypotheses, and environment gotchas. | Replaces 2–4 wasted trial-and-error debugging cycles on repeated errors. |
| **Pillar 4: Specialist Execution** | `Gravitas` + `Ponytail` + `Superpowers` | **HOW code is executed:** Write-scope locking (`allowed_write_scope`), fresh post-mutation validator gates, and YAGNI code minimization. | Replaces premature "I fixed it" hallucinations and scope creep. |

---

## 4-Scenario Dual-Memory Dispatch Protocol

Agents are bound to route structural and experiential queries according to this 4-scenario decision matrix:

### Scenario A: Structural Navigation & Symbol Lookup
* **Trigger:** *"Where is function X?", "Find callers of Y", "List methods in class Z", "Trace route to handler"*
* **Dispatch:** `codebase-memory-mcp` (Single-Tool: `search_graph`, `trace_path`, `get_code_snippet`).
* **Rule:** Do NOT query narrative memory or read full files.

### Scenario B: Architectural Intent & Past Context
* **Trigger:** *"Why did we choose X?", "What is our auth convention?", "Explain architecture", "Onboard me"*
* **Dispatch:** `ai-memory` / `.trail` (Single-Tool).
* **Rule:** Do NOT scan AST code or git logs.

### Scenario C: Bug Investigation & Debugging
* **Trigger:** *"Fix error X", "Tests failing in Y", "Investigate regression", "Why is this null?"*
* **Dispatch:** **Strict 2-Phase Sequence:**
  1. **Phase 1 (Experiential):** Query `.trail/learnings/` / `ai-memory` for `## Tried and ruled out` and known quirks.
  2. **Phase 2 (Structural):** Query `codebase-memory-mcp` to isolate the exact broken symbol call-chain.

### Scenario D: New Feature & Major Refactoring
* **Trigger:** *"Implement feature X", "Refactor module Y", "Add API endpoint Z", "Migrate schema"*
* **Dispatch:** **Strict 2-Phase Sequence:**
  1. **Phase 1 (Intent & Rules):** Query `/docs/` for design tokens and schema contracts.
  2. **Phase 2 (Blast Radius):** Query `codebase-memory-mcp` for downstream callers and dependencies.
