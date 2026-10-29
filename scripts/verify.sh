#!/usr/bin/env bash
# ==============================================================================
# Antigravity-OS: System Verification & Health Diagnostic (macOS & Linux)
# ==============================================================================

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

USER_HOME="$HOME"
GLOBAL_GEMINI_SKILLS="$USER_HOME/.gemini/config/skills"
GLOBAL_AGENT_SKILLS="$USER_HOME/.agents/skills"
MCP_CONFIG="$USER_HOME/.gemini/config/mcp_config.json"

echo -e "\n================================================================================"
echo -e "   ANTIGRAVITY-OS SYSTEM DIAGNOSTIC & VERIFICATION (POSIX)"
echo -e "================================================================================"

PASSED=0
TOTAL=0

check_item() {
    local name="$1"
    local cond="$2"
    local details="$3"
    TOTAL=$((TOTAL + 1))
    if [ "$cond" -eq 1 ]; then
        PASSED=$((PASSED + 1))
        echo -e "  ${GREEN}[âœ“] $name: $details${NC}"
    else
        echo -e "  ${RED}[âœ—] $name: $details${NC}"
    fi
}

echo -e "\n${CYAN}1. SKILL INVENTORY AUDIT:${NC}"
GEMINI_COUNT=0
[ -d "$GLOBAL_GEMINI_SKILLS" ] && GEMINI_COUNT=$(find "$GLOBAL_GEMINI_SKILLS" -mindepth 1 -maxdepth 1 -type d | wc -l)
check_item "Gemini Skills Path (~/.gemini/config/skills)" "$([ "$GEMINI_COUNT" -ge 500 ] && echo 1 || echo 0)" "$GEMINI_COUNT skills detected"

AGENT_COUNT=0
[ -d "$GLOBAL_AGENT_SKILLS" ] && AGENT_COUNT=$(find "$GLOBAL_AGENT_SKILLS" -mindepth 1 -maxdepth 1 -type d | wc -l)
check_item "Agent Skills Path (~/.agents/skills)" "$([ "$AGENT_COUNT" -ge 500 ] && echo 1 || echo 0)" "$AGENT_COUNT skills detected"

KEY_SKILLS=("gravitas" "gravitas-highstakes" "using-superpowers" "verification-before-completion" "ponytail" "impeccable" "hallmark" "scrapling" "supabase" "replica-recon" "continuous-learning-v2" "agent-security-hardening" "design-system-audit")
for k in "${KEY_SKILLS[@]}"; do
    HAS_SKILL=0
    [ -d "$GLOBAL_GEMINI_SKILLS/$k" ] && HAS_SKILL=1
    check_item "Critical Skill [$k]" "$HAS_SKILL" "Installed and resolvable"
done


AGENTS_DIR="$USER_HOME/.gemini/config/agents"
AGENT_PERSONAS=0
[ -d "$AGENTS_DIR" ] && AGENT_PERSONAS=$(find "$AGENTS_DIR" -name "*.md" | wc -l)
check_item "Specialist Agent Personas (~/.gemini/config/agents)" "$([ "$AGENT_PERSONAS" -ge 70 ] && echo 1 || echo 0)" "$AGENT_PERSONAS personas detected"


echo -e "\n${CYAN}2. SPECIALIST AGENT PERSONAS AUDIT:${NC}"
AGENTS_DIR="$USER_HOME/.gemini/config/agents"
AGENT_PERSONAS=0
[ -d "$AGENTS_DIR" ] && AGENT_PERSONAS=$(find "$AGENTS_DIR" -name "*.md" | wc -l)
check_item "Specialist Agent Personas (~/.gemini/config/agents)" "$([ "$AGENT_PERSONAS" -ge 70 ] && echo 1 || echo 0)" "$AGENT_PERSONAS personas detected (Target: 71)"

echo -e "\n${CYAN}3. MCP SERVERS CONFIGURATION:${NC}"
HAS_C7=0
HAS_PW=0
if [ -f "$MCP_CONFIG" ]; then
    grep -q "context7" "$MCP_CONFIG" && HAS_C7=1 || true
    grep -q "playwright" "$MCP_CONFIG" && HAS_PW=1 || true
fi
check_item "Context7 MCP Server" "$HAS_C7" "Configured with @upstash/context7-mcp"
check_item "Playwright MCP Server" "$HAS_PW" "Configured with @playwright/mcp"

echo -e "\n${CYAN}4. MANDATORY ATTRIBUTION & DUAL-MEMORY RULES:${NC}"
RULE_PATHS=(
    "$USER_HOME/.gemini/GEMINI.md"
    "$USER_HOME/.gemini/AGENTS.md"
    "$USER_HOME/.gemini/config/AGENTS.md"
    "$USER_HOME/.agents/AGENTS.md"
    "$USER_HOME/.claude/CLAUDE.md"
)
for r in "${RULE_PATHS[@]}"; do
    EXISTS=0
    [ -f "$r" ] && EXISTS=1
    check_item "Rule ${r##$USER_HOME/}" "$EXISTS" "Enforcing 4-Pillars & Token Ledger"
done

echo -e "\n--------------------------------------------------------------------------------"
echo -e "Diagnostic Summary: $PASSED / $TOTAL checks passed."
echo -e "================================================================================\n"


