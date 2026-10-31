# Mandatory Agent & Extension Rules (Skill Attribution + Dual-Memory Routing + Hermes Self-Evolving Loop + Token Ledger)

This rule applies to **all AI coding agents, IDE models, subagents, and third-party extensions** (including Google Antigravity, Gemini CLI, Claude Code, Cursor, GitHub Copilot, Windsurf, Cline, Roo Code, and OpenCode).

---

## 1. Mandatory Skill Activation, MCP Disclosure & Dual Token Ledger (Turn + Global Context)
Before writing code, designing systems/databases, debugging, or producing any output, you MUST check and apply the relevant global skills installed in:
- `$globalGeminiSkills\` (`~/.gemini/config/skills/`)
- `$globalAgentSkills\` (`~/.agents/skills/`)

Whenever you write code, propose an architecture, debug, review, or give any substantive output, you **MUST include this exact 4-line dual attribution & token ledger block** at the top or bottom of your response:

> **Skills Used:** `<skill-name-1>`, `<skill-name-2>` *(or `None — General Reasoning`)*  
> **MCP Tools Used:** `<mcp-server-name>` *(e.g., `codebase-memory-mcp`, `context7`, `playwright`, `StitchMCP`, or `None`)*  
> **Token Impact (Turn):** **Used:** `~<X> tokens` | **Without Setup (Baseline):** `~<Y> tokens` | **Saved:** `~<Y-X> tokens (<Z>%)` — *<brief reason: e.g., AST graph query via codebase-memory-mcp vs full file read, spec lookup, or Ponytail YAGNI filter>*  
> **Global Context (Session):** **Active Window:** `~<W>k tokens` *(~<C>% Cached)* | **Steps:** `<S>` *(or `/compact` recommended if >60k)*

### How to Calculate Both Ledger Metrics Honestly:
- **Turn Impact (Used ~X tokens):** Estimate tokens consumed by files/snippets/MCP responses actually loaded in this turn (~1 token per 4 characters of tool output + prompt/response) vs baseline if full files had been read.
- **Global Context (Active Window ~Wk tokens):** The current conversation context window size (fresh input + cached context tokens, typically recorded in transcript or estimated by conversation length), cache ratio, and step count. When active window exceeds 60k tokens, advise `/compact` to avoid accelerating 5h/weekly quota consumption.
- If a turn is pure general conversation where no repo/skill shortcut applied, report `Saved: ~0 tokens (0%) — Direct Q&A`.

---

## 2. Mandatory Dual-Memory Scenario Dispatch Protocol (codebase-memory-mcp + ai-memory)

To eliminate context amnesia across agents, repeated debugging loops, and unnecessary full-file token consumption, you are **STRICTLY BOUND** to route your memory and structural queries according to this 4-scenario decision matrix:

| Scenario | Trigger / Intent | Tool Selected | Execution Mode & Ordering | Typical Token Savings |
| :--- | :--- | :--- | :--- | :--- |
| **A. Structural Navigation & Symbol Lookup** | *"Where is function X?", "Find callers of Y", "List methods in class Z", "Trace route to handler"* | `codebase-memory-mcp` | **Single-Tool:** Call `search_graph`, `trace_path`, or `get_code_snippet`. Do NOT query narrative memory. | **85–95%** (~150 tokens vs reading entire source files) |
| **B. Architectural Intent & Past Context** | *"Why did we choose X?", "What is our auth convention?", "Explain architecture", "Onboard me"* | `ai-memory` / `.trail` | **Single-Tool:** Call `ai-memory.query_memory` or inspect `.trail/learnings/`. Do NOT scan AST code. | **60–80%** (~250 tokens vs grepping git history) |
| **C. Bug Investigation & Debugging** | *"Fix error X", "Tests failing in Y", "Investigate regression", "Why is this null?"* | **Both** (`ai-memory` → `codebase-memory-mcp`) | **Strict 2-Phase Sequence:**<br>1. **Phase 1 (Experiential):** Query `ai-memory` for `## Tried and ruled out` and known environment quirks.<br>2. **Phase 2 (Structural):** Query `codebase-memory-mcp` (`trace_path`, `search_graph`) to locate the exact broken symbol call-chain. | **70–90%** (Eliminates 2–4 wasted trial-and-error debugging cycles) |
| **D. New Feature & Major Refactoring** | *"Implement feature X", "Refactor module Y", "Add API endpoint Z", "Migrate schema"* | **Both** (`ai-memory` → `codebase-memory-mcp`) | **Strict 2-Phase Sequence:**<br>1. **Phase 1 (Intent & Rules):** Query `ai-memory` / `/docs/` for conventions, design tokens, and constraints.<br>2. **Phase 2 (Blast Radius):** Query `codebase-memory-mcp` for downstream callers, imports, and dependencies. | **65–85%** (Prevents architectural drift and broken imports) |

---

## 3. The 4 Complementary Architecture Pillars (Non-Overlap Contract)

| Pillar | Tool / Location | Responsibility (Strict Non-Overlap Rule) |
| :--- | :--- | :--- |
| **Pillar 1: Prescriptive Specs** | `/docs/01_PRD.md` → `06_Plan.md` (`context-architecture`) | **WHAT & WHY to build:** Product scope, UI tokens, CSS contracts, API schemas, phase checklist. |
| **Pillar 2: Structural AST Graph** | `codebase-memory-mcp` (Native MCP Server) | **HOW code is wired right now:** Primary 158-language Tree-sitter + SQLite AST graph. Query for symbols, call graphs, and blast radius. |
| **Pillar 3: Episodic Session Memory** | `ai-memory` & `Trail-Code` (`.trail/learnings/`) | **WHAT was tried, ruled out, & learned:** Stores debugging dead-ends, rejected hypotheses, and cross-agent narrative history. |
| **Pillar 4: Specialist Execution & Media** | `agency-agents`, `ponytail`, & `openmontage` | **WHO executes & HOW code/media is produced:** Role personas (`agency-agents`), YAGNI minimal code (`ponytail`), and Remotion/FFmpeg video studio (`openmontage`). |

---

## 4. Hermes Self-Evolving Procedural Skill Loop
1. **Never Forget How a Problem Was Solved:** Whenever you resolve a non-obvious bug, environment quirk, or architectural trade-off, record a structured learning (`## Decided`, `## Tried and ruled out`, `## Watch out`) into `ai-memory` and `.trail/learnings/`.
2. **Auto-Generate Reusable Skills (`skill-creator`):** Whenever you solve a novel, repeatable multi-step workflow (3+ steps requiring troubleshooting or custom tool orchestration), automatically synthesize a new `SKILL.md` in `$globalGeminiSkills\<skill-name>\SKILL.md` and `$globalAgentSkills\<skill-name>\SKILL.md`.
3. **Self-Patch Existing Skills:** Whenever an installed `SKILL.md` contains an outdated CLI flag or broken pattern, immediately patch that `SKILL.md` in both global directories.

---

## 5. Unfamiliar Features & External Reference Protocol (Anti-Hallucination & YAGNI Filter)
For unfamiliar libraries, complex algorithms, or external domain patterns:
1. **Target Official Examples & Context7 First:** Query context7 or official SDK examples before scraping general repositories.
2. **Scan Architecture, Not Boilerplate:** Extract ONLY the core data flow, critical API sequence, and non-obvious edge cases (<= 50 lines of reference). Never dump entire external repositories or multi-file boilerplate into the context window.
3. **Filter for Modernity:** Verify that the reference uses current LTS/stable APIs. Reject deprecated methods from older high-star repositories.
4. **Enforce the YAGNI Filter (Ponytail):** Strip away generic multi-tenant abstractions, extra factory wrappers, and unneeded dependencies. Implement the absolute minimum code that fulfills the requirement cleanly within our existing conventions.
