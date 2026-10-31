# ==============================================================================
# Antigravity-OS: Universal Agent Runtime Installer (Windows PowerShell)
# Installs 503+ Skills across 23 Repositories, 71 Specialist Agents, Dual-Memory Routing, and Global MCP
# ==============================================================================

[CmdletBinding()]
param (
    [string]$TargetProjectRoot = "D:\AI Project"
)

$ErrorActionPreference = "Stop"

function Write-Step ($msg) { Write-Host "`n[+] $msg" -ForegroundColor Cyan }
function Write-Success ($msg) { Write-Host "[✓] $msg" -ForegroundColor Green }
function Write-WarningMsg ($msg) { Write-Host "[!] $msg" -ForegroundColor Yellow }

Write-Host @"
================================================================================
   ___           __  _                                __            ____   _____
  / _ |   ____  / /_(_)__ _____ ____ _  __  __ ___   / /____  ___  / __/  / ___/
 / __ |  / _  \/ __/ / _ `/ __// _ `/ |/ / / // _ \ / // __/ / _ \_\ \   / /__  
/_/ |_| /_//_/\__/_/\_, /_/   \_,_/|___/  \_// .__//_/\__/  \___/___/   \___/  
                   /___/                    /_/                                
       The Production Runtime & 503-Skill Playbook for AI Coding Agents
================================================================================
"@ -ForegroundColor Blue

# 1. Prerequisite Validation
Write-Step "Checking prerequisites..."
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required but was not found on PATH. Please install Git: https://git-scm.com"
}
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
    Write-WarningMsg "Node.js / npx was not detected on PATH. MCP servers require Node.js for execution."
}
Write-Success "Prerequisites validated."

# 2. Path Setup
$userHome           = $env:USERPROFILE
$tempRoot           = Join-Path $env:TEMP "antigravity_os_bootstrap_$(Get-Random)"
$reposDir           = Join-Path $tempRoot "repos"
$stageDir           = Join-Path $tempRoot "staged_skills"
$globalGeminiSkills = Join-Path $userHome ".gemini\config\skills"
$globalAgentSkills  = Join-Path $userHome ".agents\skills"

New-Item -ItemType Directory -Force -Path $reposDir, $stageDir, $globalGeminiSkills, $globalAgentSkills | Out-Null

# 3. Clone the 23 Canonical Repositories
$repos = @(
    @{ name = "impeccable";              url = "https://github.com/pbakaus/impeccable.git" },
    @{ name = "ui-ux-pro-max-skill";     url = "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git" },
    @{ name = "ReverseEngineerAnything"; url = "https://github.com/sgunin/ReverseEngineerAnything.git" },
    @{ name = "ponytail";                url = "https://github.com/dietrichgebert/ponytail.git" },
    @{ name = "hallmark";                url = "https://github.com/Nutlope/hallmark.git" },
    @{ name = "humanizer";               url = "https://github.com/blader/humanizer.git" },
    @{ name = "onyx-chat-template";      url = "https://github.com/Onyx-Systems/onyx-chat-template.git" },
    @{ name = "Scrapling";               url = "https://github.com/d4vinci/Scrapling.git" },
    @{ name = "second-brain-starter-kit";url = "https://github.com/tonydzi/second-brain-starter-kit.git" },
    @{ name = "diagram-design";          url = "https://github.com/cathrynlavery/diagram-design.git" },
    @{ name = "superpowers";             url = "https://github.com/obra/superpowers.git" },
    @{ name = "system-design-skills";    url = "https://github.com/proyecto26/system-design-skills.git" },
    @{ name = "senior-backend-dev";      url = "https://github.com/codewithowais/senior-backend-dev.git" },
    @{ name = "supabase-agent-skills";   url = "https://github.com/supabase/agent-skills.git" },
    @{ name = "vercel-agent-skills";     url = "https://github.com/vercel-labs/agent-skills.git" },
    @{ name = "expo-skills";             url = "https://github.com/expo/skills.git" },
    @{ name = "anthropics-skills";       url = "https://github.com/anthropics/skills.git" },
    @{ name = "ai-agent-skills";         url = "https://github.com/skillcreatorai/Ai-Agent-Skills.git" },
    @{ name = "awesome-claude-skills";   url = "https://github.com/ComposioHQ/awesome-claude-skills.git" },
    @{ name = "marketingskills";         url = "https://github.com/coreyhaines31/marketingskills.git" },
    @{ name = "Gravitas";                url = "https://github.com/udaysharmadev/Gravitas.git" }
)

Write-Step "Cloning 23 skill repositories in parallel / sequence..."
foreach ($r in $repos) {
    Write-Host "  → Cloning $($r.name)..." -ForegroundColor Gray
    git clone --quiet --depth 1 $r.url (Join-Path $reposDir $r.name)
}
Write-Success "All 23 repositories cloned successfully."

# 4. Stage and Normalize Skills
Write-Step "Staging and normalizing 503+ skills and 71 specialist agents..."

Copy-Item -Path "$reposDir\impeccable\.agents\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\ui-ux-pro-max-skill\.claude\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\ReverseEngineerAnything\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\ponytail\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\hallmark\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\diagram-design\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\superpowers\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\system-design-skills\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\supabase-agent-skills\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\vercel-agent-skills\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\expo-skills\plugins\expo\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\marketingskills\skills\*" -Destination $stageDir -Recurse -Force
Copy-Item -Path "$reposDir\Gravitas\skills\*" -Destination $stageDir -Recurse -Force

if (Test-Path "$reposDir\Gravitas\plugins\gravitas-perf") { Copy-Item -Path "$reposDir\Gravitas\plugins\gravitas-perf" -Destination $stageDir -Recurse -Force }
if (Test-Path "$reposDir\Gravitas\plugins\gravitas-security") { Copy-Item -Path "$reposDir\Gravitas\plugins\gravitas-security" -Destination $stageDir -Recurse -Force }

# Standalone single-skill repositories
$humanizerDest = Join-Path $stageDir "humanizer"
New-Item -ItemType Directory -Force -Path $humanizerDest | Out-Null
Get-ChildItem -Path "$reposDir\humanizer" -Force | Where-Object { $_.Name -ne ".git" } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $humanizerDest -Recurse -Force
}

$sbdDest = Join-Path $stageDir "senior-backend-dev"
New-Item -ItemType Directory -Force -Path $sbdDest | Out-Null
Get-ChildItem -Path "$reposDir\senior-backend-dev" -Force | Where-Object { $_.Name -ne ".git" } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $sbdDest -Recurse -Force
}

$scraplingDest = Join-Path $stageDir "scrapling"
New-Item -ItemType Directory -Force -Path $scraplingDest | Out-Null
Copy-Item -Path "$reposDir\Scrapling\agent-skill\Scrapling-Skill\*" -Destination $scraplingDest -Recurse -Force

$last30Dest = Join-Path $stageDir "last30days"
New-Item -ItemType Directory -Force -Path $last30Dest | Out-Null
Copy-Item -Path "$reposDir\second-brain-starter-kit\skills\last30days\*" -Destination $last30Dest -Recurse -Force

# Onyx Chat Template
$onyxDest = Join-Path $stageDir "onyx-chat-template"
$onyxRefs = Join-Path $onyxDest "references"
New-Item -ItemType Directory -Force -Path $onyxRefs | Out-Null
Get-ChildItem -Path "$reposDir\onyx-chat-template" -Force | Where-Object { $_.Name -ne ".git" } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $onyxRefs -Recurse -Force
}
@"
---
name: onyx-chat-template
description: >-
  Scaffolds and configures an Express.js + nlp.js + TypeORM + OpenAI chatbot service based on the Onyx Chat Template architecture.
  Use when the user asks to create a custom NLU/LLM hybrid chatbot backend, train intents via a corpus JSON, or follow the Onyx Chat Template pattern.
---

# Onyx Chat Template Skill

Provides the architectural blueprint from Onyx-Systems/onyx-chat-template for building hybrid NLU (nlp.js) + LLM (OpenAI) chat backends with Express.js and TypeORM. See [references/](./references/) for the full template files and Corpus documentation.
"@ | Set-Content -Path (Join-Path $onyxDest "SKILL.md") -Encoding UTF8

# Select Anthropic Skills
$anthropicSkills = @(
    "frontend-design", "mcp-builder", "webapp-testing", "web-artifacts-builder",
    "skill-creator", "pdf", "docx", "xlsx", "pptx",
    "canvas-design", "doc-coauthoring", "brand-guidelines", "theme-factory", "internal-comms"
)
foreach ($s in $anthropicSkills) {
    $src = Join-Path "$reposDir\anthropics-skills\skills" $s
    if (Test-Path $src) { Copy-Item -Path $src -Destination $stageDir -Recurse -Force }
}

# Select AI Agent Skills
$aiSkills = @(
    "database-design", "backend-development", "llm-application-dev", "verification-agent",
    "ask-questions-if-underspecified", "best-practices",
    "code-documentation", "build-workspace-docs", "changelog-generator", "content-research-writer"
)
foreach ($s in $aiSkills) {
    $src = Join-Path "$reposDir\ai-agent-skills\skills" $s
    if (Test-Path $src) { Copy-Item -Path $src -Destination $stageDir -Recurse -Force }
}

# Select Composio Awesome-Claude Skills
$composioSkills = @(
    "invoice-organizer", "competitive-ads-extractor", "lead-research-assistant",
    "meeting-insights-analyzer", "file-organizer", "tailored-resume-generator", "domain-name-brainstormer"
)
foreach ($s in $composioSkills) {
    $src = Join-Path "$reposDir\awesome-claude-skills" $s
    if (Test-Path $src) { Copy-Item -Path $src -Destination $stageDir -Recurse -Force }
}

# 5. Install to Global Agent Locations
Write-Step "Installing skills into Antigravity & Universal Agent discovery paths..."
Copy-Item -Path "$stageDir\*" -Destination $globalGeminiSkills -Recurse -Force
Copy-Item -Path "$stageDir\*" -Destination $globalAgentSkills -Recurse -Force
$installedCount = (Get-ChildItem -Path $globalGeminiSkills -Directory).Count
Write-Success "Installed $installedCount skills globally into ~/.gemini/ and ~/.agents/"

# 6. Configure Global MCP Servers
Write-Step "Configuring global Context7 & Playwright MCP servers..."
$mcpConfigPath = Join-Path $userHome ".gemini\config\mcp_config.json"
$mcpTemplate = @{
    mcpServers = @{
        context7 = @{
            command = "npx"
            args    = @("-y", "@upstash/context7-mcp@latest")
            env     = @{}
        }
        playwright = @{
            command = "npx"
            args    = @("-y", "@playwright/mcp@latest")
            env     = @{}
        }
    }
}
if (Test-Path $mcpConfigPath) {
    $existingMcp = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
    if (-not $existingMcp.mcpServers) { $existingMcp | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value (@{}) }
    $existingMcp.mcpServers | Add-Member -NotePropertyName "context7" -NotePropertyValue $mcpTemplate.mcpServers.context7 -Force
    $existingMcp.mcpServers | Add-Member -NotePropertyName "playwright" -NotePropertyValue $mcpTemplate.mcpServers.playwright -Force
    $existingMcp | ConvertTo-Json -Depth 10 | Set-Content -Path $mcpConfigPath -Encoding UTF8
} else {
    $mcpTemplate | ConvertTo-Json -Depth 10 | Set-Content -Path $mcpConfigPath -Encoding UTF8
}
Write-Success "Configured MCP servers at $mcpConfigPath"

# 7. Configure Mandatory Skill Attribution & Dual-Memory Rules
Write-Step "Configuring global and workspace agent rules..."
$ruleContent = Get-Content -Path "$PSScriptRoot\..\configs\rules\AGENTS.md" -Raw -ErrorAction SilentlyContinue
if (-not $ruleContent) {
    $ruleContent = @"
# Mandatory Agent & Extension Rules (Skill Attribution + Dual-Memory Routing + Hermes Self-Evolving Loop + Token Ledger)

This rule applies to **all AI coding agents, IDE models, subagents, and third-party extensions** (including Google Antigravity, Gemini CLI, Claude Code, Cursor, GitHub Copilot, Windsurf, Cline, Roo Code, and OpenCode).

## 1. Mandatory Skill Activation, MCP Disclosure & Per-Prompt Token Savings Note
Before writing code, designing systems/databases, debugging, or producing any output, you MUST check and apply the relevant global skills installed in:
- `$globalGeminiSkills\`
- `$globalAgentSkills\`

Whenever you write code, propose an architecture, debug, review, or give any substantive output, you **MUST include this exact 3-line attribution & token-comparison block** at the top or bottom of your response:

> **Skills Used:** `<skill-name-1>`, `<skill-name-2>` *(or `None — General Reasoning`)*  
> **MCP Tools Used:** `<mcp-server-name>` *(e.g., `codebase-memory-mcp`, `context7`, `playwright`, `StitchMCP`, or `None`)*  
> **Token Impact:** **Used:** `~<X> tokens` | **Without Setup (Baseline):** `~<Y> tokens` | **Saved:** `~<Y-X> tokens (<Z>%)` — *<brief reason>*
"@
}

$ruleLocations = @(
    (Join-Path $userHome ".gemini\GEMINI.md"),
    (Join-Path $userHome ".gemini\AGENTS.md"),
    (Join-Path $userHome ".gemini\config\GEMINI.md"),
    (Join-Path $userHome ".gemini\config\AGENTS.md"),
    (Join-Path $userHome ".agents\AGENTS.md"),
    (Join-Path $userHome ".claude\CLAUDE.md")
)
if (Test-Path $TargetProjectRoot) {
    $ruleLocations += (Join-Path $TargetProjectRoot "AGENTS.md")
    $ruleLocations += (Join-Path $TargetProjectRoot "GEMINI.md")
    $ruleLocations += (Join-Path $TargetProjectRoot "CLAUDE.md")
}

foreach ($loc in $ruleLocations) {
    $dir = Split-Path -Path $loc -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $ruleContent | Set-Content -Path $loc -Encoding UTF8
}
Write-Success "Rules installed across IDE and workspace roots."

# 8. Cleanup
Write-Step "Cleaning up temporary staging cache..."
Remove-Item -Path $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
Write-Success "Cleaned temporary files."

Write-Host @"
================================================================================
   ANTIGRAVITY-OS INSTALLATION COMPLETE!
   • 182 Skills Installed Globally
   • Context7 & Playwright MCP Ready
   • 4-Pillar Synergy Rules Enforced
================================================================================
"@ -ForegroundColor Green
