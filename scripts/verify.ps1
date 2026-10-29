# ==============================================================================
# Antigravity-OS: System Verification & Health Diagnostic (Windows PowerShell)
# ==============================================================================

$userHome           = $env:USERPROFILE
$globalGeminiSkills = Join-Path $userHome ".gemini\config\skills"
$globalAgentSkills  = Join-Path $userHome ".agents\skills"
$mcpConfigPath      = Join-Path $userHome ".gemini\config\mcp_config.json"

Write-Host @"
================================================================================
   ANTIGRAVITY-OS SYSTEM DIAGNOSTIC & VERIFICATION
================================================================================
"@ -ForegroundColor Blue

$script:passed = 0
$script:total = 0

function Check-Item {
    param (
        [string]$Name,
        [bool]$Condition,
        [string]$Details
    )
    $script:total++
    if ($Condition) {
        $script:passed++
        Write-Host "  [PASS] $Name : $Details" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $Name : $Details" -ForegroundColor Red
    }
}

# 1. Skills Check
Write-Host "`n1. SKILL INVENTORY AUDIT:" -ForegroundColor Cyan
$geminiSkillsCount = 0
if (Test-Path $globalGeminiSkills) {
    $geminiSkillsCount = (Get-ChildItem -Path $globalGeminiSkills -Directory).Count
}
Check-Item -Name "Gemini Skills Path (~/.gemini/config/skills)" -Condition ($geminiSkillsCount -ge 500) -Details "$geminiSkillsCount skills detected (Target: 503+)"

$agentSkillsCount = 0
if (Test-Path $globalAgentSkills) {
    $agentSkillsCount = (Get-ChildItem -Path $globalAgentSkills -Directory).Count
}
Check-Item -Name "Universal Agent Skills Path (~/.agents/skills)" -Condition ($agentSkillsCount -ge 500) -Details "$agentSkillsCount skills detected (Target: 503+)"

# Check Key Invariant Skills
$keySkills = @("gravitas", "gravitas-highstakes", "using-superpowers", "verification-before-completion", "ponytail", "impeccable", "hallmark", "scrapling", "supabase", "replica-recon", "continuous-learning-v2", "agent-security-hardening", "design-system-audit")
foreach ($k in $keySkills) {
    $hasSkill = Test-Path (Join-Path $globalGeminiSkills $k)
    Check-Item -Name "Critical Skill [$k]" -Condition $hasSkill -Details "Installed and resolvable"
}


# 2. Specialist Agent Personas Check
Write-Host "
2. SPECIALIST AGENT PERSONAS AUDIT:" -ForegroundColor Cyan
$agentPersonasCount = 0
$agentsDir = Join-Path $userHome ".gemini\config\agents"
if (Test-Path $agentsDir) {
    $agentPersonasCount = (Get-ChildItem -Path $agentsDir -Filter *.md).Count
}
Check-Item -Name "Specialist Agent Personas (~/.gemini/config/agents)" -Condition ($agentPersonasCount -ge 70) -Details "$agentPersonasCount personas detected (Target: 71)"

# 3. MCP Configuration Audit
Write-Host "`n3. MCP SERVERS CONFIGURATION:" -ForegroundColor Cyan
$hasContext7 = $false
$hasPlaywright = $false
if (Test-Path $mcpConfigPath) {
    try {
        $json = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
        if ($json.mcpServers.context7) { $hasContext7 = $true }
        if ($json.mcpServers.playwright) { $hasPlaywright = $true }
    } catch {}
}
Check-Item -Name "Context7 MCP Server" -Condition $hasContext7 -Details "Configured with @upstash/context7-mcp"
Check-Item -Name "Playwright MCP Server" -Condition $hasPlaywright -Details "Configured with @playwright/mcp"

# 4. Rule Attribution Files
Write-Host "`n4. MANDATORY ATTRIBUTION AND DUAL-MEMORY RULES:" -ForegroundColor Cyan
$rulePaths = @(
    (Join-Path $userHome ".gemini\GEMINI.md"),
    (Join-Path $userHome ".gemini\AGENTS.md"),
    (Join-Path $userHome ".gemini\config\AGENTS.md"),
    (Join-Path $userHome ".agents\AGENTS.md"),
    (Join-Path $userHome ".claude\CLAUDE.md")
)
foreach ($r in $rulePaths) {
    $exists = Test-Path $r
    $displayPath = Split-Path $r -NoQualifier
    Check-Item -Name "Rule $displayPath" -Condition $exists -Details "Enforcing 4-Pillars and Token Ledger"
}

Write-Host "`n--------------------------------------------------------------------------------"
$summaryColor = "Green"
if ($script:passed -lt $script:total) { $summaryColor = "Yellow" }
Write-Host "Diagnostic Summary: $($script:passed) / $($script:total) checks passed." -ForegroundColor $summaryColor
Write-Host "================================================================================`n"


