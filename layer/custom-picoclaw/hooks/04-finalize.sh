#!/bin/bash
set -e

echo "========================================="
echo "Finalizing PicoClaw Firmware Setup"
echo "========================================="

# Create pi user home structure
mkdir -p /home/pi
chown -R pi:pi /home/pi

# Ensure PicoClaw is executable
chmod +x /usr/local/bin/picoclaw 2>/dev/null || true

# Create convenience scripts
echo "Creating convenience scripts..."

# Quick start script
cat > /usr/local/bin/picoclaw-start << 'EOF'
#!/bin/bash
echo "Starting PicoClaw..."
echo "========================================="
echo "PicoClaw Firmware v1.0"
echo "Raspberry Pi 3B+ Edition"
echo "========================================="
echo ""
echo "Available commands:"
echo "  picoclaw           - Interactive mode"
echo "  picoclaw agent -m 'prompt'  - Single query"
echo "  picoclaw --help    - Help"
echo "  picoclaw config    - Edit config"
echo ""
echo "Network Info:"
echo "  IP: 192.168.1.100"
echo "  SSH: ssh pi@192.168.1.100"
echo ""
echo "Workspace: /home/pi/picoclaw-workspace"
echo "========================================="
picoclaw
EOF

chmod +x /usr/local/bin/picoclaw-start

# Create systemd service for auto-start
cat > /etc/systemd/system/picoclaw.service << 'EOF'
[Unit]
Description=PicoClaw AI Assistant
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/picoclaw-workspace
ExecStart=/usr/local/bin/picoclaw
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable service (user can start later with: systemctl enable picoclaw)
# Don't enable by default to save resources

# Create welcome message
cat > /etc/motd << 'EOF'
========================================
  PicoClaw Firmware v1.0
  Raspberry Pi 3B+ Edition
========================================

Quick Start:
  picoclaw-start     - Start interactive session
  picoclaw agent -m 'Hello' - Quick test

Network:
  IP Address: 192.168.1.100
  SSH: ssh pi@192.168.1.100
  Password: raspberry

Documentation:
  /home/pi/picoclaw-workspace/AGENTS.md
  /etc/picoclaw/config.json
  /etc/picoclaw/network-info.txt

========================================
EOF

# Create first-run script (runs on first boot)
cat > /root/first-run.sh << 'EOF'
#!/bin/bash
echo "Running first-time setup..."

# Expand filesystem
raspi-config --expand-rootfs 2>/dev/null || true

# Set timezone
timedatectl set-timezone America/New_York 2>/dev/null || true

# Enable SSH
touch /boot/ssh 2>/dev/null || true

# Final welcome
echo ""
echo "========================================="
echo "  PicoClaw is ready!"
echo "========================================="
echo ""
echo "Access via:"
echo "  - SSH: ssh pi@192.168.1.100"
echo "  - Web: http://192.168.1.100:8080"
echo ""
echo "Default password: raspberry"
echo "========================================="
EOF

chmod +x /root/first-run.sh

echo "Finalization complete!"
echo "========================================="