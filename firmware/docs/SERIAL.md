# Serial Capture Guide

Feature F005: Serial logging with timestamps and provenance

## Overview

ForgePCB captures all serial output from MCU carriers with:
- ✅ Real-time console display + log file storage
- ✅ Timestamped output (ISO 8601 format)
- ✅ Association with build and target (provenance)
- ✅ Log retention and rotation

**Frozen Decision (F005 #5)**: "Serial output is captured. Logs are stored and associated with build and target."

---

## Quick Start

### Capture Serial Output

```bash
cd firmware/tools/
./serial_capture.sh --target esp32s3
```

Press `Ctrl+A` then `K` to stop.

---

## Usage

### ESP32-S3

```bash
./serial_capture.sh --target esp32s3 [OPTIONS]
```

### RP2040

```bash
./serial_capture.sh --target rp2040 [OPTIONS]
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--target <name>` | Target device (esp32s3 or rp2040) | Required |
| `--port <device>` | Serial port path | Auto-detected |
| `--baud <speed>` | Baud rate | 115200 |
| `--log-dir <path>` | Log directory | /var/log/forgepcb |
| `--no-timestamp` | Disable line timestamps | Timestamps enabled |

---

## Log Format

### Timestamped Output (Default)

Each line is prefixed with ISO 8601 timestamp:

```
[2026-02-09T14:30:15.123Z] ESP32-S3 Chip ID: 0x1234567890ABCDEF
[2026-02-09T14:30:15.456Z] Starting main task...
[2026-02-09T14:30:15.789Z] WiFi connecting...
```

### Raw Output (--no-timestamp)

Original serial output without modification:

```
ESP32-S3 Chip ID: 0x1234567890ABCDEF
Starting main task...
WiFi connecting...
```

---

## Log Storage

### Log File Naming

Logs are stored with timestamp in filename:

```
/var/log/forgepcb/<target>-<timestamp>.log
```

Examples:
- `/var/log/forgepcb/esp32s3-20260209-143015.log`
- `/var/log/forgepcb/rp2040-20260209-143020.log`

### Provenance Linking

Serial logs are automatically linked to provenance records:

```json
{
  "target": "esp32s3",
  "build_id": "a1b2c3d4e5f6...",
  "flash_time": "2026-02-09T14:29:00Z",
  "serial_log": "/var/log/forgepcb/esp32s3-20260209-143015.log"
}
```

---

## Common Workflows

### Workflow 1: Flash and Monitor

```bash
# 1. Flash firmware
./flash_esp32.sh firmware.bin --build-id $(git rev-parse HEAD)

# 2. Start serial capture
./serial_capture.sh --target esp32s3

# 3. Observe boot messages
# Press Ctrl+A then K to stop
```

### Workflow 2: Monitor Existing Firmware

```bash
# Just start serial capture (no flashing)
./serial_capture.sh --target rp2040
```

### Workflow 3: Capture to Custom Location

```bash
./serial_capture.sh --target esp32s3 --log-dir ~/my-project/logs/
```

---

## Log Retention

### Default Policy

- **Retention**: 30 days
- **Rotation**: When logs exceed 100 MB total
- **Location**: `/var/log/forgepcb/`

### Manual Cleanup

```bash
# Remove logs older than 30 days
find /var/log/forgepcb/ -name "*.log" -mtime +30 -delete

# Remove all logs for a specific target
rm /var/log/forgepcb/esp32s3-*.log
```

### Backup Logs

```bash
# Archive logs before cleanup
tar -czf forgepcb-logs-$(date +%Y%m%d).tar.gz /var/log/forgepcb/*.log
```

---

## Troubleshooting

### Device not found

```
Error: Device not found: /dev/forgepcb-esp32s3
```

**Fix**:
1. Check udev rules are installed
2. Verify device is connected: `ls -l /dev/forgepcb-*`
3. Check USB connection

### Permission denied

```
Error: Permission denied: /dev/ttyACM0
```

**Fix**:
```bash
sudo usermod -a -G plugdev $USER
# Log out and log back in
```

### No output appearing

**Possible causes**:
1. Wrong baud rate
2. Device not running (stuck in boot loop)
3. Device not sending serial output

**Fix**:
- Check baud rate matches firmware: `--baud 921600`
- Manually reset device: press RUN/EN button
- Verify firmware is flashed correctly

---

## Advanced Usage

### Custom Baud Rate

```bash
./serial_capture.sh --target esp32s3 --baud 921600
```

### Raw Output (No Timestamps)

```bash
./serial_capture.sh --target rp2040 --no-timestamp
```

### Pipe to Analysis Tool

```bash
./serial_capture.sh --target esp32s3 --no-timestamp | grep "ERROR"
```

---

## Integration with Provenance

Serial logs are automatically linked to provenance records when using the flash tools.

**After flashing**:
```bash
# Flash creates provenance record
./flash_esp32.sh firmware.bin --build-id abc123

# Serial capture updates provenance with log path
./serial_capture.sh --target esp32s3
# (Ctrl+A then K to stop)

# Check provenance
cat /var/log/forgepcb/provenance/latest-esp32s3.json
```

**Provenance record**:
```json
{
  "target": "esp32s3",
  "build_id": "abc123",
  "flash_time": "2026-02-09T14:00:00Z",
  "serial_log": "/var/log/forgepcb/esp32s3-20260209-140100.log",
  "flash_result": "success"
}
```

---

## Best Practices

1. **Always capture serial after flashing**: Verify firmware boots correctly

2. **Use timestamps**: Default timestamped output helps with debugging timing issues

3. **Keep logs for debugging**: Don't delete logs until you're sure the build is stable

4. **Archive important logs**: Save logs from critical debug sessions

5. **Monitor during development**: Keep serial capture running during iterative development

---

**Document Status**: Complete
**Last Updated**: 2026-02-09
**Author**: Claude Code (Sonnet 4.5)
