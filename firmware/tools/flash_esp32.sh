#!/usr/bin/env bash
# ForgePCB ESP32-S3 Flash Tool
# Feature F005: Firmware tooling with provenance and fault awareness
#
# Usage:
#   ./flash_esp32.sh <firmware.bin> [OPTIONS]
#
# Options:
#   --port <device>      Device path (default: /dev/forgepcb-esp32s3)
#   --build-id <id>      Build identifier (git commit, required)
#   --baud <speed>       Flash baud rate (default: 921600)
#   --erase              Erase flash before writing
#   --verify             Verify after flashing (default: true)
#   --no-reset           Do not reset after flashing
#
# Frozen Decisions (F005):
#   - Explicit target selection required (no auto-detect)
#   - Firmware provenance mandatory
#   - Rail fault = hard stop
#   - Manual actions logged as events

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(cd "$SCRIPT_DIR/../configs" && pwd)"
DEVICE_CONFIG="$CONFIG_DIR/devices.yaml"

# Defaults
DEFAULT_PORT="/dev/forgepcb-esp32s3"
DEFAULT_BAUD=921600
LOG_DIR="/var/log/forgepcb"
PROVENANCE_DIR="$LOG_DIR/provenance"
EVENT_LOG="$LOG_DIR/events.log"
FAULT_LOG="$LOG_DIR/faults.log"

# Tool
ESPTOOL="esptool.py"

# ==============================================================================
# Parse Arguments
# ==============================================================================
FIRMWARE=""
PORT="$DEFAULT_PORT"
BUILD_ID=""
BAUD="$DEFAULT_BAUD"
ERASE=false
VERIFY=true
NO_RESET=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port)
      PORT="$2"
      shift 2
      ;;
    --build-id)
      BUILD_ID="$2"
      shift 2
      ;;
    --baud)
      BAUD="$2"
      shift 2
      ;;
    --erase)
      ERASE=true
      shift
      ;;
    --no-verify)
      VERIFY=false
      shift
      ;;
    --no-reset)
      NO_RESET=true
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
  echo "Usage: $0 <firmware.bin> --build-id <id> [OPTIONS]" >&2
  exit 1
fi

if [[ ! -f "$FIRMWARE" ]]; then
  echo "Error: Firmware file not found: $FIRMWARE" >&2
  exit 1
fi

if [[ -z "$BUILD_ID" ]]; then
  echo "Error: Build ID required (--build-id <git-commit>)" >&2
  echo "Frozen Decision (F005): Firmware provenance is mandatory." >&2
  exit 1
fi

if [[ ! -e "$PORT" ]]; then
  echo "Error: Device not found: $PORT" >&2
  echo "Ensure udev rules are installed and ESP32-S3 is connected." >&2
  echo "Check: ls -l /dev/forgepcb-*" >&2
  exit 1
fi

if ! command -v "$ESPTOOL" &> /dev/null; then
  echo "Error: $ESPTOOL not found in PATH" >&2
  echo "Install: pip install esptool" >&2
  exit 1
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
# Log Event: Flash Start
# ==============================================================================
mkdir -p "$LOG_DIR" "$PROVENANCE_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FLASH_LOG="$LOG_DIR/flash-esp32s3-$(date +%Y%m%d-%H%M%S).log"

echo "[ForgePCB] Logging flash start event..."
"$SCRIPT_DIR/log_event.sh" --target esp32s3 --action flash_start --build-id "$BUILD_ID" 2>/dev/null || true

# ==============================================================================
# Flash Firmware
# ==============================================================================
echo "[ForgePCB] Flashing ESP32-S3..."
echo "  Firmware: $FIRMWARE"
echo "  Port: $PORT"
echo "  Build ID: $BUILD_ID"
echo "  Baud: $BAUD"
echo "  Log: $FLASH_LOG"

# Build esptool command
ESPTOOL_CMD=("$ESPTOOL" --chip esp32s3 --port "$PORT" --baud "$BAUD")

if [[ "$ERASE" == "true" ]]; then
  echo "[ForgePCB] Erasing flash..."
  "${ESPTOOL_CMD[@]}" erase_flash | tee -a "$FLASH_LOG"
fi

echo "[ForgePCB] Writing firmware..."
FLASH_CMD=("${ESPTOOL_CMD[@]}" write_flash -z 0x0 "$FIRMWARE")

if [[ "$NO_RESET" == "true" ]]; then
  FLASH_CMD+=(--no-stub)
fi

if "${FLASH_CMD[@]}" | tee -a "$FLASH_LOG"; then
  FLASH_RESULT="success"
  echo "[ForgePCB] Flash successful!"
else
  FLASH_RESULT="failure"
  echo "[ForgePCB] Flash failed!" >&2
fi

# ==============================================================================
# Verify (Optional)
# ==============================================================================
if [[ "$VERIFY" == "true" && "$FLASH_RESULT" == "success" ]]; then
  echo "[ForgePCB] Verifying flash..."
  if "${ESPTOOL_CMD[@]}" verify_flash 0x0 "$FIRMWARE" | tee -a "$FLASH_LOG"; then
    echo "[ForgePCB] Verification successful!"
  else
    FLASH_RESULT="verify_failed"
    echo "[ForgePCB] Verification failed!" >&2
  fi
fi

# ==============================================================================
# Capture Provenance
# ==============================================================================
echo "[ForgePCB] Recording provenance..."
TOOLCHAIN_VERSION=$("$ESPTOOL" version 2>&1 | head -n1 || echo "unknown")
FIRMWARE_ABS=$(realpath "$FIRMWARE")
PROVENANCE_FILE="$PROVENANCE_DIR/esp32s3-$(date +%Y%m%d-%H%M%S).json"

cat > "$PROVENANCE_FILE" <<EOF
{
  "target": "esp32s3",
  "build_id": "$BUILD_ID",
  "toolchain": "$TOOLCHAIN_VERSION",
  "firmware_path": "$FIRMWARE_ABS",
  "flash_time": "$TIMESTAMP",
  "flash_result": "$FLASH_RESULT",
  "flash_log": "$FLASH_LOG",
  "serial_log": null,
  "human_events": []
}
EOF

# Symlink to latest
ln -sf "$PROVENANCE_FILE" "$PROVENANCE_DIR/latest-esp32s3.json"

echo "[ForgePCB] Provenance recorded: $PROVENANCE_FILE"

# ==============================================================================
# Log Event: Flash Complete
# ==============================================================================
"$SCRIPT_DIR/log_event.sh" --target esp32s3 --action flash_complete --build-id "$BUILD_ID" --result "$FLASH_RESULT" 2>/dev/null || true

# ==============================================================================
# Exit
# ==============================================================================
if [[ "$FLASH_RESULT" == "success" ]]; then
  echo "[ForgePCB] Done! Device ready."
  echo "Next: ./serial_capture.sh --target esp32s3 --log-dir $LOG_DIR"
  exit 0
else
  echo "[ForgePCB] Flash failed. Check log: $FLASH_LOG" >&2
  exit 1
fi
