#!/bin/bash
#
# PicoClaw Raspberry Pi 3B+ Firmware Build Script
# ==============================================
#
# This script builds a custom Raspberry Pi OS image with
# PicoClaw AI assistant pre-installed and pre-configured.
#
# Requirements:
# - Debian Bookworm/Trixie arm64 (native Raspberry Pi 4/5 or VM)
# - ~40GB disk space
# - 4-8 hours for first build
#
# Usage:
#   ./build.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================="
echo "PicoClaw Raspberry Pi 3B+ Firmware Builder"
echo "========================================="
echo ""

# Check for required tools
check_dependencies() {
    echo "Checking dependencies..."
    
    # Check if running on supported system
    if [[ ! -f /etc/os-release ]]; then
        echo "ERROR: Cannot detect OS"
        exit 1
    fi
    
    source /etc/os-release
    if [[ "$ID" != "debian" && "$ID" != "raspbian" && "$ID" != "ubuntu" ]]; then
        echo "WARNING: This script is designed for Debian-based systems"
    fi
    
    # Check for required commands
    for cmd in git make; do
        if ! command -v $cmd &> /dev/null; then
            echo "ERROR: $cmd is required but not installed"
            exit 1
        fi
    done
    
    echo "Dependencies OK"
}

# Clone rpi-image-gen if not present
setup_rpi_image_gen() {
    echo ""
    echo "Setting up rpi-image-gen..."
    
    if [ -d "$SCRIPT_DIR/rpi-image-gen" ]; then
        echo "rpi-image-gen already exists, pulling updates..."
        cd "$SCRIPT_DIR/rpi-image-gen"
        git pull || true
    else
        echo "Cloning rpi-image-gen..."
        git clone https://github.com/raspberrypi/rpi-image-gen.git "$SCRIPT_DIR/rpi-image-gen"
    fi
    
    cd "$SCRIPT_DIR"
}

# Install build dependencies
install_deps() {
    echo ""
    echo "Installing build dependencies..."
    echo "This may require sudo..."
    
    if [ -f "$SCRIPT_DIR/rpi-image-gen/install_deps.sh" ]; then
        sudo "$SCRIPT_DIR/rpi-image-gen/install_deps.sh"
    else
        echo "ERROR: install_deps.sh not found"
        exit 1
    fi
}

# Copy custom layer to rpi-image-gen
setup_layer() {
    echo ""
    echo "Setting up custom PicoClaw layer..."
    
    # Copy layer to rpi-image-gen
    cp -r "$SCRIPT_DIR/layer" "$SCRIPT_DIR/rpi-image-gen/layer/custom-picoclaw"
    
    # Copy config
    cp "$SCRIPT_DIR/config/picoclaw-rpi3b.yaml" "$SCRIPT_DIR/rpi-image-gen/config/"
    
    echo "Layer setup complete"
}

# Build the image
build_image() {
    echo ""
    echo "========================================="
    echo "Starting image build..."
    echo "This will take several hours."
    echo "========================================="
    echo ""
    
    cd "$SCRIPT_DIR/rpi-image-gen"
    
    # Run the build
    ./rpi-image-gen build -c config/picoclaw-rpi3b.yaml
    
    cd "$SCRIPT_DIR"
}

# Locate and report the output
report_output() {
    echo ""
    echo "========================================="
    echo "Build Complete!"
    echo "========================================="
    echo ""
    
    # Find the output image
    WORK_DIR="$SCRIPT_DIR/rpi-image-gen/work"
    
    if [ -d "$WORK_DIR" ]; then
        echo "Output image location:"
        find "$WORK_DIR" -name "*.img" -type f 2>/dev/null | while read img; do
            SIZE=$(du -h "$img" | cut -f1)
            echo "  $img ($SIZE)"
        done
    else
        echo "ERROR: Work directory not found"
        exit 1
    fi
    
    echo ""
    echo "To flash to SD card:"
    echo "  sudo rpi-imager --cli <image-file> /dev/mmcblk0"
    echo ""
    echo "Or use dd:"
    echo "  sudo dd if=<image-file> of=/dev/mmcblk0 bs=4M status=progress"
    echo ""
    echo "========================================="
}

# Main execution
main() {
    check_dependencies
    setup_rpi_image_gen
    install_deps
    setup_layer
    build_image
    report_output
}

# Run main function
main "$@"