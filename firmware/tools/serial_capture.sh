#!/usr/bin/env bash
# ForgePCB Serial Capture Tool
# Feature F005: Serial logging with timestamps and provenance
#
# Usage:
#   ./serial_capture.sh --target <esp32s3|rp2040> [OPTIONS]
#
# Options:
#   --target <name>      Target device (esp32s3 or rp2040, required)
#   --port <device>      Device path (auto-detected from target)
#   --baud <speed>       Serial baud rate (default: 115200)
#   --log-dir <path>     Log directory (default: /var/log/forgepcb)
#   --no-timestamp       Do not prefix lines with timestamps
#
# Frozen Decisions (F005):
#   - Serial output is captured and logged
#   - Logs are timestamped and associated with build
#   - Explicit target selection required

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="/var/log/forgepcb"
PROVENANCE_DIR="$LOG_DIR/provenance"
EVENT_LOG="$LOG_DIR/events.log"

# Defaults
TARGET=""
PORT=""
BAUD=115200
ADD_TIMESTAMP=true

# ==============================================================================
# Parse Arguments
# ==============================================================================
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    --port)
      PORT="$2"
      shift 2
      ;;
    --baud)
      BAUD="$2"
      shift 2
      ;;
    --log-dir)
      LOG_DIR="$2"
      shift 2
      ;;
    --no-timestamp)
      ADD_TIMESTAMP=false
      shift
      ;;
    *)
      echo "Error: Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

# ==============================================================================
# Validation
# ==============================================================================
if [[ -z "$TARGET" ]]; then
  echo "Error: Target required (--target esp32s3 or --target rp2040)" >&2
  echo "Frozen Decision (F005): Explicit target selection is mandatory." >&2
  exit 1
fi

if [[ "$TARGET" != "esp32s3" && "$TARGET" != "rp2040" ]]; then
  echo "Error: Invalid target: $TARGET (expected esp32s3 or rp2040)" >&2
  exit 1
fi

# Auto-detect port if not specified
if [[ -z "$PORT" ]]; then
  if [[ "$TARGET" == "esp32s3" ]]; then
    PORT="/dev/forgepcb-esp32s3"
  elif [[ "$TARGET" == "rp2040" ]]; then
    PORT="/dev/forgepcb-rp2040"
  fi
  echo "[ForgePCB] Auto-detected port: $PORT"
fi

if [[ ! -e "$PORT" ]]; then
  echo "Error: Device not found: $PORT" >&2
  echo "Ensure udev rules are installed and $TARGET is connected." >&2
  echo "Check: ls -l /dev/forgepcb-*" >&2
  exit 1
fi

if ! command -v screen &> /dev/null; then
  echo "Error: 'screen' not found in PATH" >&2
  echo "Install: sudo apt install screen" >&2
  exit 1
fi

# ==============================================================================
# Log Setup
# ==============================================================================
mkdir -p "$LOG_DIR"
TIMESTAMP_ISO=$(date -u +"%Y%m%d-%H%M%S")
SERIAL_LOG="$LOG_DIR/${TARGET}-${TIMESTAMP_ISO}.log"

echo "[ForgePCB] Serial Capture Tool"
echo "  Target: $TARGET"
echo "  Port: $PORT"
echo "  Baud: $BAUD"
echo "  Log: $SERIAL_LOG"
echo ""
echo "Press Ctrl+A then K to stop capture."
echo ""

# ==============================================================================
# Log Event: Serial Start
# ==============================================================================
"$SCRIPT_DIR/log_event.sh" --target "$TARGET" --action serial_start 2>/dev/null || true

# ==============================================================================
# Serial Capture
# ==============================================================================
if [[ "$ADD_TIMESTAMP" == "true" ]]; then
  # Capture with timestamps
  echo "[ForgePCB] Starting serial capture with timestamps..."

  # Configure serial port
  stty -F "$PORT" "$BAUD" raw -echo

  # Capture and add timestamps
  while IFS= read -r line; do
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    echo "[$TIMESTAMP] $line" | tee -a "$SERIAL_LOG"
  done < "$PORT"
else
  # Capture without timestamps
  echo "[ForgePCB] Starting serial capture (raw)..."
  screen -L -Logfile "$SERIAL_LOG" "$PORT" "$BAUD"
fi

# ==============================================================================
# Log Event: Serial Stop
# ==============================================================================
"$SCRIPT_DIR/log_event.sh" --target "$TARGET" --action serial_stop 2>/dev/null || true

# ==============================================================================
# Update Provenance
# ==============================================================================
echo ""
echo "[ForgePCB] Serial capture stopped."
echo "[ForgePCB] Log saved: $SERIAL_LOG"

# Link serial log to latest provenance record
LATEST_PROVENANCE="$PROVENANCE_DIR/latest-${TARGET}.json"
if [[ -f "$LATEST_PROVENANCE" ]]; then
  echo "[ForgePCB] Updating provenance record..."
  # Update serial_log field in JSON (using jq if available)
  if command -v jq &> /dev/null; then
    jq ".serial_log = \"$SERIAL_LOG\"" "$LATEST_PROVENANCE" > "$LATEST_PROVENANCE.tmp"
    mv "$LATEST_PROVENANCE.tmp" "$LATEST_PROVENANCE"
    echo "[ForgePCB] Provenance updated: $LATEST_PROVENANCE"
  else
    echo "Warning: jq not found, provenance not updated. Install jq for automatic provenance updates." >&2
  fi
fi

echo "[ForgePCB] Done!"
