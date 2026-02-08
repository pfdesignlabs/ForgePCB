# ACTIVE_SLICE.md — Current Active Slice

## Objective
Implement Feature F003 — MCU Carriers and I/O Exposure:
- Define canonical carrier modules for ESP32-S3 DevKit and RP2040 Pico
- Controlled I/O exposure via Dupont headers and screw terminals
- Rigid USB alignment and carrier mechanical envelope
- Canonical GPIO labeling policy
- Integration with ForgePCB power rails (5V, 3.3V, GND)

## In Scope Now
- MCU carrier Atopile module implementation
- ESP32-S3 DevKit class carrier (tray, USB, GPIO, controls)
- RP2040 Pico footprint carrier (tray, USB, GPIO, controls)
- GPIO exposure: 16× Dupont + 8× screw terminals
- Carrier envelope: 80×120 mm with M3 mounting
- Integration with Power PCB and DBB

## Out of Scope Now
- PCB routing and layout
- Firmware implementation
- Universal "fits anything" carriers
- Extra test pads for logic analyzer (DBB handles this)

## Stop Conditions
Stop and log a decision if:
- architecture invariants would change
- connector/power decisions are revised
- canonical board classes change (ESP32-S3 DevKit class or Pico footprint)
