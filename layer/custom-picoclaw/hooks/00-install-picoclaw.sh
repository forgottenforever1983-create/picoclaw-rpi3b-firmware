#!/bin/bash
set -e

echo "========================================="
echo "Installing PicoClaw AI Assistant"
echo "========================================="

# Clone PicoClaw repository
cd /tmp
echo "Cloning PicoClaw repository..."
git clone --depth 1 https://github.com/sipeed/picoclaw.git
cd picoclaw

# Install Go dependencies
echo "Installing dependencies..."
make deps || echo "Dependencies already installed or not required"

# Build for ARM64 (Raspberry Pi 3B+)
echo "Building PicoClaw for ARM64..."
make build-linux-arm64

# Install to system
echo "Installing PicoClaw..."
install -m 755 build/picoclaw-linux-arm64 /usr/local/bin/picoclaw

# Verify installation
picoclaw --version

echo "PicoClaw installed successfully!"
echo "========================================="