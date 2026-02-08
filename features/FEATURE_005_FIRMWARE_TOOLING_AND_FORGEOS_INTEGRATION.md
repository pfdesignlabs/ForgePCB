# Feature F005 — Firmware, Tooling, and ForgeOS Integration

## 1. Feature Mission
Define how ForgePCB integrates with ForgeOS to produce deterministic firmware iteration:
- flashing workflows that are auditable
- serial logging that is captured and attributable
- build provenance that prevents “what is running?” ambiguity
- interruption-resume that preserves execution state
- explicit handling of rail faults and manual human actions as logged events

ForgePCB is a development endpoint, not a runtime controller.

## 2. System Position
- Requires: F001–F004
- Provides execution interface for day-to-day dev and debugging.
- Any change to provenance/logging/identity requirements is a decision-log event.

## 3. Scope Boundary (Hard)
### Included
- USB topology, stable identity, and target selection rules
- Flash orchestration per target class (ESP32-S3, RP2040)
- Serial capture and log storage
- Build metadata capture
- Debug tool integration (logic analyzer via USB)
- Manual human actions logged as events (reset, reseat, power-cycle)
- Tooling behavior under rail fault conditions

### Excluded
- firmware content
- production deployment
- cloud services
- advanced telemetry (v0.2+ optional)

## 4. Frozen Decisions (Invariants)
1. Single upstream USB connection to ForgeOS; internal hub fans out downstream devices.
2. Downstream devices are first-class targets:
   - ESP32-S3 carrier device
   - RP2040 carrier device
   - logic analyzer dongle
   - utility slot (future)
3. Stable USB identity and explicit target selection:
   - each carrier class must be targetable deterministically (e.g., by port topology/udev rules)
   - flashing without explicit target selection is forbidden
   - “last device wins” behavior is forbidden
4. Firmware provenance is mandatory:
   - every flash action must be attributable to source/build/time/target
5. Serial output is captured:
   - logs are stored and associated with build and target
6. Hands-on actions are first-class events:
   - manual reset, reseat, and power-cycle must be logged as human events
   - electrical sensing is optional; process logging is mandatory
7. Fault awareness:
   - rail fault is a hard stop for tooling execution
   - fault clearance requires explicit human acknowledgement
8. Tier 0 observability first:
   - reliable flash + serial capture before optional telemetry

## 5. Structural Decomposition
- USB enumeration and stable identity mapping
- Flash orchestration (per target class)
- Serial capture pipeline
- Build metadata capture and artifact storage
- Debug tool integration (logic analyzer)
- Resume behavior after interruption (state reconstruction)

## 6. Interfaces & Contracts
### ForgePCB → ForgeOS
- Provides stable USB connectivity to targets through hub.
- Physical affordances (buttons) exist and must be reflected by logged human events.

### ForgeOS → ForgePCB
- Executes flash tools and captures logs.
- Stores artifacts in deterministic locations.

### Artifact Contract (Minimum)
For each flash/run:
- target identity
- build identity (commit/build timestamp)
- toolchain identifier (when available)
- serial log file path
- human event log (reset/reseat/power-cycle)
- success/failure outcome

## 7. Execution Constraints
- No flashing outside ForgeOS context.
- No serial debugging without capture.
- If identity is ambiguous, stop and fix identity.
- If rail fault is present, stop until fault is cleared and acknowledged.

## 8. Validation Model
Stable when:
- both targets can be flashed repeatedly with no ambiguity
- serial logs are captured and attributable
- interruptions can be resumed without guessing
- multiple USB devices coexist without manual reconfiguration

## 9. Non-Goals & Anti-Patterns
- IDE lock-in
- hidden tool state
- unlogged auto-detect behavior

## 10. Feature Closure Conditions
Stable when Claude Code can derive execution work items without missing constraints or assumptions.
