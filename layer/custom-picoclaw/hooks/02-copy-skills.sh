#!/bin/bash
set -e

echo "========================================="
echo "Installing Custom Skills & Agents"
echo "========================================="

WORKSPACE="/home/pi/picoclaw-workspace"

# Create skills directory
mkdir -p "$WORKSPACE/skills"

# Copy skills from build machine (if available)
# These will be embedded in the image during build
SKILLS_DIR="$(dirname "$(dirname "$(dirname "$(dirname "$0"))")")/files/skills"
if [ -d "$SKILLS_DIR" ]; then
    echo "Copying custom skills..."
    cp -r "$SKILLS_DIR/"* "$WORKSPACE/skills/" 2>/dev/null || echo "No skills to copy"
fi

# Create default skills that will work on RPI
echo "Creating default skills..."

# Profile Management Skill
mkdir -p "$WORKSPACE/skills/profile-management"
cat > "$WORKSPACE/skills/profile-management/SKILL.md" << 'EOF'
---
name: profile-management
description: Manage multiple isolated profile configurations
---

# Profile Management Skill

Manage multiple isolated profiles for different projects or use cases.

## Usage
- Create new profile: use the profile in workspace settings
- Switch profiles: update .picoclaw/profile file
- Each profile has independent memory, sessions, and config
EOF

# Memory Management Skill
mkdir -p "$WORKSPACE/skills/memory-management"
cat > "$WORKSPACE/skills/memory-management/SKILL.md" << 'EOF'
---
name: memory-management
description: Persist context across sessions
---

# Memory Management Skill

Remember user preferences, project context, and learned lessons.

## Memory Types
- USER_PROFILE: User preferences and settings
- PROJECT: Project-specific context
- LESSON: Learned lessons and mistakes to avoid

## Usage
- Store important info in AGENTS.md
- Reference previous sessions for context
- Update memory based on user feedback
EOF

# Kanban Orchestration Skill  
mkdir -p "$WORKSPACE/skills/kanban-orchestration"
cat > "$WORKSPACE/skills/kanban-orchestration/SKILL.md" << 'EOF'
---
name: kanban-orchestration
description: Multi-agent task orchestration with specialist roles
---

# Kanban Orchestration Skill

Decompose complex tasks across specialist agents.

## Specialist Roles
- explorer: Fast codebase exploration
- general: General-purpose coding
- writer: Documentation
- reviewer: Code review

## Usage
1. Use Plan mode to analyze before implementing
2. Break tasks into smaller pieces
3. Use todowrite to track dependencies
4. Switch to Build mode to execute
EOF

# Cron Automation Skill
mkdir -p "$WORKSPACE/skills/cron-automation"
cat > "$WORKSPACE/skills/cron-automation/SKILL.md" << 'EOF'
---
name: cron-automation
description: Schedule and manage background tasks
---

# Cron Automation Skill

Schedule recurring tasks using system cron.

## Usage
- Create scripts in ~/scripts/
- Add to crontab with `crontab -e`
- Common schedules: 30m, 2h, 1d, 0 9 * * *

## Examples
- 0 9 * * * - Daily at 9am
- */30 * * * * - Every 30 minutes
- 0 * * * * - Every hour
EOF

# Webhook Automation Skill
mkdir -p "$WORKSPACE/skills/webhook-automation"
cat > "$WORKSPACE/skills/webhook-automation/SKILL.md" << 'EOF'
---
name: webhook-automation
description: Event-driven HTTP notifications
---

# Webhook Automation Skill

Send notifications via HTTP webhooks.

## Usage
Use curl to trigger webhooks:
```bash
curl -X POST https://hooks.slack.com/services/XXX \
  -H "Content-Type: application/json" \
  -d '{"text":"Task completed!"}'
```

## Common Events
- task.completed
- session.ended
- error.occurred
EOF

# Create custom agents
mkdir -p "$WORKSPACE/agents"

# Orchestrator Agent
cat > "$WORKSPACE/agents/orchestrator.md" << 'EOF'
---
name: orchestrator
description: Multi-agent task decomposition expert
mode: subagent
permission:
  edit: deny
  todowrite: allow
---

# Orchestrator Agent

Decompose complex tasks into subtasks and delegate to specialists.

## Available Specialists
- @explorer - Find files, understand code
- @general - Implement features
- @writer - Write docs
- @reviewer - Review code
EOF

# Security Reviewer Agent
cat > "$WORKSPACE/agents/security-reviewer.md" << 'EOF'
---
name: security-reviewer
description: Security-focused code review
mode: subagent
permission:
  edit: deny
  bash: deny
---

# Security Reviewer Agent

Find security vulnerabilities in code.

## Focus Areas
- SQL injection, XSS, command injection
- Authentication/authorization issues
- Hardcoded secrets
- Dependency vulnerabilities
EOF

# Docs Writer Agent
cat > "$WORKSPACE/agents/docs-writer.md" << 'EOF'
---
name: docs-writer
description: Technical documentation specialist
mode: subagent
permission:
  bash: deny
---

# Docs Writer Agent

Create clear, comprehensive documentation.

## Output Types
- README files
- API documentation
- Code comments
- Architecture docs
EOF

# Set permissions
chown -R pi:pi "$WORKSPACE"

echo "Custom skills & agents installed!"
echo "========================================="