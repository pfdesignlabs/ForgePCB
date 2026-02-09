# /status/NEXT.md — What To Do Next

## Status: Core Features Complete ✅

All foundational features (F002-F005) have been successfully implemented:

- ✅ **F002**: Power and Signal Subsystems (Atopile electrical architecture)
- ✅ **F003**: MCU Carriers and I/O Exposure (ESP32-S3, RP2040)
- ✅ **F004**: Enclosure and Physical Execution (CAD input documentation)
- ✅ **F005**: Firmware Tooling and ForgeOS Integration (flash + provenance)

**Total Implementation:**
- ~8300+ lines of code and documentation
- 4 features implemented across 4 sprints
- All frozen decisions validated and documented
- Zero architectural unknowns

---

## Current State

### Electrical Architecture (Complete)
**Atopile Source Files:**
- Power PCB: input, conversion (5V/3.3V), protection (eFuses), variable bay (0-24V)
- DBB: bus headers (I²C, UART, SPI, RS-485), switches, debug (16-ch LA)
- MCU Carriers: ESP32-S3, RP2040 Pico with GPIO exposure

**Status:** Ready for PCB layout (can export netlist to KiCad/Altium)

### Enclosure Design (Documentation Complete)
**CAD Input Specs:**
- Zone layout (clean ≤5V front, dirty up to 24V rear)
- Dimensions (~400-450mm × 350-400mm × 120-150mm)
- Mounting (M3 standoffs, heat-set inserts, 2020 rails)
- Cable routing, panel cutouts, materials BOM, assembly

**Status:** Ready for CAD design in Fusion 360

### Firmware Tooling (Complete)
**Infrastructure:**
- Flash scripts: ESP32-S3 (esptool), RP2040 (UF2/picotool)
- Serial capture with timestamps and provenance linking
- Event logging for manual actions
- PlatformIO integration (hybrid approach)
- udev rules for stable USB identity (/dev/forgepcb-*)

**Status:** Ready for firmware development

---

## Next Actions (Human Decision Required)

ForgePCB is now ready for **physical execution**. Choose one or more paths:

### Path 1: CAD Design (Enclosure) 🎯 **RECOMMENDED FOR USER**
**Who:** User (pfdesignlabs)
**Tool:** Fusion 360
**Input:** `/enclosure/docs/` (8 comprehensive spec files)

**Steps:**
1. Design enclosure shell (FDM prototype: PLA/PETG, 3-5mm walls)
2. Add panel cutouts (USB-C, banana jacks, bus headers)
3. Add mounting points (M3 heat-set inserts for PCBs)
4. Embed steel plate cavity (380×330mm, isolated)
5. Add 2020 rail mounting (rear + sides)
6. Design cable routing channels
7. Export STLs for 3D printing

**Deliverable:** 3D-printable enclosure (FDM prototype, resin final later)

---

### Path 2: PCB Layout (Electrical)
**Who:** User or contractor
**Tool:** KiCad, Altium, or Eagle
**Input:** `/hardware/` Atopile source files

**Steps:**
1. Export Atopile netlist: `ato build hardware/forgepcb.ato`
2. Import netlist to PCB layout tool
3. Place components per zone constraints (F004 ZONES.md)
4. Route power (thick traces, 24V/5V/3.3V rails)
5. Route signals (bus headers, GPIO, control lines)
6. Add copper pours (GND, power planes)
7. DRC/ERC validation
8. Generate Gerbers for manufacturing

**Deliverable:** Manufacturing-ready PCB Gerbers (Power PCB + DBB)

---

### Path 3: Firmware Development
**Who:** User
**Tool:** PlatformIO, ESP-IDF, Pico SDK, Arduino IDE
**Input:** `/firmware/` tooling scripts

**Steps:**
1. Install udev rules: `sudo cp firmware/configs/udev/99-forgepcb.rules /etc/udev/rules.d/`
2. Create PlatformIO project (or use native toolchain)
3. Write firmware (ESP32-S3 or RP2040)
4. Build: `pio run` (or `idf.py build`, etc.)
5. Flash with provenance: `firmware/tools/flash_esp32.sh build/firmware.bin --build-id $(git rev-parse HEAD)`
6. Monitor: `firmware/tools/serial_capture.sh --target esp32s3`

**Deliverable:** Working firmware with provenance tracking

---

### Path 4: Integration Testing
**Who:** User
**Prerequisites:** CAD enclosure printed, PCBs manufactured, firmware flashed

**Steps:**
1. Assemble enclosure (follow `/enclosure/docs/ASSEMBLY.md`)
2. Install PCBs (Power PCB, DBB, carriers)
3. Route cables (power distribution, USB hub, bus headers)
4. Power-on test (24V input, rail voltage checks, eFuse tests)
5. Flash both carriers (ESP32-S3, RP2040) and verify provenance
6. Test bus headers (I²C, UART, SPI, RS-485)
7. Test logic analyzer (16-channel capture)
8. Validate zone separation (no >5V in clean zone)

**Deliverable:** Fully functional ForgePCB prototype

---

## Recommended Next Step

**User should proceed with CAD design (Path 1)** using the enclosure documentation in `/enclosure/docs/`.

This is the most logical next step because:
1. ✅ All specs are complete and ready for CAD
2. ✅ User has Fusion 360 expertise
3. ✅ FDM printing enables rapid iteration
4. ✅ CAD can proceed independently (no dependencies)
5. ✅ Once enclosure is designed, PCB layout can finalize dimensions

**Meanwhile, Claude Code can:**
- Assist with any spec clarifications during CAD work
- Review CAD design for compliance with F004 frozen decisions
- Help with PCB layout (if user wants to proceed in parallel)
- Assist with firmware development

---

## Outstanding Work (Optional/Future)

### Nice-to-Have Features (Not Defined Yet)
- Advanced telemetry (power monitoring, usage stats)
- Web UI for ForgeOS integration
- Multi-ForgePCB orchestration
- Automated testing harness

### Manufacturing Preparation
- PCB assembly instructions (once layout is done)
- Enclosure assembly video/guide (once CAD is done)
- BOM consolidation (combine electrical + mechanical BOMs)
- Supplier sourcing (PCB fab, components, 2020 rails, etc.)

---

## Resume Rule

**For User (CAD Work):**
- Proceed with Fusion 360 using `/enclosure/docs/` as input
- No need to update ACTIVE_SLICE (CAD is hands-on work)
- Consult Claude Code if questions arise during CAD

**For Claude Code (Future Work):**
- Do not start new execution work unless:
  - A new Feature is defined (F006+)
  - User explicitly requests assistance
  - A bug or issue is discovered in existing work

---

## Project Health Summary

**Status:** ✅ **HEALTHY** - All core features complete, ready for physical execution

**Risks:** None blocking

**Dependencies:** None blocking

**Next Milestone:** First physical prototype (CAD + PCB + firmware integration)
