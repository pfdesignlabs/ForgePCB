# Build Provenance Guide

Feature F005: Firmware provenance and artifact tracking

## Overview

ForgePCB enforces **mandatory firmware provenance** to eliminate "what is running?" ambiguity.

Every flash action generates a provenance record containing:
- ✅ Target identity (which carrier)
- ✅ Build identity (git commit, timestamp)
- ✅ Toolchain identifier (esptool version, etc.)
- ✅ Firmware path (source file)
- ✅ Flash result (success/failure)
- ✅ Serial log path (if captured)
- ✅ Human event log (manual actions)

**Frozen Decision (F005 #4)**: "Firmware provenance is mandatory. Every flash action must be attributable to source/build/time/target."

---

## Provenance Record Format

### JSON Structure

```json
{
  "target": "esp32s3",
  "build_id": "a1b2c3d4e5f6... (main@2026-02-09T14:23:00Z)",
  "toolchain": "esptool.py v4.5.1",
  "firmware_path": "/home/user/my-project/build/firmware.bin",
  "flash_time": "2026-02-09T14:25:30Z",
  "flash_result": "success",
  "serial_log": "/var/log/forgepcb/esp32s3-20260209-142530.log",
  "human_events": [
    {
      "time": "2026-02-09T14:24:00Z",
      "action": "manual_reset",
      "target": "esp32s3"
    }
  ]
}
```

### Fields

| Field | Description | Required |
|-------|-------------|----------|
| `target` | Target device name (esp32s3, rp2040) | Yes |
| `build_id` | Git commit + branch + timestamp | Yes |
| `toolchain` | Flash tool version | Yes |
| `firmware_path` | Absolute path to firmware file | Yes |
| `flash_time` | ISO 8601 timestamp of flash | Yes |
| `flash_result` | success / failure / verify_failed | Yes |
| `serial_log` | Path to serial log (if captured) | No |
| `human_events` | List of manual actions | No |

---

## Storage

### Directory Structure

```
/var/log/forgepcb/
├── provenance/
│   ├── esp32s3-20260209-142530.json
│   ├── esp32s3-20260209-150000.json
│   ├── rp2040-20260209-143000.json
│   ├── latest-esp32s3.json -> esp32s3-20260209-150000.json
│   └── latest-rp2040.json -> rp2040-20260209-143000.json
├── esp32s3-20260209-142530.log
├── esp32s3-20260209-150000.log
├── rp2040-20260209-143000.log
└── events.log
```

### Symlinks

Latest provenance for each target:
- `/var/log/forgepcb/provenance/latest-esp32s3.json`
- `/var/log/forgepcb/provenance/latest-rp2040.json`

---

## Viewing Provenance

### Current Firmware (Latest)

```bash
cat /var/log/forgepcb/provenance/latest-esp32s3.json
```

Output:
```json
{
  "target": "esp32s3",
  "build_id": "a1b2c3d4 (main@2026-02-09T15:00:00Z)",
  "flash_time": "2026-02-09T15:00:30Z",
  "flash_result": "success"
}
```

### Pretty Print (with jq)

```bash
jq '.' /var/log/forgepcb/provenance/latest-esp32s3.json
```

### Extract Build ID

```bash
jq -r '.build_id' /var/log/forgepcb/provenance/latest-esp32s3.json
```

Output:
```
a1b2c3d4e5f6... (main@2026-02-09T15:00:00Z)
```

---

## Build ID Format

ForgePCB uses **git-based build IDs** for traceability:

### Format

```
<commit-hash> (<branch>@<timestamp>)
```

### Example

```
a1b2c3d4e5f6 (main@2026-02-09T14:23:00Z)
```

### Generating Build IDs

**Option 1: Commit hash only**
```bash
BUILD_ID=$(git rev-parse HEAD)
# Example: a1b2c3d4e5f6...
```

**Option 2: Commit + branch + timestamp (recommended)**
```bash
COMMIT=$(git rev-parse --short HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILD_ID="$COMMIT ($BRANCH@$TIMESTAMP)"
# Example: a1b2c3d (main@2026-02-09T14:23:00Z)
```

**Option 3: Use git describe (version tags)**
```bash
BUILD_ID=$(git describe --always --dirty --tags)
# Example: v1.0.0-5-ga1b2c3d or v1.0.0
```

---

## Provenance Queries

### List All Flash Actions for Target

```bash
ls -lt /var/log/forgepcb/provenance/esp32s3-*.json
```

### Find Flash by Build ID

```bash
grep -l "abc123" /var/log/forgepcb/provenance/*.json
```

### Count Total Flashes

```bash
ls /var/log/forgepcb/provenance/esp32s3-*.json | wc -l
```

### Show Last 5 Flashes

```bash
ls -t /var/log/forgepcb/provenance/esp32s3-*.json | head -5 | xargs -I{} jq '{build_id, flash_time, flash_result}' {}
```

---

## Human Events

Manual actions are logged in provenance records and event log.

### Event Types

| Event | Description | Trigger |
|-------|-------------|---------|
| `manual_reset` | Pressed EN/RUN button on carrier | User action |
| `manual_bootsel` | Entered BOOTSEL mode (RP2040) | User action |
| `reseat` | Unplugged and replugged carrier | User action |
| `power_cycle` | Pressed reset on Power PCB | User action |
| `fault_cleared` | Cleared rail fault (eFuse reset) | User action |
| `flash_start` | Flash operation started | Tool |
| `flash_complete` | Flash operation completed | Tool |
| `serial_start` | Serial capture started | Tool |
| `serial_stop` | Serial capture stopped | Tool |

### Logging Manual Events

```bash
./tools/log_event.sh --target esp32s3 --action manual_reset
./tools/log_event.sh --target rp2040 --action reseat
./tools/log_event.sh --target power --action power_cycle
```

### Viewing Events

```bash
# JSON events
grep "manual_reset" /var/log/forgepcb/events.log

# Human-readable events
cat /var/log/forgepcb/events.log.txt
```

---

## Provenance Retention

### Default Policy

- **Retention**: 90 days
- **Location**: `/var/log/forgepcb/provenance/`

### Manual Cleanup

```bash
# Remove provenance older than 90 days
find /var/log/forgepcb/provenance/ -name "*.json" -mtime +90 -delete
```

### Archiving

```bash
# Archive provenance before cleanup
tar -czf provenance-archive-$(date +%Y%m%d).tar.gz /var/log/forgepcb/provenance/
```

---

## Integration with ForgeOS

When using ForgePCB with ForgeOS:

1. **ForgeOS generates build IDs**: Managed centrally
2. **ForgeOS tracks artifacts**: Build outputs, provenance, logs
3. **ForgeOS queries provenance**: "What firmware is on esp32s3?"
4. **ForgeOS UI (future)**: Dashboard showing current firmware per target

### Example ForgeOS Query

```bash
# What firmware is currently running on esp32s3?
forgeosctl status --target esp32s3
```

Output:
```
Target: esp32s3
Build ID: a1b2c3d (main@2026-02-09T15:00:00Z)
Flashed: 2026-02-09T15:00:30Z
Result: success
Serial Log: /var/log/forgepcb/esp32s3-20260209-150030.log
```

---

## Ambiguity Prevention

### Problem: "What is running?"

Without provenance:
- ❌ Multiple firmware versions in workspace
- ❌ Unclear which version was last flashed
- ❌ No record of when it was flashed
- ❌ Can't trace back to source code

With provenance:
- ✅ Every flash is recorded with git commit
- ✅ Timestamp shows when it was flashed
- ✅ Toolchain version is recorded
- ✅ Serial logs linked to builds

### Frozen Decision Enforcement

ForgePCB flash tools **require** `--build-id`:

```bash
# This FAILS (no build ID)
./flash_esp32.sh firmware.bin
# Error: Build ID required (--build-id <git-commit>)
# Frozen Decision (F005): Firmware provenance is mandatory.

# This SUCCEEDS (build ID provided)
./flash_esp32.sh firmware.bin --build-id $(git rev-parse HEAD)
```

---

## Best Practices

1. **Always use git commits as build IDs**: Traceable back to source

2. **Include branch and timestamp**: Helps with multi-branch workflows
   ```bash
   BUILD_ID="$(git rev-parse --short HEAD) ($(git branch --show-current)@$(date -u +%Y-%m-%dT%H:%M:%SZ))"
   ```

3. **Check provenance after flashing**: Verify correct build was flashed
   ```bash
   jq '.' /var/log/forgepcb/provenance/latest-esp32s3.json
   ```

4. **Archive provenance with builds**: Keep provenance records with build artifacts

5. **Log manual actions**: Helps with debugging intermittent issues
   ```bash
   ./tools/log_event.sh --target esp32s3 --action manual_reset
   ```

---

## Troubleshooting

### Missing provenance record

**Cause**: Flash failed before provenance was written

**Fix**: Check flash log for errors

### Wrong build ID in provenance

**Cause**: Flashed with incorrect `--build-id` argument

**Fix**: Reflash with correct build ID

### Serial log not linked in provenance

**Cause**: Serial capture wasn't run after flash, or jq not installed

**Fix**:
```bash
# Option 1: Run serial capture (updates provenance automatically)
./serial_capture.sh --target esp32s3

# Option 2: Manually update provenance (if jq installed)
jq '.serial_log = "/path/to/log.log"' latest-esp32s3.json > latest-esp32s3.json.tmp
mv latest-esp32s3.json.tmp latest-esp32s3.json
```

---

**Document Status**: Complete
**Last Updated**: 2026-02-09
**Author**: Claude Code (Sonnet 4.5)
