# Feature F003 — MCU Carriers and Input/Output Exposure

## 1. Feature Mission
Define how MCU devboards integrate into ForgePCB with repeatable, low-chaos IO:
- canonical board classes
- controlled IO exposure (Dupont + terminals)
- rigid USB alignment
- stable human factors (buttons, labels)
- a single canonical labeling model that tooling and humans share

The carrier is a contract interface, not a convenience breakout.

## 2. System Position
- Requires: F001, F002
- Feeds: F004 (Enclosure), F005 (Tooling)
- Changes to board classes, GPIO index, or identity policy require a decision log entry.

## 3. Scope Boundary (Hard)
### Included
- Carrier mechanical envelope and mounting
- Canonical devboard classes
- IO exposure and canonical labeling policy
- Control access policy (EN/BOOT/RUN)
- Rigid USB alignment rules and identity assumptions

### Excluded
- Firmware
- Universal “fits anything” carriers
- Extra test pads for logic analyzer (DBB-only)

## 4. Frozen Decisions (Invariants)
1. Route A carriers: devboards dock into trays; carriers do not host MCU silicon.
2. Canonical boards:
   - ESP32-S3 DevKit class
   - RP2040 Pico footprint
3. Carrier envelope: 80×120 mm with 4× M3 fixed mounting.
4. USB:
   - USB-C, rigidly aligned to enclosure cutout
   - no internal USB pigtails
5. GPIO exposure:
   - 16 GPIO via Dupont header bank
   - 8 GPIO via screw terminals (subset of Dupont)
   - 2× GND terminals near terminal bank
6. Terminal role mapping:
   - T1–T4: digital/high-drive candidates
   - T5–T8: analog/input candidates
7. Controls:
   - ESP32-S3: EN + BOOT accessible
   - RP2040 Pico: RUN accessible
8. No extra test pads for LA: debug is DBB-centric.
9. Canonical labeling:
   - The carrier silkscreen/labels define the canonical GPIO index.
   - DBB and tooling MUST NOT reinterpret or rename GPIOs.
   - GPIO index is semantic and stable across carrier types (index is not MCU pin number).

## 5. Structural Decomposition
- Tray mechanics and retention
- USB alignment and strain control
- GPIO fan-out and labeling (Dupont + terminals)
- Control accessibility

## 6. Interfaces & Contracts
### Mechanical
- Fixed mounting pattern for repeatability.
- Tray tolerances must accommodate minor board revisions within class.

### Electrical
- Carriers consume only ForgePCB rails (5V / 3.3V / GND).
- No implicit level shifting.

### Logical / Tooling
- Tooling references targets by carrier class + stable identity and by canonical GPIO index.

## 7. Execution Constraints
- Do not add extra headers without decision log.
- Validate rigid USB alignment with physical prototypes before locking geometry.

## 8. Validation Model
Stable when:
- both carriers fit and mount cleanly
- USB devices enumerate reliably via the internal hub
- IO labeling is unambiguous and reproducible
- control buttons are accessible without disassembly

## 9. Non-Goals & Anti-Patterns
- universal adjustable trays
- ambiguous or duplicated labeling

## 10. Feature Closure Conditions
Stable when carriers can be used daily without re-learning wiring and without accidental miswiring risk.
