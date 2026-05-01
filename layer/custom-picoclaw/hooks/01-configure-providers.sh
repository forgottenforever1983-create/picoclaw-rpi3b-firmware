#!/bin/bash
set -e

echo "========================================="
echo "Configuring LLM Providers"
echo "========================================="

# Create PicoClaw config directory
mkdir -p /etc/picoclaw
mkdir -p /home/pi/.config/picoclaw
mkdir -p /home/pi/picoclaw-workspace

# Create main config with all providers
cat > /etc/picoclaw/config.json << 'EOF'
{
  "model_list": [
    {
      "model_name": "default",
      "model": "openrouter/tencent/hy3-preview:free",
      "provider": "openrouter",
      "api_key": "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"
    },
    {
      "model_name": "haiku",
      "model": "openrouter/anthropic/claude-haiku-4-20250514",
      "provider": "openrouter",
      "api_key": "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"
    },
    {
      "model_name": "sonnet",
      "model": "openrouter/anthropic/claude-sonnet-4-20250514",
      "provider": "openrouter",
      "api_key": "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"
    },
    {
      "model_name": "deepseek",
      "model": "openrouter/deepseek/deepseek-chat",
      "provider": "openrouter",
      "api_key": "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"
    },
    {
      "model_name": "gemma",
      "model": "openrouter/google/gemma-4-26b-a4b-it:free",
      "provider": "openrouter",
      "api_key": "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"
    }
  ],
  "agents": {
    "defaults": {
      "workspace": "/home/pi/picoclaw-workspace",
      "model_name": "default",
      "max_tokens": 8192,
      "temperature": 0.7,
      "max_steps": 100
    }
  },
  "server": {
    "enabled": true,
    "host": "0.0.0.0",
    "port": 8080
  },
  "logging": {
    "level": "info"
  }
}
EOF

# Copy to user directory
cp /etc/picoclaw/config.json /home/pi/.config/picoclaw/config.json

# Create workspace structure
mkdir -p /home/pi/picoclaw-workspace/{skills,agents, memory, sessions}
mkdir -p /home/pi/picoclaw-workspace/.opencode

# Create AGENTS.md for project context
cat > /home/pi/picoclaw-workspace/AGENTS.md << 'EOF'
# PicoClaw on Raspberry Pi 3B+

## Hardware
- Raspberry Pi 3B+ (ARM64, 1GB RAM)
- PicoClaw uses <10MB RAM

## Quick Commands
- `picoclaw` - Start interactive session
- `picoclaw agent -m "your prompt"` - Single query
- `picoclaw --help` - Show all options

## Available Models
- default: Tencent HY3 (fast, free)
- haiku: Claude Haiku (balanced)
- sonnet: Claude Sonnet (capable)
- deepseek: DeepSeek Chat
- gemma: Gemma 4 (free)

## Custom Skills
This workspace includes:
- profile-management
- memory-management
- kanban-orchestration
- cron-automation
- webhook-automation
EOF

chown -R pi:pi /home/pi/picoclaw-workspace
chown -R pi:pi /home/pi/.config

echo "LLM providers configured successfully!"
echo "========================================="