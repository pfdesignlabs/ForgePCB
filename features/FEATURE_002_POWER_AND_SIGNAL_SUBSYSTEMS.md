# Feature F002 — Power and Signal Subsystems

## 1. Feature Mission
Define ForgePCB’s electrical backbone as a safe, debug-first lab instrument:
- clean fixed rails (3.3V, 5V)
- dirty/high-power variable bay
- deterministic protection behavior (eFuses)
- standardized bus access (I²C, UART, SPI, RS-485)
- logic analyzer integration as a core capability

## 2. System Position
- Requires: F001
- Provides interfaces for: F003 (Carriers), F004 (Enclosure), F005 (Tooling)
- Any change in rails/connector policy is a decision-log event.

## 3. Scope Boundary (Hard)
### Included
- Power PCB architecture
- Signal/Backbone PCB (DBB) architecture
- Variable power bay constraints
- UX rules for rail enable/fault
- Bus header strategy and RS-485 configuration
- Logic analyzer access

### Excluded
- PCB routing/layout
- EMC compliance work
- Firmware
- Telemetry v0.2 implementation details (optional future)

## 4. Frozen Decisions (Invariants)
1. External 24V power brick: 24V, 10A (~240W), no mains inside enclosure.
2. Two PCB split: Power PCB (high-current) + DBB (signal/backbone).
3. Protection: eFuse on 5V, 3.3V, and variable bay output.
4. Rails:
   - 5V capability: 5A
   - 3.3V capability: 3A
   - No fixed 12V rail; 12V comes from variable bay as needed.
5. Breadboard policy: breadboards get only 3.3V/5V/GND (never 12/24).
6. Variable bay: 0–24V, 3A, display module with its own enable, banana outputs, downstream eFuse safety cutoff.
7. UX:
   - Rail enable via rocker switch controlling eFuse enable
   - ON and FAULT indicators per rail
   - Reset to clear latch-off
8. DBB bus headers: Dupont-only for bus headers; separate blocks per bus.
9. RS-485 on DBB:
   - termination on/off via switches
   - bias on/off via switches
   - VLOGIC 3.3V/5V selectable via switches
10. Logic analyzer:
   - external dongle
   - 16-channel header in a dedicated debug corner
11. Power distribution: multiple taps (left/right) for breadboards plus feed to DBB.

## 5. Structural Decomposition
- Input and main protection
- Fixed rails conversion and distribution
- eFuse policy and UI
- Variable bay and safety cutoff
- DBB bus access and configuration
- Debug corner (logic analyzer)

## 6. Interfaces & Contracts
### Electrical
- Power PCB outputs: 5V rail, 3.3V rail, fault lines.
- DBB consumes: 5V, 3.3V, GND.
- DBB provides: bus headers + RS-485 config + LA header.

### Mechanical
- Variable bay is positioned in the rear “dirty power” zone.
- Clean/dirty zones are physically enforced by enclosure design.

## 7. Execution Constraints
- Do not expose >5V in the clean/front zone.
- Do not route high-current paths near sensitive bus headers on DBB.
- Do not “temporarily” expose 24V near breadboards.

## 8. Validation Model
Stable when:
- power topology is complete and consistent
- DBB interfaces are explicit
- safety behavior (fault if short) is unambiguous
- BOM can be produced without guessing

## 9. Non-Goals & Anti-Patterns
- “One big PCB does everything”
- “We will add protection later”

## 10. Feature Closure Conditions
Stable when ready for Atopile schematic generation and enclosure integration without architectural unknowns.
