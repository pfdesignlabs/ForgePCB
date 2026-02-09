#!/usr/bin/env bash
# ForgePCB Event Logging Tool
# Feature F005: Manual action logging
#
# Usage:
#   ./log_event.sh --target <name> --action <action> [OPTIONS]
#
# Options:
#   --target <name>      Target device (esp32s3, rp2040, power, etc.)
#   --action <action>    Action type (manual_reset, reseat, power_cycle, fault_cleared, etc.)
#   --build-id <id>      Associated build ID (optional)
#   --result <result>    Result of action (optional)
#   --description <desc> Additional description (optional)
#
# Frozen Decision (F005 #6):
# "Hands-on actions are first-class events. Manual reset, reseat, and
#  power-cycle must be logged as human events."

set -euo pipefail

# ==============================================================================
# Configuration
# ==============================================================================
LOG_DIR="/var/log/forgepcb"
EVENT_LOG="$LOG_DIR/events.log"

# ==============================================================================
# Parse Arguments
# ==============================================================================
TARGET=""
ACTION=""
BUILD_ID=""
RESULT=""
DESCRIPTION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    --action)
      ACTION="$2"
      shift 2
      ;;
    --build-id)
      BUILD_ID="$2"
      shift 2
      ;;
    --result)
      RESULT="$2"
      shift 2
      ;;
    --description)
      DESCRIPTION="$2"
      shift 2
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
  echo "Error: Target required (--target <name>)" >&2
  exit 1
fi

if [[ -z "$ACTION" ]]; then
  echo "Error: Action required (--action <action>)" >&2
  exit 1
fi

# ==============================================================================
# Log Event
# ==============================================================================
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TIMESTAMP_READABLE=$(date)

# Build JSON event
EVENT_JSON=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "target": "$TARGET",
  "action": "$ACTION",
  "build_id": "${BUILD_ID:-null}",
  "result": "${RESULT:-null}",
  "description": "${DESCRIPTION:-}",
  "logged_by": "log_event.sh"
}
EOF
)

# Append to event log
echo "$EVENT_JSON" >> "$EVENT_LOG"

# Also log human-readable version
echo "[$TIMESTAMP_READABLE] target=$TARGET action=$ACTION build_id=${BUILD_ID:-N/A} result=${RESULT:-N/A}" >> "$EVENT_LOG.txt"

# Print confirmation (to stderr to avoid polluting stdout)
echo "[ForgePCB] Event logged: $TARGET / $ACTION" >&2

exit 0
