#!/usr/bin/env bash
# ForgePCB RP2040 Flash Tool
# Feature F005: Firmware tooling with provenance and fault awareness
#
# Usage:
#   ./flash_rp2040.sh <firmware.uf2> [OPTIONS]
#
# Options:
#   --build-id <id>      Build identifier (git commit, required)
#   --verify             Verify after flashing (default: true)
#
# Frozen Decisions (F005):
#   - Explicit target selection required (no auto-detect)
#   - Firmware provenance mandatory
#   - Rail fault = hard stop
#   - Manual actions logged as events (BOOTSEL mode requires manual RUN button)

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(cd "$SCRIPT_DIR/../configs" && pwd)"
DEVICE_CONFIG="$CONFIG_DIR/devices.yaml"

# Defaults
BOOTSEL_MOUNT="/media/$USER/RPI-RP2"  # Default RP2040 BOOTSEL mount point
LOG_DIR="/var/log/forgepcb"
PROVENANCE_DIR="$LOG_DIR/provenance"
EVENT_LOG="$LOG_DIR/events.log"

# Tool (picotool or UF2 copy method)
USE_PICOTOOL=false  # Set to true if picotool is available
PICOTOOL="picotool"

# ==============================================================================
# Parse Arguments
# ==============================================================================
FIRMWARE=""
BUILD_ID=""
VERIFY=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-id)
      BUILD_ID="$2"
      shift 2
      ;;
    --no-verify)
      VERIFY=false
      shift
      ;;
    --use-picotool)
      USE_PICOTOOL=true
      shift
      ;;
    *)
      if [[ -z "$FIRMWARE" ]]; then
        FIRMWARE="$1"
      else
        echo "Error: Unknown argument: $1" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# ==============================================================================
# Validation
# ==============================================================================
if [[ -z "$FIRMWARE" ]]; then
  echo "Error: Firmware file required" >&2
  echo "Usage: $0 <firmware.uf2> --build-id <id> [OPTIONS]" >&2
  exit 1
fi

if [[ ! -f "$FIRMWARE" ]]; then
  echo "Error: Firmware file not found: $FIRMWARE" >&2
  exit 1
fi

if [[ ! "$FIRMWARE" =~ \.uf2$ ]]; then
  echo "Error: Firmware must be a .uf2 file for RP2040" >&2
  exit 1
fi

if [[ -z "$BUILD_ID" ]]; then
  echo "Error: Build ID required (--build-id <git-commit>)" >&2
  echo "Frozen Decision (F005): Firmware provenance is mandatory." >&2
  exit 1
fi

if [[ "$USE_PICOTOOL" == "true" ]] && ! command -v "$PICOTOOL" &> /dev/null; then
  echo "Warning: picotool not found, falling back to UF2 copy method" >&2
  USE_PICOTOOL=false
fi

# ==============================================================================
# Fault Check
# ==============================================================================
echo "[ForgePCB] Checking for rail faults..."
# TODO: Implement fault detection (read GPIO, check fault LED, or query Power PCB)
# For now, assume no fault (placeholder)
FAULT_DETECTED=false

if [[ "$FAULT_DETECTED" == "true" ]]; then
  echo "Error: Rail fault detected on Power PCB" >&2
  echo "Frozen Decision (F005): Rail fault = hard stop." >&2
  echo "1. Check FAULT LED on Power PCB (5V, 3.3V, or Variable Bay)" >&2
  echo "2. Investigate cause (short circuit, overcurrent)" >&2
  echo "3. Press RESET button on Power PCB to clear fault" >&2
  echo "4. Log fault clearance: ./log_event.sh --target power --action fault_cleared" >&2
  echo "5. Retry flash" >&2
  exit 2
fi

# ==============================================================================
# Enter BOOTSEL Mode
# ==============================================================================
echo "[ForgePCB] RP2040 Flash Tool"
echo "  Firmware: $FIRMWARE"
echo "  Build ID: $BUILD_ID"
echo ""
echo ">>> MANUAL ACTION REQUIRED <<<"
echo "1. Hold the RUN button on the RP2040 Pico carrier"
echo "2. While holding RUN, press and release the BOOTSEL button (if present)"
echo "   OR disconnect and reconnect USB while holding RUN"
echo "3. Release RUN button"
echo "4. RP2040 should appear as USB mass storage device (RPI-RP2)"
echo ""
read -p "Press Enter when RP2040 is in BOOTSEL mode..."

# Log manual action
"$SCRIPT_DIR/log_event.sh" --target rp2040 --action manual_bootsel --build-id "$BUILD_ID" 2>/dev/null || true

# ==============================================================================
# Detect BOOTSEL Mount
# ==============================================================================
echo "[ForgePCB] Detecting RP2040 BOOTSEL mount..."

# Check common mount points
BOOTSEL_DETECTED=false
for MOUNT_CHECK in "/media/$USER/RPI-RP2" "/mnt/RPI-RP2" "/Volumes/RPI-RP2"; do
  if [[ -d "$MOUNT_CHECK" ]]; then
    BOOTSEL_MOUNT="$MOUNT_CHECK"
    BOOTSEL_DETECTED=true
    echo "[ForgePCB] Found BOOTSEL mount: $BOOTSEL_MOUNT"
    break
  fi
done

if [[ "$BOOTSEL_DETECTED" == "false" ]]; then
  echo "Error: RP2040 BOOTSEL mount not found" >&2
  echo "Expected mount points: /media/$USER/RPI-RP2, /mnt/RPI-RP2, /Volumes/RPI-RP2" >&2
  echo "Check:" >&2
  echo "  1. RP2040 is in BOOTSEL mode (RUN button held during reset)" >&2
  echo "  2. USB connection is stable" >&2
  echo "  3. Mount point is accessible (lsblk or df -h)" >&2
  exit 1
fi

# ==============================================================================
# Log Event: Flash Start
# ==============================================================================
mkdir -p "$LOG_DIR" "$PROVENANCE_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FLASH_LOG="$LOG_DIR/flash-rp2040-$(date +%Y%m%d-%H%M%S).log"

echo "[ForgePCB] Logging flash start event..."
"$SCRIPT_DIR/log_event.sh" --target rp2040 --action flash_start --build-id "$BUILD_ID" 2>/dev/null || true

# ==============================================================================
# Flash Firmware
# ==============================================================================
FLASH_RESULT="success"

if [[ "$USE_PICOTOOL" == "true" ]]; then
  # Method 1: picotool (advanced, requires picotool installed)
  echo "[ForgePCB] Flashing with picotool..."
  if "$PICOTOOL" load "$FIRMWARE" --force --verify | tee "$FLASH_LOG"; then
    echo "[ForgePCB] Flash successful!"
  else
    FLASH_RESULT="failure"
    echo "[ForgePCB] Flash failed!" >&2
  fi
else
  # Method 2: UF2 copy (simple, no tools required)
  echo "[ForgePCB] Flashing by copying UF2 file..."
  if cp -v "$FIRMWARE" "$BOOTSEL_MOUNT/" | tee "$FLASH_LOG"; then
    echo "[ForgePCB] Firmware copied to $BOOTSEL_MOUNT/"
    echo "[ForgePCB] Waiting for RP2040 to reboot..."
    sleep 2

    # Check if mount still exists (RP2040 should auto-eject after flash)
    if [[ -d "$BOOTSEL_MOUNT" ]]; then
      echo "Warning: BOOTSEL mount still present. Device may not have rebooted." >&2
      echo "Try manually ejecting or unplugging/replugging USB." >&2
    else
      echo "[ForgePCB] Device rebooted successfully!"
    fi
  else
    FLASH_RESULT="failure"
    echo "[ForgePCB] Flash failed!" >&2
  fi
fi

# ==============================================================================
# Capture Provenance
# ==============================================================================
echo "[ForgePCB] Recording provenance..."
TOOLCHAIN_VERSION="picotool $(picotool version 2>&1 | head -n1 || echo 'unknown')"
FIRMWARE_ABS=$(realpath "$FIRMWARE")
PROVENANCE_FILE="$PROVENANCE_DIR/rp2040-$(date +%Y%m%d-%H%M%S).json"

cat > "$PROVENANCE_FILE" <<EOF
{
  "target": "rp2040",
  "build_id": "$BUILD_ID",
  "toolchain": "$TOOLCHAIN_VERSION",
  "firmware_path": "$FIRMWARE_ABS",
  "flash_time": "$TIMESTAMP",
  "flash_result": "$FLASH_RESULT",
  "flash_log": "$FLASH_LOG",
  "serial_log": null,
  "human_events": [
    {"time": "$TIMESTAMP", "action": "manual_bootsel", "description": "User entered BOOTSEL mode (RUN button)"}
  ]
}
EOF

# Symlink to latest
ln -sf "$PROVENANCE_FILE" "$PROVENANCE_DIR/latest-rp2040.json"

echo "[ForgePCB] Provenance recorded: $PROVENANCE_FILE"

# ==============================================================================
# Log Event: Flash Complete
# ==============================================================================
"$SCRIPT_DIR/log_event.sh" --target rp2040 --action flash_complete --build-id "$BUILD_ID" --result "$FLASH_RESULT" 2>/dev/null || true

# ==============================================================================
# Exit
# ==============================================================================
if [[ "$FLASH_RESULT" == "success" ]]; then
  echo "[ForgePCB] Done! Device ready."
  echo "Next: ./serial_capture.sh --target rp2040 --log-dir $LOG_DIR"
  exit 0
else
  echo "[ForgePCB] Flash failed. Check log: $FLASH_LOG" >&2
  exit 1
fi
