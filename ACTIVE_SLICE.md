# ACTIVE_SLICE.md — Current Active Slice

## Status: Core Features Complete ✅

All foundational features (F002-F005) have been successfully implemented.

## Completed Work

### Feature F002: Power and Signal Subsystems ✅
- Atopile electrical architecture complete
- Power PCB (input, conversion, protection, variable bay)
- DBB (bus headers, switches, debug corner)
- All 11 frozen decisions validated

### Feature F003: MCU Carriers and I/O Exposure ✅
- ESP32-S3 DevKit carrier module
- RP2040 Pico carrier module
- GPIO exposure (16× Dupont + 8× screw terminals)
- Carrier envelope (80×120 mm with M3 mounting)
- All 9 frozen decisions validated

### Feature F004: Enclosure and Physical Execution ✅
- Complete CAD input documentation (8 files, 2347 lines)
- Zone layout (clean/dirty separation)
- Dimensions (~400-450mm × 350-400mm × 120-150mm)
- Mounting, cable routing, panel cutouts
- Materials BOM and assembly procedure
- All 8 frozen decisions documented

### Feature F005: Firmware Tooling and ForgeOS Integration ✅
- Flash tooling (ESP32-S3, RP2040) with mandatory provenance
- Serial capture with timestamps and log files
- Event logging for manual actions
- PlatformIO integration (hybrid approach)
- udev rules for stable USB identity
- All 8 frozen decisions implemented

## Next Actions (Human Decision Required)

ForgePCB is now ready for **physical execution**. User should choose next path:

1. **CAD Design** (Recommended): Design enclosure in Fusion 360 using `/enclosure/docs/` specs
2. **PCB Layout**: Export Atopile netlist, layout Power PCB + DBB in KiCad/Altium
3. **Firmware Development**: Write firmware using `/firmware/` tooling with provenance
4. **Integration Testing**: Assemble prototype and validate all subsystems

## Current Scope
**No active implementation work**

User is proceeding with CAD design (hands-on work, outside Claude Code scope).

## Repository State
- **Develop**: F002, F003, F004, F005 merged (~8300+ lines)
- **Main**: v0.2.0 (F002 + F003)
- **Pending**: Release v0.3.0 (F002 + F003 + F004 + F005)

## Date
2026-02-09
