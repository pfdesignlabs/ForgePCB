# ForgePCB Enclosure

Feature F004: Enclosure, Zones, and Physical Execution

## Directory Structure

```
enclosure/
├── README.md                   # This file - enclosure overview
├── docs/                       # Specifications and documentation
│   ├── ZONES.md               # Zone layout (clean/dirty zones)
│   ├── DIMENSIONS.md          # Overall enclosure dimensions
│   ├── MOUNTING.md            # PCB/module mounting specifications
│   ├── CABLE_ROUTING.md       # Cable management rules
│   ├── PANEL_CUTOUTS.md       # Front/rear panel specifications
│   ├── MATERIALS_BOM.md       # Enclosure materials BOM
│   └── ASSEMBLY.md            # Assembly procedure
└── cad/                       # CAD files (Fusion 360, STLs, etc.)
    ├── fusion360/             # Fusion 360 source files
    ├── step/                  # STEP export files
    ├── stl/                   # STL files for 3D printing
    └── drawings/              # Technical drawings (PDF)
```

## Overview

ForgePCB enclosure enforces safe behavior by design through physical zone separation and controlled voltage accessibility.

### Key Design Principles

1. **Zone Separation**: Clean (front) vs Dirty (rear) zones physically enforced
2. **Voltage Safety**: No >5V accessible from front/clean zone
3. **Ergonomics First**: Safe behavior is easy behavior
4. **Modular Placement**: Magnetic mat + steel plate for flexible component placement
5. **Accessory Ecosystem**: 2020 rails for expandability

### Frozen Decisions (F004 §4)

- **Zones**: Front = clean logic, Rear = dirty power
- **Voltage accessibility**: No >5V in clean/front zone
- **Embedded steel plate**: Isolated, not electrical ground
- **Magnetic mat**: Printer-bed style, modular placement
- **Accessory rails**: 2020 extrusion (rear + sides)
- **Breadboards**: 2× full-size (~830 points), locked position
- **Breadboard constraint**: Only 3.3V/5V/GND, never variable bay
- **Printing strategy**: Prototype = FDM, Final = Resin

## Components Housed

### Power PCB Zone (Internal, rear)
- Power PCB (input, conversion, eFuse, variable bay)
- 24V power brick connector (rear panel)
- Variable bay banana jacks (rear panel)
- Variable bay display module (rear panel or top)

### Signal Zone (Internal, mid)
- DBB (Digital Backbone) PCB
- Internal USB hub
- Cable routing from Power PCB to DBB

### Carrier Zone (Top surface, clean)
- MCU carrier mounting points (80×120 mm, M3 holes)
- ESP32-S3 or RP2040 Pico carrier installed
- USB-C connector aligned to front panel

### Front Clean Zone (Top surface)
- 2× full-size breadboards (~830 points each)
- Magnetic mat for modular component placement
- Bus headers access (I²C, UART, SPI, RS-485)
- GPIO headers and screw terminals
- Logic analyzer header

### Rear Dirty Zone
- Variable power bay outputs (banana jacks)
- 24V power input connector
- High-current cable routing

## Design Constraints

### Safety
- No exposed >5V in front/clean zone
- Cable routing avoids crossing over breadboards
- No exposed conductive surfaces near wiring
- Embedded steel plate fully isolated from electrical paths

### Ergonomics
- All frequently accessed connectors on front or side
- Breadboards at comfortable working height
- Headers accessible without disassembly
- Clear visual zone separation

### Thermal
- Adequate ventilation for buck converters
- Variable bay module heat dissipation
- Air flow paths defined

## CAD Workflow

1. **Source of Truth**: Fusion 360 (files in `cad/fusion360/`)
2. **Physical Mockups**: Build cardboard/foam mockups when uncertain
3. **Export Formats**:
   - STEP files for interoperability (`cad/step/`)
   - STL files for 3D printing (`cad/stl/`)
   - PDF drawings for reference (`cad/drawings/`)
4. **Printing**:
   - Prototype: FDM (PLA or PETG)
   - Final: Resin (higher detail, better surface finish)

## Next Steps

1. Read all documentation in `docs/`
2. Use specifications to create CAD model in Fusion 360
3. Export STLs for prototype printing
4. Validate fit with physical PCBs and modules
5. Iterate based on physical testing
6. Final resin prints when geometry is stable

## Related Features

- **F002**: Power and Signal Subsystems (PCB dimensions, connectors)
- **F003**: MCU Carriers (80×120 mm envelope, M3 mounting)
- **F005**: Firmware Tooling (USB hub placement, cable routing)

## Status

- **Documentation**: Complete (SPRINT_004)
- **CAD Modeling**: Ready to begin (use specs in `docs/`)
- **Prototyping**: Pending CAD completion
- **Final Fabrication**: Pending prototype validation
