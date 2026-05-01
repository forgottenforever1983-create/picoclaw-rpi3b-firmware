#!/bin/bash
set -e

echo "========================================="
echo "Configuring Network (WiFi + Static IP)"
echo "========================================="

WIFI_SSID="Athena-Da-God1"
WIFI_PASSWORD="12345678"
STATIC_IP="192.168.1.100"
GATEWAY="192.168.1.1"
DNS="8.8.8.8,8.8.4.4"

# Configure WiFi (wpa-supplicant)
echo "Configuring WiFi..."
cat > /etc/wpa_supplicant/wpa_supplicant.conf << EOF
ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
    ssid="$WIFI_SSID"
    psk="$WIFI_PASSWORD"
    key_mgmt=WPA-PSK
}
EOF

chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf

# Configure static IP (dhcpcd)
echo "Configuring static IP..."
cat >> /etc/dhcpcd.conf << 'EOF'

# PicoClaw static IP configuration
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8 8.8.4.4

interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8 8.8.4.4
EOF

# Set hostname
echo "picoclaw-rpi3b" > /etc/hostname
echo "127.0.1.1       picoclaw-rpi3b" >> /etc/hosts

# Enable WiFi and networking on boot
ln -sf /lib/systemd/system/wpa_supplicant.service /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
ln -sf /lib/systemd/system/dhcpcd.service /etc/systemd/system/multi-user.target.wants/dhcpcd.service

# Create network info file for user reference
cat > /etc/picoclaw/network-info.txt << EOF
=========================================
Network Configuration
=========================================

WiFi SSID: $WIFI_SSID
WiFi Password: $WIFI_PASSWORD

Static IP: $STATIC_IP
Gateway: $GATEWAY
DNS: $DNS

Hostname: picoclaw-rpi3b

To change WiFi:
  sudo raspi-config
  -> System Options -> Wireless LAN

To change static IP:
  sudo nano /etc/dhcpcd.conf
  -> Edit the interface settings

To scan for WiFi networks:
  sudo wpa_cli scan
  sudo wpa_cli scan_results
=========================================
EOF

chmod 644 /etc/picoclaw/network-info.txt

echo "Network configured successfully!"
echo "========================================="
echo "WiFi: $WIFI_SSID"
echo "IP: $STATIC_IP"
echo "========================================="