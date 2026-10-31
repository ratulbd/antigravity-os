# 02. Empirical Token Benchmarks & The Token Ledger

## Token Savings Philosophy

The most expensive failure mode of LLM agents is **redundant context loading**:
1. Reading full 1,000-line source files just to inspect a 10-line helper function.
2. Repeating failed debugging hypotheses because the agent forgot what failed two turns ago.
3. Generating hundreds of lines of boilerplate factory classes that violate YAGNI.

**Antigravity-OS** introduces the mandatory **Per-Prompt Token Ledger** to measure and enforce efficiency on every single output turn.

---

## Benchmark Comparison Matrix

| Workflow Scenario | Raw LLM Baseline | Antigravity-OS Runtime | Measured Reduction |
| :--- | :--- | :--- | :--- |
| **Locating a Handler & Call Chain** | **~32,000 tokens**<br>(Scanning 4–6 full files via grep/read) | **~350 tokens**<br>(AST graph query via `codebase-memory-mcp`) | **▼ 98.9%** |
| **Investigating Known Regression** | **~28,500 tokens**<br>(3–4 trial-and-error debugging cycles) | **~2,400 tokens**<br>(Querying `.trail/learnings` + Gravitas gate) | **▼ 91.5%** |
| **Adding New UI Route & View** | **~24,000 tokens**<br>(Scraping existing components for styling) | **~4,100 tokens**<br>(Pillar 1 `/docs/03_UI_Spec.md` token read) | **▼ 82.9%** |
| **Generated Code Boilerplate** | **~1,200 LOC output**<br>(Over-engineered factories & multi-tenant wrappers) | **~560 LOC output**<br>(Filtered via `ponytail` YAGNI filter) | **▼ 53.3% LOC<br>▼ 45.0% Output Tokens** |

---

## How to Calculate the Token Ledger Honestly

Every substantive response in Antigravity-OS includes this attribution and token comparison block:

```markdown
> **Skills Used:** <skill-name-1>, <skill-name-2> *(or None — General Reasoning)*
> **MCP Tools Used:** <mcp-server-name> *(e.g., codebase-memory-mcp, context7, playwright, or None)*
> **Token Impact (Turn):** **Used:** ~<X> tokens | **Without Setup (Baseline):** ~<Y> tokens | **Saved:** ~<Y-X> tokens (<Z>%) — <brief reason>
> **Global Context (Session):** **Active Window:** ~<W>k tokens *(~<C>% Cached)* | **Steps:** <S> *(or `/compact` recommended if >60k)*
```

### Calculation Rules:
* **Turn Impact (Used ~X tokens):** The tokens actually consumed by snippets, tool outputs, and prompt/response in this turn (~1 token per 4 characters) vs baseline if full files had been read.
* **Global Context (Active Window ~Wk tokens):** The cumulative size of the active conversation thread (prompts + system prompt + tool calls + prior responses) and prompt cache ratio. Directly drives the 5h/weekly quota meter. When the active window exceeds ~60k–80k tokens, advise `/compact` to prevent rapid quota depletion.
* **Pure Q&A Turns:** Report `Saved: ~0 tokens (0%) — Direct Q&A` to ensure honesty and avoid fabricated savings.
