# PicoClaw Raspberry Pi 3B+ Custom Firmware

Custom Raspberry Pi OS image with PicoClaw AI assistant pre-installed and pre-configured.

## What's Included

### Hardware
- Raspberry Pi 3B+ (ARM64, 1GB RAM)
- PicoClaw uses <10MB RAM

### Pre-installed Software
- PicoClaw AI Assistant (latest from source)
- Go 1.21+ for development
- SSH server (enabled)
- Network utilities

### Pre-configured Providers
| Provider | Status | Model |
|----------|--------|-------|
| OpenRouter | ✅ Configured | Tencent HY3 (default), Claude Haiku, Sonnet, DeepSeek, Gemma |
| Anthropic | Ready | Add your API key |
| OpenAI | Ready | Add your API key |
| DeepSeek | Ready | Add your API key |
| Google | Ready | Add your API key |

### Custom Skills (Bundled)
- `profile-management` - Multiple profile support
- `memory-management` - Persistent context
- `kanban-orchestration` - Task decomposition
- `cron-automation` - Scheduled tasks
- `webhook-automation` - HTTP notifications

### Custom Agents (Bundled)
- `@orchestrator` - Multi-agent task routing
- `@security-reviewer` - Security analysis
- `@docs-writer` - Documentation generation

### Network Configuration
| Setting | Value |
|---------|-------|
| WiFi SSID | Athena-Da-God1 |
| WiFi Password | 12345678 |
| Static IP | 192.168.1.100 |
| Gateway | 192.168.1.1 |
| Hostname | picoclaw-rpi3b |

## Build Requirements

### System Requirements
- **OS**: Debian Bookworm/Trixie arm64 (native Raspberry Pi 4/5 or VM)
- **Disk Space**: ~40GB for build
- **Time**: 4-8 hours for first build (faster on subsequent builds)

### Using VM (Windows/Mac)
1. Install Debian arm64 in VM (or use UTM on Mac)
2. Ensure at least 50GB disk
3. Clone this repo and run build.sh

## Build Instructions

### Quick Start
```bash
# Clone the repository
git clone <this-repo>
cd rpi-picoclaw-firmware

# Run the build
chmod +x build.sh
./build.sh
```

### Manual Build
```bash
# Install rpi-image-gen
git clone https://github.com/raspberrypi/rpi-image-gen.git
cd rpi-image-gen
sudo ./install_deps.sh

# Copy our custom layer
cp -r ../layer/custom-picoclaw layer/
cp ../config/picoclaw-rpi3b.yaml config/

# Build
./rpi-image-gen build -c config/picoclaw-rpi3b.yaml
```

### Output Location
Built image will be in:
```
rpi-image-gen/work/image-deb12-arm64-picoclaw-rpi3b/deb12-arm64-picoclaw-rpi3b.img
```

## Flash to SD Card

### Using Raspberry Pi Imager (Recommended)
```bash
sudo rpi-imager --cli <image-file> /dev/mmcblk0
```

### Using dd
```bash
sudo dd if=<image-file> of=/dev/mmcblk0 bs=4M status=progress
```

### Device Name
- `/dev/mmcblk0` - SD card (Linux)
- May be `/dev/sdb` on some systems

## First Boot

### Default Credentials
- **Username**: `pi`
- **Password**: `raspberry`

### Access Options

#### SSH
```bash
ssh pi@192.168.1.100
```

#### PicoClaw
```bash
# After SSH in:
picoclaw

# Or run single command:
picoclaw agent -m "Hello from Raspberry Pi!"
```

#### Quick Start Script
```bash
picoclaw-start
```

## Configuration

### Edit PicoClaw Config
```bash
nano /etc/picoclaw/config.json
```

### Change WiFi
```bash
sudo raspi-config
# -> System Options -> Wireless LAN
```

### Change Static IP
```bash
sudo nano /etc/dhcpcd.conf
# Edit the interface settings
```

### Enable Auto-start
```bash
sudo systemctl enable picoclaw
sudo systemctl start picoclaw
```

## Troubleshooting

### Can't connect to WiFi
1. Check WiFi credentials: `sudo cat /etc/wpa_supplicant/wpa_supplicant.conf`
2. Scan networks: `sudo wpa_cli scan && sudo wpa_cli scan_results`
3. Restart networking: `sudo systemctl restart dhcpcd`

### Can't reach device
1. Check IP: `hostname -I`
2. Ping gateway: `ping 192.168.1.1`
3. Check cable/connection

### PicoClaw not working
1. Check version: `picoclaw --version`
2. Check config: `cat /etc/picoclaw/config.json`
3. Test API: `picoclaw agent -m "test"`

### API Key Issues
Edit `/etc/picoclaw/config.json` and update the `api_key` field for each provider.

## File Structure

```
rpi-picoclaw-firmware/
├── config/
│   └── picoclaw-rpi3b.yaml      # Build configuration
├── layer/
│   └── custom-picoclaw/
│       ├── layer.yaml           # Layer definition
│       └── hooks/
│           ├── 00-install-picoclaw.sh
│           ├── 01-configure-providers.sh
│           ├── 02-copy-skills.sh
│           ├── 03-network-setup.sh
│           └── 04-finalize.sh
├── build.sh                     # Build script
└── README.md                    # This file
```

## API Key

**Current OpenRouter API Key**: `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`

The image is pre-configured with this key. You can change it by editing `/etc/picoclaw/config.json`.

## Support

- PicoClaw Docs: https://docs.picoclaw.io
- rpi-image-gen: https://github.com/raspberrypi/rpi-image-gen
- Raspberry Pi Forums: https://forums.raspberrypi.com/

## License

MIT License - Customize and distribute as needed.