# /status/INDEX.md — Single Pane of Glass

## Date
2026-02-09

## Project
ForgePCB

## Active Slice
See: `/ACTIVE_SLICE.md`

## Current Focus
- **Core features complete**: F002, F003, F004, F005 implemented
- **Ready for:**
  - CAD design (enclosure specs ready)
  - PCB layout (Atopile electrical architecture complete)
  - Firmware development (tooling with provenance tracking ready)
- **Next milestone**: Physical execution (CAD, PCB manufacturing)

## Completed Features

### ✅ Feature F002: Power and Signal Subsystems
- Power PCB (input, conversion, protection, variable bay)
- DBB (bus headers, switches, debug corner)
- Complete Atopile electrical architecture
- All 11 frozen decisions validated

### ✅ Feature F003: MCU Carriers and I/O Exposure
- ESP32-S3 DevKit carrier
- RP2040 Pico carrier
- GPIO exposure (16× Dupont + 8× screw terminals)
- All 9 frozen decisions validated

### ✅ Feature F004: Enclosure and Physical Execution
- Complete CAD input documentation (8 files, 2347 lines)
- Zone layout (clean/dirty separation)
- Dimensions and mounting specs
- Cable routing and panel cutouts
- Materials BOM and assembly procedure
- All 8 frozen decisions documented

### ✅ Feature F005: Firmware Tooling and ForgeOS Integration
- Flash tooling (ESP32-S3, RP2040) with mandatory provenance
- Serial capture with timestamps
- Event logging for manual actions
- PlatformIO integration (hybrid approach)
- udev rules for stable USB identity
- All 8 frozen decisions implemented

## Blocking Items
- None

## Latest Decisions
- See `/decisions/DECISIONS.md`

## Next Action
See: `/status/NEXT.md`

## Metrics

**Code Statistics (develop branch):**
- Atopile modules: 11 files (F002 Power + DBB, F003 Carriers)
- Enclosure docs: 8 files, 2347 lines (F004)
- Firmware tooling: 12 files, 2979 lines (F005)
- Total: ~8300+ lines of code and documentation

**Feature Completion:**
- F001: Governance ✅
- F002: Power and Signal ✅
- F003: MCU Carriers ✅
- F004: Enclosure ✅
- F005: Firmware Tooling ✅

**Repository Health:**
- Git workflow: PR-based, clean history
- Branch strategy: feature → develop → main
- Releases: v0.1.0 (F002), v0.2.0 (F002+F003), v0.3.0 (pending)
- Provenance: All work co-authored by Claude Sonnet 4.5
