# Feature F004 — Enclosure, Zones, and Physical Execution

## 1. Feature Mission
Define the physical system so ForgePCB behaves like an instrument:
- enforced clean vs dirty zones
- repeatable placement
- accessory ecosystem via T-slot rails
- safe integration of embedded steel + magnetic mat
- print strategy for prototype vs final

The enclosure enforces safe behavior by design.

## 2. System Position
- Requires: F001–F003
- Provides physical constraints for F005 execution workflows.
- Any change to zone policy or voltage accessibility requires a decision log entry.

## 3. Scope Boundary (Hard)
### Included
- Zone layout and enforcement
- Enclosure architecture (not aesthetic styling)
- Internal mounting strategy (PCBs, hub, bay)
- Cable routing constraints
- Accessory attachment strategy (rear + side 2020 rails)
- Embedded steel plate + isolation strategy
- Breadboard placement strategy (2× full-size, locked)

### Excluded
- productization/compliance
- mass production tooling
- cosmetic styling optimization

## 4. Frozen Decisions (Invariants)
1. Zones:
   - Front = clean logic zone (breadboards, carriers, bus access)
   - Rear = dirty power zone (variable bay, high-current wiring)
2. Voltage accessibility:
   - No connectors carrying >5V are accessible from the clean/front zone.
   - All variable bay connectors are rear-only by design.
3. Embedded steel plate:
   - embedded and fully isolated
   - not used as electrical ground
4. Magnetic mat:
   - printer-bed style
   - supports modular placement to reduce chaos
5. Accessory rails:
   - 2020 extrusion at rear + both sides
6. Breadboards:
   - two full-size (~830)
   - swappable but locked position
7. Breadboard electrical constraint:
   - breadboards are limited to 3.3V/5V/GND only
   - variable bay must never feed breadboards
   - any exception requires a decision log entry
8. Printing strategy:
   - prototype: FDM
   - final: resin

## 5. Structural Decomposition
- Enclosure base and internal mounting bosses
- Top surface stack (steel + isolation + mat)
- Front clean zone layout
- Rear dirty zone layout
- Cable routing lanes
- Rail mounting points and accessory standards

## 6. Interfaces & Contracts
### Mechanical
- Must accommodate:
  - Power PCB, DBB, internal USB hub
  - variable bay module rear-mounted
  - two breadboards in clean zone
  - carrier mounting points and access

### Electrical
- No exposed conductive surfaces near wiring.
- Cable routing must avoid crossing over breadboards.

### Process
- Fusion 360 is the source of truth for geometry.
- Physical mockups precede final prints when uncertain.

## 7. Execution Constraints
- Ergonomics beats compactness.
- Enclosure must make safe behavior the easy behavior.
- Any zone re-layout requires decision logging.

## 8. Validation Model
Stable when:
- human can work for extended sessions without re-routing cables
- zones are intuitive and consistently respected
- no accidental short paths exist

## 9. Non-Goals & Anti-Patterns
- front-panel overload and clutter
- hidden connectors that force awkward routes
- mixing high-current wiring with breadboard space

## 10. Feature Closure Conditions
Stable when enclosure constraints no longer force architecture changes and daily use is predictable.
