# Mounting Specification

Feature F004: PCB and module mounting strategy

## Overview

All internal components mount securely with repeatable placement using M3 standoffs and heat-set inserts.

## PCB Mounting

### Power PCB
- **Standoffs**: 4× M3, height 15-20 mm
- **Pattern**: Corners with 5 mm edge clearance
- **Clearance below**: ≥10 mm (cable routing)
- **Orientation**: Long axis rear-to-front

### DBB
- **Standoffs**: 4× M3, height 10-15 mm
- **Pattern**: Corners with 5 mm edge clearance
- **Placement**: Mid-section, accessible from side for headers

### MCU Carriers
- **Mounting**: 4× M3 holes at fixed pattern
- **Envelope**: 80 mm × 120 mm (F003 §4.3)
- **Height**: Top-mounted on magnetic mat area
- **Accessibility**: USB-C aligned to front panel cutout

## Breadboard Mounting
- **Method**: Locked position with clips or adhesive
- **Swappable**: Yes (F004 §4.6)
- **Position**: Fixed zones on magnetic mat
- **Quantity**: 2× full-size (~830 tie points each)

## Variable Bay Module
- **Mounting**: Rear of Power PCB or separate bracket
- **Access**: Rear panel (banana jacks, display)
- **Clearance**: ≥30 mm height for module

## USB Hub
- **Mounting**: Internal bracket or PCB standoffs
- **Placement**: Near DBB, central for cable routing
- **Height**: ~10-15 mm

## Fastener Specifications
- **PCBs**: M3 × 6-8 mm screws into heat-set inserts
- **Rails**: M5 × 10-12 mm screws
- **Panels**: M3 × 6 mm screws (if removable panels)

## Heat-Set Inserts
- **Size**: M3 × 5-6 mm (length) × 4-5 mm (OD)
- **Installation**: Heat gun or soldering iron, press into FDM plastic
- **Material**: Brass (preferred for durability)

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
