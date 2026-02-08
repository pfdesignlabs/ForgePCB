# /status/NEXT.md — What To Do Next

## Status: Feature F002 Implementation Complete ✅

SPRINT_002 has been successfully executed. All work items (WI-007 through WI-019) reached DONE status.

**Completed:**
- ✅ Atopile project structure established (hardware/ directory)
- ✅ Power PCB modules implemented:
  - Input protection and distribution
  - Voltage conversion (24V → 5V @ 5A, 3.3V @ 3A)
  - eFuse protection and UI (3 channels, switches, LEDs, reset)
  - Variable power bay (0-24V @ 3A, banana outputs)
- ✅ DBB modules implemented:
  - Bus headers (I²C, UART, SPI, RS-485)
  - Configuration switches (pull-ups, termination, VLOGIC)
  - Debug corner (16-channel logic analyzer header)
- ✅ System integration complete (Power PCB + DBB top-level)
- ✅ All 11 frozen decisions validated and verified
- ✅ BOM alignment verified (class-level)
- ✅ Interface contracts explicit and traceable
- ✅ Zero architectural unknowns

**Architecture State:**
- Power PCB: Complete electrical definition in Atopile
- DBB: Complete signal backbone definition in Atopile
- Two-PCB architecture enforced via module structure
- All eFuse protection, UX, and bus interfaces implemented
- Feature F002 is FROZEN and ready for downstream work

**Validation Report:**
See SPRINT_002 validation report (all 11 frozen decisions: ✓ PASS)

## Next Action

With Feature F002 electrical architecture complete, multiple paths are now available:

### Path 1: Feature F003 — MCU Carriers and I/O Exposure (Recommended)
Continue electrical architecture work:
- ESP32-S3 carrier module (WROOM/WROVER footprint)
- RP2040 Pico carrier module (Pico footprint)
- GPIO headers and I/O exposure strategy
- Integration with DBB bus headers
- Programming interface definition

**Dependencies:** F002 complete ✓
**Blocks:** F005 (firmware tooling requires MCU carriers)

### Path 2: Feature F004 — Enclosure and Physical Zones
Begin physical execution work:
- Zone definitions (input, conversion, protection, variable bay, headers, debug)
- Mounting strategy (standoffs, rails, PCB placement)
- Cable management (ribbon cables, wire routing)
- Front panel layout (switches, LEDs, connectors, banana jacks)
- Enclosure material and fabrication

**Dependencies:** F002 complete ✓
**Blocks:** None (can proceed in parallel with F003/F005)

### Path 3: Feature F005 — Firmware Tooling and ForgeOS Integration
Software integration work:
- USB hub strategy (auto-flash, programming)
- Telemetry system (power status, fault reporting)
- ForgeOS integration (instrument registration, API)
- UART/I²C bridge for host communication

**Dependencies:** F002 complete ✓, F003 recommended (MCU carriers)
**Blocks:** None

### Path 4: PCB Layout Work (Optional)
Begin PCB layout using Atopile-generated netlists:
- Export Atopile netlist to KiCad or Altium
- Component placement per zone constraints
- Power routing (thick traces, copper pours)
- Signal routing (impedance control for high-speed buses)
- DRC and ERC validation
- Generate Gerbers for manufacturing

**Dependencies:** F002 complete ✓
**Blocks:** Manufacturing (requires layout completion)
**Note:** Can proceed with partial layouts (Power PCB first, DBB second)

## Recommendation

**Proceed with Feature F003 (MCU Carriers)** to complete the electrical architecture before moving to physical/firmware work. This ensures:
1. Complete electrical definition (power + signals + compute)
2. Unified Atopile source ready for layout
3. Firmware interfaces defined early
4. No architectural rework during enclosure/firmware phases

Alternatively, if physical execution is higher priority, **Feature F004 (Enclosure)** can proceed in parallel with F003.

Human should select next feature and update ACTIVE_SLICE.md accordingly.

## Resume Rule
Do not start execution work unless:
- A Claude-generated work item exists
- It is inside the current ACTIVE_SLICE
