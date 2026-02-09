### Flash Workflow Guide

Feature F005: Firmware tooling and provenance

## Overview

This guide covers the complete firmware flashing workflow for ForgePCB MCU carriers (ESP32-S3 and RP2040 Pico).

**Frozen Decisions**:
- ✅ Explicit target selection required (no auto-detect)
- ✅ Firmware provenance mandatory (build ID must be provided)
- ✅ Rail fault = hard stop (must clear fault before flashing)
- ✅ Manual actions logged as events

---

## Prerequisites

### Tools Required

**ESP32-S3**:
```bash
pip install esptool
```

**RP2040**:
```bash
# Option 1: UF2 copy method (no tools needed, just file copy)
# Option 2: picotool (advanced)
sudo apt install picotool  # or build from source
```

### udev Rules (Linux)

Install ForgePCB udev rules for stable device identity:

```bash
sudo cp firmware/configs/udev/99-forgepcb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Verify symlinks:
```bash
ls -l /dev/forgepcb-*
# Expected:
#   /dev/forgepcb-esp32s3 -> ttyACM0 (or ttyUSB0)
#   /dev/forgepcb-rp2040 -> ttyACM1 (or ttyUSB1)
```

### User Permissions

Add your user to `plugdev` group:
```bash
sudo usermod -a -G plugdev $USER
```

Log out and log back in for changes to take effect.

---

## ESP32-S3 Flash Workflow

### Step 1: Build Firmware

Build your firmware (outside ForgePCB scope):
```bash
cd ~/my-esp32-project/
idf.py build
```

Output: `build/my-firmware.bin`

### Step 2: Capture Build ID

Get current git commit (for provenance):
```bash
BUILD_ID=$(git rev-parse HEAD)
echo $BUILD_ID  # Example: a1b2c3d4e5f6...
```

### Step 3: Flash

```bash
cd firmware/tools/
./flash_esp32.sh ~/my-esp32-project/build/my-firmware.bin --build-id $BUILD_ID
```

Expected output:
```
[ForgePCB] Checking for rail faults...
[ForgePCB] Logging flash start event...
[ForgePCB] Flashing ESP32-S3...
  Firmware: /home/user/my-esp32-project/build/my-firmware.bin
  Port: /dev/forgepcb-esp32s3
  Build ID: a1b2c3d4e5f6...
  Baud: 921600
esptool.py v4.5.1
...
Hash of data verified.

[ForgePCB] Flash successful!
[ForgePCB] Recording provenance...
[ForgePCB] Provenance recorded: /var/log/forgepcb/provenance/esp32s3-20260208-143000.json
[ForgePCB] Done! Device ready.
Next: ./serial_capture.sh --target esp32s3 --log-dir /var/log/forgepcb/
```

### Step 4: Monitor Serial (Optional)

```bash
./serial_capture.sh --target esp32s3
```

Press `Ctrl+A` then `K` to stop.

---

## RP2040 Flash Workflow

### Step 1: Build Firmware

Build your firmware (UF2 format):
```bash
cd ~/my-pico-project/
mkdir build && cd build
cmake ..
make
```

Output: `my-firmware.uf2`

### Step 2: Capture Build ID

```bash
BUILD_ID=$(git rev-parse HEAD)
```

### Step 3: Enter BOOTSEL Mode

**Manual Action** (logged by script):
1. Hold the **RUN button** on the RP2040 Pico carrier
2. While holding RUN, press and release the **BOOTSEL button** (if present on your Pico)
   - OR disconnect and reconnect USB while holding RUN
3. Release RUN button
4. RP2040 should appear as USB mass storage device: **RPI-RP2**

Verify mount:
```bash
ls /media/$USER/RPI-RP2/
# Expected: INFO_UF2.TXT
```

### Step 4: Flash

```bash
cd firmware/tools/
./flash_rp2040.sh ~/my-pico-project/build/my-firmware.uf2 --build-id $BUILD_ID
```

Expected output:
```
[ForgePCB] RP2040 Flash Tool
  Firmware: /home/user/my-pico-project/build/my-firmware.uf2
  Build ID: a1b2c3d4e5f6...

>>> MANUAL ACTION REQUIRED <<<
1. Hold the RUN button on the RP2040 Pico carrier
2. While holding RUN, press and release the BOOTSEL button (if present)
   OR disconnect and reconnect USB while holding RUN
3. Release RUN button
4. RP2040 should appear as USB mass storage device (RPI-RP2)

Press Enter when RP2040 is in BOOTSEL mode...

[ForgePCB] Found BOOTSEL mount: /media/user/RPI-RP2
[ForgePCB] Flashing by copying UF2 file...
'/home/user/my-pico-project/build/my-firmware.uf2' -> '/media/user/RPI-RP2/my-firmware.uf2'
[ForgePCB] Firmware copied to /media/user/RPI-RP2/
[ForgePCB] Waiting for RP2040 to reboot...
[ForgePCB] Device rebooted successfully!
[ForgePCB] Recording provenance...
[ForgePCB] Provenance recorded: /var/log/forgepcb/provenance/rp2040-20260208-143100.json
[ForgePCB] Done! Device ready.
```

### Step 5: Monitor Serial (Optional)

```bash
./serial_capture.sh --target rp2040
```

---

## Advanced Options

### Erase Flash Before Writing (ESP32-S3)

```bash
./flash_esp32.sh my-firmware.bin --build-id $BUILD_ID --erase
```

### Custom Baud Rate (ESP32-S3)

```bash
./flash_esp32.sh my-firmware.bin --build-id $BUILD_ID --baud 460800
```

### Use picotool (RP2040)

```bash
./flash_rp2040.sh my-firmware.uf2 --build-id $BUILD_ID --use-picotool
```

---

## Rail Fault Handling

If a **rail fault** is detected during flashing:

```
Error: Rail fault detected on Power PCB
Frozen Decision (F005): Rail fault = hard stop.
1. Check FAULT LED on Power PCB (5V, 3.3V, or Variable Bay)
2. Investigate cause (short circuit, overcurrent)
3. Press RESET button on Power PCB to clear fault
4. Log fault clearance: ./log_event.sh --target power --action fault_cleared
5. Retry flash
```

**Steps to recover**:
1. **Investigate**: Check breadboards, carrier connections, wiring
2. **Fix**: Remove short circuit or reduce load
3. **Clear fault**: Press RESET button on Power PCB
4. **Log**: `./tools/log_event.sh --target power --action fault_cleared`
5. **Retry**: Re-run flash command

**Frozen Decision**: No automatic recovery. Human acknowledgement required.

---

## Troubleshooting

### Device not found: /dev/forgepcb-esp32s3

**Causes**:
- udev rules not installed
- Device not connected
- Wrong USB port

**Fix**:
```bash
# Check if device is connected
lsusb | grep -i esp
# Expected: Bus 001 Device 010: ID 303a:1001 Espressif ESP32-S3

# Check udev rules
ls /etc/udev/rules.d/ | grep forgepcb
# Expected: 99-forgepcb.rules

# Reload udev
sudo udevadm control --reload-rules && sudo udevadm trigger

# Check symlink
ls -l /dev/forgepcb-*
```

### Permission denied: /dev/ttyACM0

**Cause**: User not in `plugdev` group

**Fix**:
```bash
sudo usermod -a -G plugdev $USER
# Log out and log back in
```

### Verification failed (ESP32-S3)

**Cause**: Unstable USB connection or flash corruption

**Fix**:
- Use lower baud rate: `--baud 460800`
- Use better USB cable
- Retry flash with erase: `--erase`

### RP2040 BOOTSEL mount not found

**Cause**: BOOTSEL mode not entered correctly

**Fix**:
1. Verify RUN button is held during reset
2. Check USB connection
3. Try manual USB disconnect/reconnect while holding RUN
4. Check mount points: `lsblk` or `df -h`

---

## Best Practices

1. **Always use build IDs**: Frozen decision requires provenance
   ```bash
   BUILD_ID=$(git rev-parse HEAD)
   ./flash_*.sh firmware.bin --build-id $BUILD_ID
   ```

2. **Log manual actions**: If you manually reset or reseat a device, log it
   ```bash
   ./log_event.sh --target esp32s3 --action manual_reset
   ```

3. **Monitor serial after flash**: Verify firmware boots correctly
   ```bash
   ./serial_capture.sh --target esp32s3
   ```

4. **Check provenance**: Review flash history
   ```bash
   cat /var/log/forgepcb/provenance/latest-esp32s3.json
   ```

5. **Clear faults explicitly**: Never ignore rail faults, always investigate

---

## Integration with ForgeOS

When using ForgePCB with ForgeOS:

1. **ForgeOS manages builds**: ForgeOS compiles firmware and tracks git commits
2. **ForgeOS calls flash tools**: Uses `flash_*.sh` scripts via SSH or local execution
3. **ForgeOS stores artifacts**: Provenance records, logs, and build outputs
4. **ForgeOS UI**: Dashboard shows current firmware on each target (future)

**Example ForgeOS integration**:
```bash
# ForgeOS build step
forgeosctl build --target esp32s3 --project ~/my-project/

# ForgeOS flash step (calls ForgePCB tools)
forgeosctl flash --target esp32s3 --firmware build/my-firmware.bin --build-id $(git rev-parse HEAD)

# Internally calls:
# ssh forgepcb-host "cd /opt/forgepcb/firmware/tools && ./flash_esp32.sh ..."
```

---

**Document Status**: Complete
**Last Updated**: 2026-02-09
**Author**: Claude Code (Sonnet 4.5)
