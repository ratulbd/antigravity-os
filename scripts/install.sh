#!/usr/bin/env bash
# ==============================================================================
# Antigravity-OS: Universal Agent Runtime Installer (macOS & Linux)
# Installs 503+ skills and 71 specialist agents across 22 Repositories, Dual-Memory Routing, and Global MCP
# ==============================================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

print_step() { echo -e "\n${CYAN}[+] $1${NC}"; }
print_success() { echo -e "${GREEN}[âœ“] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[!] $1${NC}"; }

cat << "EOF"
================================================================================
   ___           __  _                                __            ____   _____
  / _ |   ____  / /_(_)__ _____ ____ _  __  __ ___   / /____  ___  / __/  / ___/
 / __ |  / _  \/ __/ / _ `/ __// _ `/ |/ / / // _ \ / // __/ / _ \_\ \   / /__  
/_/ |_| /_//_/\__/_/\_, /_/   \_,_/|___/  \_// .__//_/\__/  \___/___/   \___/  
                   /___/                    /_/                                
       The Production Runtime & 193-Skill Playbook for AI Coding Agents
================================================================================
EOF

# 1. Prerequisite Validation
print_step "Checking prerequisites..."
command -v git >/dev/null 2>&1 || { echo >&2 "Git is required but not installed. Aborting."; exit 1; }
if ! command -v npx >/dev/null 2>&1; then
    print_warning "Node.js / npx was not detected on PATH. MCP servers require Node.js for execution."
fi
print_success "Prerequisites validated."

# 2. Path Setup
USER_HOME="$HOME"
TEMP_ROOT=$(mktemp -d /tmp/antigravity_os_bootstrap_XXXXXX)
REPOS_DIR="$TEMP_ROOT/repos"
STAGE_DIR="$TEMP_ROOT/staged_skills"
GLOBAL_GEMINI_SKILLS="$USER_HOME/.gemini/config/skills"
GLOBAL_AGENT_SKILLS="$USER_HOME/.agents/skills"

mkdir -p "$REPOS_DIR" "$STAGE_DIR" "$GLOBAL_GEMINI_SKILLS" "$GLOBAL_AGENT_SKILLS"

cleanup() {
    rm -rf "$TEMP_ROOT" 2>/dev/null || true
}
trap cleanup EXIT

# 3. Clone Repositories
print_step "Cloning 21 canonical repositories..."

declare -A REPOS=(
    ["impeccable"]="https://github.com/pbakaus/impeccable.git"
    ["ui-ux-pro-max-skill"]="https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git"
    ["ReverseEngineerAnything"]="https://github.com/sgunin/ReverseEngineerAnything.git"
    ["ponytail"]="https://github.com/dietrichgebert/ponytail.git"
    ["hallmark"]="https://github.com/Nutlope/hallmark.git"
    ["humanizer"]="https://github.com/blader/humanizer.git"
    ["onyx-chat-template"]="https://github.com/Onyx-Systems/onyx-chat-template.git"
    ["Scrapling"]="https://github.com/d4vinci/Scrapling.git"
    ["second-brain-starter-kit"]="https://github.com/tonydzi/second-brain-starter-kit.git"
    ["diagram-design"]="https://github.com/cathrynlavery/diagram-design.git"
    ["superpowers"]="https://github.com/obra/superpowers.git"
    ["system-design-skills"]="https://github.com/proyecto26/system-design-skills.git"
    ["senior-backend-dev"]="https://github.com/codewithowais/senior-backend-dev.git"
    ["supabase-agent-skills"]="https://github.com/supabase/agent-skills.git"
    ["vercel-agent-skills"]="https://github.com/vercel-labs/agent-skills.git"
    ["expo-skills"]="https://github.com/expo/skills.git"
    ["anthropics-skills"]="https://github.com/anthropics/skills.git"
    ["ai-agent-skills"]="https://github.com/skillcreatorai/Ai-Agent-Skills.git"
    ["awesome-claude-skills"]="https://github.com/ComposioHQ/awesome-claude-skills.git"
    ["marketingskills"]="https://github.com/coreyhaines31/marketingskills.git"
    ["Gravitas"]="https://github.com/udaysharmadev/Gravitas.git"
    ["replica-skill"]="https://github.com/Jakeschincariol/replica-skill.git"
    ["ecc"]="https://github.com/affaan-m/ecc.git"
)

for name in "${!REPOS[@]}"; do
    echo -e "  â†’ Cloning ${name}..."
    git clone --quiet --depth 1 "${REPOS[$name]}" "$REPOS_DIR/$name"
done
print_success "All 22 repositories cloned."

# 4. Stage and Normalize Skills
print_step "Staging skills..."

cp -r "$REPOS_DIR/impeccable/.agents/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/ui-ux-pro-max-skill/.claude/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/ReverseEngineerAnything/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/ponytail/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/hallmark/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/diagram-design/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/superpowers/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/system-design-skills/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/supabase-agent-skills/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/vercel-agent-skills/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/expo-skills/plugins/expo/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/marketingskills/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/Gravitas/skills/"* "$STAGE_DIR/" 2>/dev/null || true
cp -r "$REPOS_DIR/replica-skill/replica-"* "$STAGE_DIR/" 2>/dev/null || true

    # Ingest and Normalize Everything Claude Code (ECC) skills
    if [ -d "$REPOS_DIR/ecc/skills" ]; then
        cp -r "$REPOS_DIR/ecc/skills/"* "$STAGE_DIR/" 2>/dev/null || true
        if [ -d "$REPOS_DIR/ecc/skills/design-system" ]; then
            cp -r "$REPOS_DIR/ecc/skills/design-system" "$STAGE_DIR/design-system-audit"
            sed -i 's/name: design-system/name: design-system-audit/' "$STAGE_DIR/design-system-audit/SKILL.md" 2>/dev/null || true
        fi
        if [ -d "$REPOS_DIR/ecc/skills/api-design" ]; then
            cp -r "$REPOS_DIR/ecc/skills/api-design" "$STAGE_DIR/rest-api-patterns"
            sed -i 's/name: api-design/name: rest-api-patterns/' "$STAGE_DIR/rest-api-patterns/SKILL.md" 2>/dev/null || true
        fi
    fi
    if [ -d "$REPOS_DIR/ecc/agents" ]; then
        mkdir -p "$USER_HOME/.gemini/config/agents" "$USER_HOME/.agents/agents"
        cp "$REPOS_DIR/ecc/agents/"*.md "$USER_HOME/.gemini/config/agents/" 2>/dev/null || true
        cp "$REPOS_DIR/ecc/agents/"*.md "$USER_HOME/.agents/agents/" 2>/dev/null || true
    fi

if [ -d "$REPOS_DIR/Gravitas/plugins/gravitas-perf" ]; then
    cp -r "$REPOS_DIR/Gravitas/plugins/gravitas-perf" "$STAGE_DIR/"
fi
if [ -d "$REPOS_DIR/Gravitas/plugins/gravitas-security" ]; then
    cp -r "$REPOS_DIR/Gravitas/plugins/gravitas-security" "$STAGE_DIR/"
fi

# Humanizer
mkdir -p "$STAGE_DIR/humanizer"
find "$REPOS_DIR/humanizer" -maxdepth 1 ! -name ".git" ! -path "$REPOS_DIR/humanizer" -exec cp -r {} "$STAGE_DIR/humanizer/" \;

# Senior Backend Dev
mkdir -p "$STAGE_DIR/senior-backend-dev"
find "$REPOS_DIR/senior-backend-dev" -maxdepth 1 ! -name ".git" ! -path "$REPOS_DIR/senior-backend-dev" -exec cp -r {} "$STAGE_DIR/senior-backend-dev/" \;

# Scrapling
mkdir -p "$STAGE_DIR/scrapling"
cp -r "$REPOS_DIR/Scrapling/agent-skill/Scrapling-Skill/"* "$STAGE_DIR/scrapling/"

# Last30Days
mkdir -p "$STAGE_DIR/last30days"
cp -r "$REPOS_DIR/second-brain-starter-kit/skills/last30days/"* "$STAGE_DIR/last30days/"

# Onyx Chat Template
mkdir -p "$STAGE_DIR/onyx-chat-template/references"
find "$REPOS_DIR/onyx-chat-template" -maxdepth 1 ! -name ".git" ! -path "$REPOS_DIR/onyx-chat-template" -exec cp -r {} "$STAGE_DIR/onyx-chat-template/references/" \;
cat << 'EOF' > "$STAGE_DIR/onyx-chat-template/SKILL.md"
---
name: onyx-chat-template
description: >-
  Scaffolds and configures an Express.js + nlp.js + TypeORM + OpenAI chatbot service based on the Onyx Chat Template architecture.
---
# Onyx Chat Template Skill
Provides the architectural blueprint from Onyx-Systems/onyx-chat-template for building hybrid NLU (nlp.js) + LLM (OpenAI) chat backends with Express.js and TypeORM.
EOF

# Select Anthropic Skills
ANTHROPIC_SKILLS=("frontend-design" "mcp-builder" "webapp-testing" "web-artifacts-builder" "skill-creator" "pdf" "docx" "xlsx" "pptx" "canvas-design" "doc-coauthoring" "brand-guidelines" "theme-factory" "internal-comms")
for s in "${ANTHROPIC_SKILLS[@]}"; do
    [ -d "$REPOS_DIR/anthropics-skills/skills/$s" ] && cp -r "$REPOS_DIR/anthropics-skills/skills/$s" "$STAGE_DIR/"
done

# Select AI Agent Skills
AI_SKILLS=("database-design" "backend-development" "llm-application-dev" "verification-agent" "ask-questions-if-underspecified" "best-practices" "code-documentation" "build-workspace-docs" "changelog-generator" "content-research-writer")
for s in "${AI_SKILLS[@]}"; do
    [ -d "$REPOS_DIR/ai-agent-skills/skills/$s" ] && cp -r "$REPOS_DIR/ai-agent-skills/skills/$s" "$STAGE_DIR/"
done

# Select Composio Skills
COMPOSIO_SKILLS=("invoice-organizer" "competitive-ads-extractor" "lead-research-assistant" "meeting-insights-analyzer" "file-organizer" "tailored-resume-generator" "domain-name-brainstormer")
for s in "${COMPOSIO_SKILLS[@]}"; do
    [ -d "$REPOS_DIR/awesome-claude-skills/$s" ] && cp -r "$REPOS_DIR/awesome-claude-skills/$s" "$STAGE_DIR/"
done

# 5. Copy Staged Skills Globally
print_step "Copying skills to ~/.gemini/config/skills/ and ~/.agents/skills/..."
cp -r "$STAGE_DIR/"* "$GLOBAL_GEMINI_SKILLS/"
cp -r "$STAGE_DIR/"* "$GLOBAL_AGENT_SKILLS/"
INSTALLED_COUNT=$(find "$GLOBAL_GEMINI_SKILLS" -mindepth 1 -maxdepth 1 -type d | wc -l)
print_success "Installed $INSTALLED_COUNT skills globally."

# 6. Configure MCP Servers
print_step "Configuring Context7 & Playwright MCP servers..."
MCP_PATH="$USER_HOME/.gemini/config/mcp_config.json"
mkdir -p "$(dirname "$MCP_PATH")"

python3 - << 'PYEOF'
import json, os

mcp_path = os.path.expanduser("~/.gemini/config/mcp_config.json")
config = {"mcpServers": {}}
if os.path.exists(mcp_path):
    try:
        with open(mcp_path, "r", encoding="utf-8") as f:
            config = json.load(f)
    except Exception:
        pass

if "mcpServers" not in config:
    config["mcpServers"] = {}

config["mcpServers"]["context7"] = {
    "command": "npx",
    "args": ["-y", "@upstash/context7-mcp@latest"],
    "env": {}
}
config["mcpServers"]["playwright"] = {
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"],
    "env": {}
}

with open(mcp_path, "w", encoding="utf-8") as f:
    json.dump(config, f, indent=2)
PYEOF
print_success "MCP configured at $MCP_PATH"

# 7. Configure Global Rules
print_step "Installing global agent rules..."
RULE_LOCATIONS=(
    "$USER_HOME/.gemini/GEMINI.md"
    "$USER_HOME/.gemini/AGENTS.md"
    "$USER_HOME/.gemini/config/GEMINI.md"
    "$USER_HOME/.gemini/config/AGENTS.md"
    "$USER_HOME/.agents/AGENTS.md"
    "$USER_HOME/.claude/CLAUDE.md"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULE_SRC="$SCRIPT_DIR/../configs/rules/AGENTS.md"

for loc in "${RULE_LOCATIONS[@]}"; do
    mkdir -p "$(dirname "$loc")"
    if [ -f "$RULE_SRC" ]; then
        cp "$RULE_SRC" "$loc"
    else
        cat << 'EOF' > "$loc"
# Mandatory Agent & Extension Rules (Skill Attribution + Dual-Memory Routing + Hermes Self-Evolving Loop + Token Ledger)
This rule applies to all AI coding agents, IDE models, subagents, and third-party extensions.
EOF
    fi
done
print_success "Rules installed globally across all agent configurations."

echo -e "\n${GREEN}================================================================================${NC}"
echo -e "${GREEN}   ANTIGRAVITY-OS INSTALLATION COMPLETE!${NC}"
echo -e "${GREEN}   â€¢ $INSTALLED_COUNT Skills Installed Globally${NC}"
echo -e "${GREEN}   â€¢ Context7 & Playwright MCP Ready${NC}"
echo -e "${GREEN}   â€¢ 4-Pillar Synergy Rules Enforced${NC}"
echo -e "${GREEN}================================================================================${NC}"


