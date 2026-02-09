# PlatformIO Integration Guide

Feature F005: PlatformIO integration with ForgePCB provenance tracking

## Overview

This guide shows how to use **PlatformIO** with **ForgePCB** while maintaining mandatory provenance tracking.

**Hybrid Approach:**
- ✅ PlatformIO for builds (convenient, great IDE support)
- ✅ ForgePCB scripts for flashing (provenance enforcement)
- ✅ Best of both worlds

---

## Quick Start

### 1. Install PlatformIO

```bash
# Via pip
pip install platformio

# Or via VSCode extension
# Install "PlatformIO IDE" from VSCode marketplace
```

### 2. Create PlatformIO Project

```bash
mkdir my-forgepcb-project
cd my-forgepcb-project
pio project init --board esp32-s3-devkitc-1
```

### 3. Copy Example platformio.ini

```bash
cp /path/to/ForgePCB/firmware/examples/platformio.ini platformio.ini
```

### 4. Adjust Paths

Edit `platformio.ini` and update the path to ForgePCB flash scripts:

```ini
[env:esp32s3]
upload_command = /absolute/path/to/ForgePCB/firmware/tools/flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)" --port /dev/forgepcb-esp32s3
```

### 5. Build and Flash

```bash
# Build only
pio run

# Build + flash (with provenance!)
pio run --target upload
```

---

## How It Works

### Traditional PlatformIO Upload

```bash
pio run --target upload
# PlatformIO directly calls esptool.py
# No provenance tracking ❌
```

### ForgePCB-Enhanced Upload

```ini
[env:esp32s3]
upload_protocol = custom
upload_command = /path/to/flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)"
```

```bash
pio run --target upload
# 1. PlatformIO builds firmware
# 2. PlatformIO calls flash_esp32.sh (not esptool directly)
# 3. flash_esp32.sh enforces provenance ✅
# 4. Provenance record created with git commit ✅
```

**Result:** Convenience of PlatformIO + compliance with F005 frozen decisions!

---

## Configuration Examples

### ESP32-S3 (Arduino Framework)

```ini
[env:esp32s3]
platform = espressif32
board = esp32-s3-devkitc-1
framework = arduino
monitor_speed = 115200
monitor_port = /dev/forgepcb-esp32s3

upload_protocol = custom
upload_command = /path/to/ForgePCB/firmware/tools/flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)" --port /dev/forgepcb-esp32s3
```

### ESP32-S3 (ESP-IDF Framework)

```ini
[env:esp32s3-idf]
platform = espressif32
board = esp32-s3-devkitc-1
framework = espidf
monitor_speed = 115200
monitor_port = /dev/forgepcb-esp32s3

upload_protocol = custom
upload_command = /path/to/ForgePCB/firmware/tools/flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)" --port /dev/forgepcb-esp32s3
```

### RP2040 Pico (Arduino Framework)

```ini
[env:rp2040]
platform = raspberrypi
board = pico
framework = arduino
monitor_speed = 115200
monitor_port = /dev/forgepcb-rp2040

upload_protocol = custom
upload_command = /path/to/ForgePCB/firmware/tools/flash_rp2040.sh $SOURCE --build-id "$(git rev-parse --short HEAD)"
```

---

## Build ID Strategies

### Option 1: Short Commit Hash

```ini
upload_command = .../flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)"
```

Example: `a1b2c3d`

### Option 2: Full Commit Hash

```ini
upload_command = .../flash_esp32.sh $SOURCE --build-id "$(git rev-parse HEAD)"
```

Example: `a1b2c3d4e5f6789012345678901234567890abcd`

### Option 3: Commit + Branch + Timestamp (Recommended)

```ini
upload_command = .../flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD) ($(git branch --show-current)@$(date -u +%Y-%m-%dT%H:%M:%SZ))" --port /dev/forgepcb-esp32s3
```

Example: `a1b2c3d (main@2026-02-09T15:30:00Z)`

### Option 4: Git Describe (Version Tags)

```ini
upload_command = .../flash_esp32.sh $SOURCE --build-id "$(git describe --always --dirty --tags)" --port /dev/forgepcb-esp32s3
```

Example: `v1.0.0-5-ga1b2c3d` or `v1.0.0`

---

## Workflow Examples

### Example 1: Develop → Build → Flash → Monitor

```bash
# 1. Edit code in VSCode (with PlatformIO IDE extension)

# 2. Build
pio run

# 3. Flash (calls ForgePCB script with provenance)
pio run --target upload

# 4. Monitor serial
pio device monitor
# Or use ForgePCB serial capture:
# /path/to/ForgePCB/firmware/tools/serial_capture.sh --target esp32s3
```

### Example 2: Fast Iteration (Dev Build)

Create a dev environment for faster uploads:

```ini
[env:esp32s3-dev]
extends = env:esp32s3
upload_command = /path/to/flash_esp32.sh $SOURCE --build-id "$(git rev-parse --short HEAD)-dev" --baud 460800 --no-verify
```

```bash
pio run --environment esp32s3-dev --target upload
# Faster baud, skip verification (use for rapid testing)
```

### Example 3: Multi-Target Project

```ini
[platformio]
default_envs = esp32s3, rp2040

[env:esp32s3]
# ESP32-S3 config...

[env:rp2040]
# RP2040 config...
```

```bash
# Flash both targets
pio run --target upload
# (Flashes all default envs)

# Flash specific target
pio run --environment esp32s3 --target upload
```

---

## Serial Monitoring

### Option 1: PlatformIO Monitor

```bash
pio device monitor
```

**Pros:**
- Integrated with PlatformIO
- Auto-reconnects on reset

**Cons:**
- No timestamps
- No provenance linking
- No log files

### Option 2: ForgePCB Serial Capture (Recommended)

```bash
/path/to/ForgePCB/firmware/tools/serial_capture.sh --target esp32s3
```

**Pros:**
- ✅ Timestamped output (ISO 8601)
- ✅ Log files automatically saved
- ✅ Linked to provenance records
- ✅ Retained for 30 days

**Cons:**
- Separate command (not integrated with `pio`)

### Hybrid Approach

Use PlatformIO for quick monitoring during development, ForgePCB serial capture for important debug sessions:

```bash
# Quick check
pio device monitor

# Important debug session (with logs and provenance)
/path/to/ForgePCB/firmware/tools/serial_capture.sh --target esp32s3
```

---

## VSCode Integration

### 1. Install PlatformIO IDE Extension

In VSCode:
1. Go to Extensions (Ctrl+Shift+X)
2. Search "PlatformIO IDE"
3. Install

### 2. Open PlatformIO Project

```bash
cd my-forgepcb-project
code .
```

VSCode will detect `platformio.ini` and load PlatformIO.

### 3. Use PlatformIO Toolbar

- **Build**: Click checkmark icon (or `Ctrl+Alt+B`)
- **Upload**: Click arrow icon (or `Ctrl+Alt+U`)
  - This calls ForgePCB flash script with provenance!
- **Monitor**: Click plug icon (or `Ctrl+Alt+S`)

---

## Troubleshooting

### Upload command not found

**Error:**
```
/bin/sh: /path/to/flash_esp32.sh: No such file or directory
```

**Fix:**
- Use absolute path to flash script
- Verify path exists: `ls /path/to/ForgePCB/firmware/tools/flash_esp32.sh`

### Permission denied on flash script

**Error:**
```
/bin/sh: /path/to/flash_esp32.sh: Permission denied
```

**Fix:**
```bash
chmod +x /path/to/ForgePCB/firmware/tools/*.sh
```

### Git command not found in upload_command

**Error:**
```
git: command not found
```

**Fix:**
- Ensure git is installed: `sudo apt install git`
- Or use static build ID: `--build-id "manual-v1.0"`

### Device not found: /dev/forgepcb-esp32s3

**Fix:**
1. Install udev rules:
   ```bash
   sudo cp /path/to/ForgePCB/firmware/configs/udev/99-forgepcb.rules /etc/udev/rules.d/
   sudo udevadm control --reload-rules && sudo udevadm trigger
   ```
2. Verify symlink: `ls -l /dev/forgepcb-*`

---

## Advanced: Custom PlatformIO Tasks

You can add custom tasks to `platformio.ini` for common workflows:

```ini
[env:esp32s3]
# ... (existing config)

# Custom target: flash + serial capture
extra_scripts = post:custom_tasks.py
```

Create `custom_tasks.py`:

```python
Import("env")

def flash_and_monitor(source, target, env):
    import subprocess
    # Flash
    subprocess.run([
        "/path/to/ForgePCB/firmware/tools/flash_esp32.sh",
        str(source[0]),
        "--build-id", "$(git rev-parse --short HEAD)",
        "--port", "/dev/forgepcb-esp32s3"
    ])
    # Serial capture
    subprocess.run([
        "/path/to/ForgePCB/firmware/tools/serial_capture.sh",
        "--target", "esp32s3"
    ])

env.AddCustomTarget("flash-monitor", None, flash_and_monitor)
```

Usage:
```bash
pio run --target flash-monitor
```

---

## Comparison: PlatformIO vs. Bare Scripts

| Feature | PlatformIO | Bare Scripts | Hybrid (Recommended) |
|---------|------------|--------------|----------------------|
| Build System | ✅ Integrated | ❌ Manual | ✅ Integrated |
| IDE Support | ✅ VSCode, CLion | ❌ None | ✅ VSCode, CLion |
| Provenance Tracking | ❌ No | ✅ Yes | ✅ Yes |
| Explicit Target | ❌ Auto-detect | ✅ Explicit | ✅ Explicit |
| Event Logging | ❌ No | ✅ Yes | ✅ Yes |
| Fault Detection | ❌ No | ✅ Yes | ✅ Yes |
| Library Management | ✅ Yes | ❌ Manual | ✅ Yes |
| Flexibility | ⚠️ PIO-only | ✅ Any build system | ✅ Any build system |

**Winner:** Hybrid approach (PlatformIO for builds, ForgePCB scripts for flash)

---

## Best Practices

1. **Always use git-based build IDs**: Traceable back to source
   ```ini
   --build-id "$(git rev-parse --short HEAD)"
   ```

2. **Use absolute paths in platformio.ini**: Avoid path resolution issues

3. **Verify provenance after upload**: Check that provenance was recorded
   ```bash
   cat /var/log/forgepcb/provenance/latest-esp32s3.json
   ```

4. **Use ForgePCB serial capture for important sessions**: Timestamps and logs matter

5. **Create dev and release environments**: Fast iteration vs. verified builds
   ```ini
   [env:esp32s3-dev]  # Fast, skip verification
   [env:esp32s3]      # Verified, with full provenance
   ```

---

## Integration with ForgeOS

When using PlatformIO projects with ForgeOS:

1. **ForgeOS manages PlatformIO projects**: Runs `pio run` to build
2. **ForgeOS calls ForgePCB flash scripts**: Uses flash tools for deployment
3. **Provenance stored centrally**: ForgeOS aggregates provenance records

**Example ForgeOS workflow:**
```bash
# ForgeOS build step
forgeosctl build --project ~/my-pio-project/ --target esp32s3
# (Internally runs: pio run --environment esp32s3)

# ForgeOS flash step
forgeosctl flash --target esp32s3 --firmware .pio/build/esp32s3/firmware.bin --build-id $(git rev-parse HEAD)
# (Internally calls ForgePCB flash script)
```

---

**Document Status**: Complete
**Last Updated**: 2026-02-09
**Author**: Claude Code (Sonnet 4.5)
