# ACTIVE_SLICE.md — Current Active Slice

## Objective
Bootstrap ForgePCB execution and Git topology:
- Features F001–F005 are authoritative and frozen
- ForgePCB repository exists as source of truth
- ForgeOS consumes ForgePCB via subtree at components/forgepcb/
- Ready for Claude Code to derive and execute work items safely

## In Scope Now
- Repository creation and Git initialization for ForgePCB
- Subtree integration into ForgeOS
- Governance text updates related to Git topology
- Preparation for Atopile work (no PCB layout/routing)

## Out of Scope Now
- PCB routing and layout
- Purchasing and assembly
- Firmware implementation
- Telemetry v0.2 work

## Stop Conditions
Stop and log a decision if:
- architecture invariants would change
- connector/power decisions are revised
- canonical board classes change (ESP32-S3 DevKit class or Pico footprint)
