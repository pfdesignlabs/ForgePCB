# ForgePCB Firmware Tooling

Feature F005: Firmware, Tooling, and ForgeOS Integration

## Overview

This directory contains firmware tooling and ForgeOS integration for ForgePCB. It provides deterministic, auditable firmware workflows for ESP32-S3 and RP2040 MCU carriers.

## Mission

Enable deterministic firmware iteration with:
- ✅ Auditable flashing workflows
- ✅ Captured and attributable serial logging
- ✅ Build provenance (no "what is running?" ambiguity)
- ✅ Interruption-resume support
- ✅ Explicit handling of rail faults and manual human actions

**ForgePCB is a development endpoint, not a runtime controller.**

---

## Directory Structure

```
firmware/
├── README.md           # This file
├── tools/              # Flash and serial capture tools
│   ├── flash_esp32.sh  # ESP32-S3 flash orchestration
│   ├── flash_rp2040.sh # RP2040 flash orchestration
│   ├── serial_capture.sh # Serial output capture
│   └── log_event.sh    # Manual action event logging
├── configs/            # USB identity and device mappings
│   ├── udev/           # udev rules for stable device identity
│   │   └── 99-forgepcb.rules
│   └── devices.yaml    # Device identity mapping
├── examples/           # Integration examples
│   └── platformio.ini  # PlatformIO configuration example
└── docs/               # Workflow documentation
    ├── FLASHING.md     # Flash workflow guide
    ├── SERIAL.md       # Serial capture guide
    ├── PROVENANCE.md   # Build metadata guide
    └── PLATFORMIO.md   # PlatformIO integration guide
```

---

## Key Frozen Decisions (F005)

### 1. USB Topology
- **Single upstream USB** connection to ForgeOS
- **Internal hub** fans out to downstream devices:
  - ESP32-S3 carrier
  - RP2040 Pico carrier
  - Logic analyzer dongle
  - Utility slot (future)

### 2. Stable USB Identity
- Each carrier class is **targetable deterministically** (udev rules, port topology)
- **Flashing without explicit target selection is forbidden**
- **"Last device wins" behavior is forbidden**

### 3. Firmware Provenance
- Every flash action must be attributable to:
  - Source (git commit)
  - Build (timestamp, toolchain)
  - Time (when flashed)
  - Target (which carrier)

### 4. Serial Capture
- All serial output is **captured and logged**
- Logs are **associated with build and target**

### 5. Manual Actions as Events
- Manual reset, reseat, power-cycle are **logged as human events**
- Electrical sensing is optional; **process logging is mandatory**

### 6. Fault Awareness
- **Rail fault = hard stop** for tooling execution
- Fault clearance requires **explicit human acknowledgement**

### 7. Tier 0 Observability
- **Reliable flash + serial capture FIRST**
- Optional telemetry comes later

---

## Quick Start

### Prerequisites

1. **ForgeOS host** running Linux (Ubuntu/Debian recommended)
2. **udev rules installed**: `sudo cp configs/udev/99-forgepcb.rules /etc/udev/rules.d/`
3. **Reload udev**: `sudo udevadm control --reload-rules && sudo udevadm trigger`
4. **Required tools**:
   - `esptool.py` (ESP32-S3 flashing)
   - `picotool` (RP2040 flashing)
   - `screen` or `minicom` (serial terminal)

### Flash ESP32-S3 Carrier

```bash
cd firmware/tools/
./flash_esp32.sh <firmware.bin> --port /dev/forgepcb-esp32s3 --build-id <git-commit>
```

### Flash RP2040 Pico Carrier

```bash
cd firmware/tools/
./flash_rp2040.sh <firmware.uf2> --build-id <git-commit>
```

### Capture Serial Output

```bash
cd firmware/tools/
./serial_capture.sh --target esp32s3 --log-dir /var/log/forgepcb/
```

---

## PlatformIO Integration (Optional)

ForgePCB works great with **PlatformIO** while maintaining mandatory provenance tracking!

### Quick Start with PlatformIO

```bash
# 1. Install PlatformIO
pip install platformio

# 2. Copy example config to your project
cp firmware/examples/platformio.ini ~/my-project/platformio.ini

# 3. Adjust paths in platformio.ini
# (Update upload_command to point to ForgePCB flash scripts)

# 4. Build and flash
cd ~/my-project/
pio run --target upload  # Builds + flashes with provenance!
```

**How it works:**
- PlatformIO builds your firmware (Arduino, ESP-IDF, Pico SDK)
- Custom upload command calls ForgePCB flash scripts
- Provenance tracking enforced (build ID from git commit)
- Best of both worlds: PlatformIO convenience + ForgePCB compliance

**See:** `firmware/docs/PLATFORMIO.md` for complete integration guide

---

## USB Device Identity

ForgePCB uses **udev rules** to create stable symlinks for each target:

| Target | Symlink | Physical Device |
|--------|---------|-----------------|
| ESP32-S3 carrier | `/dev/forgepcb-esp32s3` | `/dev/ttyUSB0` (or ACM0) |
| RP2040 Pico carrier | `/dev/forgepcb-rp2040` | `/dev/ttyACM1` (or USB1) |
| Logic Analyzer | `/dev/forgepcb-la` | USB device (via libusb) |

### How It Works

1. **USB hub topology**: ForgeOS sees a single USB hub with 4 downstream ports
2. **Port-based mapping**: udev rules match devices by hub port number + VID/PID
3. **Stable symlinks**: `/dev/forgepcb-*` symlinks always point to correct device
4. **No ambiguity**: Explicit target selection required for all operations

---

## Firmware Provenance

Every flash action generates a **provenance record**:

```json
{
  "target": "esp32s3",
  "build_id": "a1b2c3d (main@2026-02-08T14:23:00Z)",
  "toolchain": "esptool.py 4.5.1",
  "firmware_path": "/builds/my-project/firmware.bin",
  "flash_time": "2026-02-08T14:25:30Z",
  "flash_result": "success",
  "serial_log": "/var/log/forgepcb/esp32s3-20260208-142530.log",
  "human_events": [
    {"time": "2026-02-08T14:24:00Z", "action": "manual_reset", "target": "esp32s3"}
  ]
}
```

Provenance records are stored in: `/var/log/forgepcb/provenance/`

---

## Serial Logging

Serial output from each target is:
1. **Captured in real-time** (stdout + log file)
2. **Timestamped** (每line prefixed with ISO timestamp)
3. **Associated with build** (provenance record links to log file)
4. **Retained** (log rotation policy: 30 days or 100 MB)

Log file naming: `<target>-<ISO-timestamp>.log`

Example: `/var/log/forgepcb/esp32s3-20260208-142530.log`

---

## Manual Action Logging

When you manually interact with ForgePCB, log the action:

```bash
# Log a manual reset
./tools/log_event.sh --target esp32s3 --action manual_reset

# Log a reseat (unplug + replug)
./tools/log_event.sh --target rp2040 --action reseat

# Log a power cycle (via Power PCB reset button)
./tools/log_event.sh --target power --action power_cycle
```

Events are appended to: `/var/log/forgepcb/events.log`

---

## Rail Fault Handling

If a **rail fault** occurs (eFuse trip on Power PCB):

1. **Tooling STOPS immediately** (no flashing, no serial capture)
2. **Fault LED visible** (red LED on Power PCB)
3. **Human investigates**:
   - Check breadboard for shorts
   - Check carrier connections
   - Check load on rails
4. **Clear fault**:
   - Press RESET button on Power PCB
   - eFuse re-enables rail
5. **Acknowledge fault**:
   - Log event: `./tools/log_event.sh --target power --action fault_cleared`
6. **Resume work** (tooling can proceed)

**Frozen Decision**: Rail fault is a **hard stop**. No automatic recovery.

---

## Workflow Examples

### Example 1: Flash and Monitor ESP32-S3

```bash
# 1. Flash firmware
./tools/flash_esp32.sh my-firmware.bin --port /dev/forgepcb-esp32s3 --build-id $(git rev-parse HEAD)

# 2. Capture serial output
./tools/serial_capture.sh --target esp32s3 --log-dir /var/log/forgepcb/

# 3. Observe output in terminal (real-time)
# Press Ctrl+C to stop capture

# 4. Check provenance
cat /var/log/forgepcb/provenance/latest.json
```

### Example 2: Flash RP2040, Manual Reset, Monitor

```bash
# 1. Flash firmware
./tools/flash_rp2040.sh my-firmware.uf2 --build-id $(git rev-parse HEAD)

# 2. Manually press RUN button on carrier
./tools/log_event.sh --target rp2040 --action manual_reset

# 3. Capture serial output
./tools/serial_capture.sh --target rp2040 --log-dir /var/log/forgepcb/
```

### Example 3: Handle Rail Fault

```bash
# 1. Attempt to flash (fails due to fault)
./tools/flash_esp32.sh my-firmware.bin --port /dev/forgepcb-esp32s3 --build-id $(git rev-parse HEAD)
# Error: Rail fault detected on 5V rail. Clear fault and retry.

# 2. Investigate breadboard (find short circuit)

# 3. Fix short circuit

# 4. Press RESET button on Power PCB (clear eFuse latch)

# 5. Log fault clearance
./tools/log_event.sh --target power --action fault_cleared

# 6. Retry flash
./tools/flash_esp32.sh my-firmware.bin --port /dev/forgepcb-esp32s3 --build-id $(git rev-parse HEAD)
# Success!
```

---

## Integration with ForgeOS

ForgePCB firmware tooling is designed to integrate with ForgeOS workflows:

1. **ForgeOS manages builds**: Compiles firmware, tracks git commits
2. **ForgeOS calls ForgePCB tools**: Uses `flash_*.sh` scripts to flash targets
3. **ForgeOS stores artifacts**: Provenance records, logs, builds
4. **ForgeOS UI (future)**: Dashboard showing current firmware on each target

**Current Status**: CLI-first. ForgeOS UI integration is future work.

---

## Excluded Scope (F005)

- ❌ Firmware content (use your own projects)
- ❌ Production deployment (ForgePCB is dev-only)
- ❌ Cloud services (local-only workflows)
- ❌ Advanced telemetry (v0.2+ optional)

---

## Next Steps

1. **Install udev rules** (see `configs/udev/`)
2. **Test USB enumeration** (verify symlinks exist)
3. **Flash test firmware** (blink LED, serial output)
4. **Verify serial capture** (check log files)
5. **Integrate with your workflow** (ForgeOS or custom scripts)

---

**Feature**: F005 (Firmware, Tooling, and ForgeOS Integration)
**Status**: Implementation in progress
**Last Updated**: 2026-02-09
**Author**: Claude Code (Sonnet 4.5)
