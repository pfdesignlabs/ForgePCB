# Enclosure Dimensions Specification

Feature F004: Overall enclosure sizing and component layout

## Design Philosophy

**Ergonomics beats compactness** (F004 §7)

The enclosure is sized to:
- Provide comfortable working space for 2× full-size breadboards
- Accommodate all PCBs and modules without cramming
- Allow easy access to all connectors and controls
- Support cable routing without tight bends
- Enable future expansion via 2020 rails

---

## Overall Enclosure Dimensions (Estimated)

These are **preliminary estimates** based on component requirements. Adjust during CAD work as needed.

```
Overall External Dimensions:
┌─────────────────────────────────┐
│  Width:  400-450 mm             │
│  Depth:  350-400 mm             │
│  Height: 120-150 mm             │
└─────────────────────────────────┘

Internal Cavity:
- Width:  ~380-430 mm (minus wall thickness)
- Depth:  ~330-380 mm (minus wall thickness)
- Height: ~100-130 mm (minus base and top surface stack)
```

**Wall Thickness**: 3-5 mm (FDM prototype), 2-4 mm (resin final)

---

## Component Fitment

### 1. Breadboards (2× Full-Size)

**Breadboard Dimensions** (Standard ~830 tie-point breadboard):
- Length: ~165-175 mm
- Width: ~55-65 mm
- Height: ~10 mm (including base)

**Spacing Between Breadboards**: ~20-30 mm (allows wire routing)

**Total Breadboard Area Required**:
- Width: 2 × ~65 mm + 30 mm spacing = ~160 mm
- Depth: ~175 mm
- Add margins: ~20 mm around perimeter

**Breadboard Zone**: ~200 mm (width) × ~195 mm (depth)

---

### 2. MCU Carrier Zone

**Carrier Envelope** (F003 §4.3):
- Width: 120 mm
- Depth: 80 mm
- Height: ~15-25 mm (with devboard installed)

**Mounting**: 4× M3 holes at corners (5 mm edge clearance)

**Clearance Above Carrier**:
- Devboard + USB-C connector: ~20 mm
- Control buttons (EN, BOOT, RUN): Accessible from top

**Total Carrier Zone**: 120 mm × 80 mm + ~10 mm margins = ~130 mm × 90 mm

---

### 3. Power PCB

**Estimated Power PCB Size**:
- Width: 120-150 mm
- Depth: 200-250 mm (long axis for variable bay module)
- Height: ~30-40 mm (tallest components: buck converters, variable bay module)

**Zones on Power PCB**:
- Input section: ~50 mm (connector, fuse, bulk cap)
- Conversion section: ~60 mm (buck converters, heatsinks)
- eFuse/UI section: ~40 mm (eFuses, switches, LEDs)
- Variable bay section: ~80-100 mm (DC-DC module, banana jacks)

**Mounting**: 4× M3 standoffs (15-20 mm height for cable clearance)

---

### 4. DBB (Digital Backbone)

**Estimated DBB Size**:
- Width: 100-120 mm
- Depth: 150-180 mm
- Height: ~20-30 mm (tallest: DIP switches, headers)

**Components**:
- Bus headers: 1×6 to 2×5 Dupont (height ~15 mm)
- DIP switches: ~10 mm height
- Logic analyzer header: 2×12 Dupont (~15 mm)

**Mounting**: 4× M3 standoffs (10-15 mm height)

---

### 5. Variable Bay Module

**Module Dimensions** (Typical adjustable DC-DC module):
- Width: ~60-80 mm
- Depth: ~100-120 mm (with display and controls)
- Height: ~30-40 mm

**Placement**: Rear of Power PCB or separate mounting

**Banana Jack Spacing**: 19 mm (standard)

**Display**: ~40 mm × 20 mm (LED or LCD)

---

### 6. USB Hub

**Hub Module Dimensions** (CH334F or similar 4-port hub):
- Width: ~40-50 mm
- Depth: ~30-40 mm
- Height: ~10-15 mm

**Mounting**: Internal cavity, near DBB

**Cables**:
- Upstream: USB-C or USB-A to host (ForgeOS)
- Downstream: 3× USB connections (ESP32 carrier, Pico carrier, LA dongle)

---

### 7. Top Surface Stack (Steel + Mat)

**Embedded Steel Plate**:
- Dimensions: Match top surface footprint (~380 mm × 330 mm)
- Thickness: 1-2 mm (thin steel sheet)
- Mounting: Embedded in enclosure top, fully isolated

**Isolation Layer**:
- Material: Plastic sheet or enclosure structure
- Thickness: ~2-3 mm (ensures no electrical contact)

**Magnetic Mat**:
- Dimensions: Match steel plate (~380 mm × 330 mm)
- Thickness: ~1-2 mm (printer-bed style PEI or magnetic sheet)
- Mounting: Adhered to top surface or removable

**Total Stack Height**: ~5-8 mm

---

### 8. 2020 Extrusion Rails

**Rail Locations**:
- Rear: 1× horizontal rail (full width)
- Left side: 1× horizontal rail (full depth)
- Right side: 1× horizontal rail (full depth)

**Rail Dimensions**:
- Profile: 2020 (20 mm × 20 mm)
- Length: Match enclosure edges
  - Rear rail: ~400-450 mm
  - Side rails: ~350-400 mm

**Mounting**:
- T-nuts and M5 screws into rails
- Rails attached to enclosure exterior or recessed into sides

**Purpose**:
- Rear: Cable management clips, instrument mounts
- Sides: Probe holders, tool storage, power supply mounts

---

## Internal Layout (Side View)

```
TOP SURFACE
├─ Magnetic Mat (1-2 mm)
├─ Isolation Layer (2-3 mm)
├─ Steel Plate (1-2 mm)
└─ Enclosure Top (3-5 mm)
                                   ↓ ~10 mm total
────────────────────────────────────────────────────
                                   ↓ Clean Zone Workspace
┌─ Breadboard 1 ─┐  ┌─ Breadboard 2 ─┐
│  (~10 mm high) │  │  (~10 mm high) │
└────────────────┘  └────────────────┘
                                   ↓ ~10-15 mm clearance
────────────────────────────────────────────────────
┌─ MCU Carrier ───────────────────┐
│  (80×120 mm, ~20 mm high)       │
└─────────────────────────────────┘
                                   ↓ ~5-10 mm clearance
────────────────────────────────────────────────────
INTERNAL CAVITY (~100-130 mm total height)
├─ DBB PCB (on standoffs, ~20-30 mm)
├─ USB Hub (~10-15 mm)
├─ Power PCB (on standoffs, ~30-40 mm)
├─ Variable Bay Module (~30-40 mm)
└─ Cable routing space (~20 mm)
────────────────────────────────────────────────────
ENCLOSURE BASE (3-5 mm)
────────────────────────────────────────────────────
FEET / STANDOFFS (~10-15 mm, optional)
```

---

## Panel Dimensions

### Front Panel

**Width**: ~400-450 mm (matches enclosure width)
**Height**: ~120-150 mm (matches enclosure height)

**Cutouts**:
- MCU carrier USB-C: 1× USB-C receptacle cutout (~9 mm × 3.5 mm)
- GPIO headers: Accessible from top (no front panel cutout needed)
- Bus headers (optional): Side panel access preferred

**Controls**:
- None on front panel (controls are on carrier top surface)

---

### Rear Panel

**Width**: ~400-450 mm
**Height**: ~120-150 mm

**Cutouts**:
1. **24V Power Input**: Locking DC jack (~15 mm diameter)
2. **Banana Jacks**: 2× holes (~4.5 mm diameter, 19 mm spacing)
3. **Variable Bay Display**: Rectangular cutout (~40 mm × 20 mm) or module flush-mount
4. **Ventilation** (optional): Slots or fan cutout (~60-80 mm)

**LED Indicators** (visible from rear or top):
- Power ON (green)
- 5V FAULT (red)
- 3.3V FAULT (red)
- Variable bay FAULT (red)

---

### Side Panels (Left/Right)

**Depth**: ~350-400 mm
**Height**: ~120-150 mm

**Cutouts** (Left or Right, TBD):
- DBB bus headers: 4× Dupont header access holes
  - I²C: 1×6 (~15 mm × 40 mm)
  - UART: 1×6 (~15 mm × 40 mm)
  - SPI: 2×5 (~30 mm × 20 mm)
  - RS-485: 1×6 (~15 mm × 40 mm)
- DIP switches: Accessible from side or top

**2020 Rails**: Mounted externally or recessed into side panel

---

## Mounting Points

### PCB Mounting

**Standoff Specifications**:
- Thread: M3
- Height: 10-20 mm (depends on PCB and clearance needs)
- Material: Brass or nylon (nylon preferred for isolation)

**Mounting Pattern**:
- Power PCB: 4× M3 holes in corners (5 mm edge clearance)
- DBB: 4× M3 holes in corners
- Carrier: 4× M3 holes at fixed pattern (80×120 mm envelope)

**Insertion Points**:
- Standoffs threaded into brass heat-set inserts in enclosure base
- Or directly screwed into thick enclosure base (FDM with hex cavities)

---

### Breadboard Mounting

**Mounting Method**:
- Locked position (not floating on magnetic mat)
- Options:
  1. Adhesive-backed breadboards stuck to dedicated zones on mat
  2. Breadboard clips or brackets (removable but locked)
  3. 3D-printed breadboard holders (snap-fit or screwed down)

**Swappability**:
- User can remove and replace breadboards (F004 §4.6)
- Position is fixed (prevents accidental movement)

---

### 2020 Rail Mounting

**Attachment**:
- Rear rail: M5 screws into enclosure rear panel or recessed slots
- Side rails: M5 screws into enclosure side panels

**T-Nut Slots**:
- Rails have T-slots for accessories (standard 2020 extrusion)
- User can attach cable clips, probe holders, mounts via T-nuts

---

## Clearances

### Internal Clearances

- **PCB to enclosure walls**: ≥10 mm (allow cable routing)
- **PCB to PCB**: ≥15-20 mm (stacked or side-by-side)
- **Components to enclosure top**: ≥5 mm (avoid contact with steel plate)
- **Cable bend radius**: ≥10 mm (ribbon cables, power wires)

### External Clearances

- **Connectors to enclosure edges**: ≥5 mm (avoid obstruction)
- **Panel cutouts to corners**: ≥10 mm (structural integrity)
- **Ventilation to components**: ≥20 mm (airflow path)

---

## Weight Estimation

**Component Weights** (approximate):
- Power PCB + components: ~300-400 g
- DBB + components: ~150-200 g
- MCU carriers + devboards: ~100-150 g
- Breadboards (2×): ~200-300 g
- Enclosure (FDM): ~800-1200 g
- Enclosure (Resin): ~600-900 g
- Steel plate: ~200-400 g
- Magnetic mat: ~100-150 g
- 2020 rails: ~150-200 g

**Total Estimated Weight**: ~2.5-3.5 kg (varies by material and design)

---

## Tolerance and Fit

### Printing Tolerances (FDM Prototype)

- **Dimensional accuracy**: ±0.2-0.5 mm
- **Hole diameters**: Print 0.2-0.3 mm undersized, ream to fit
- **Snap-fit features**: Design with ~0.3-0.5 mm clearance
- **Threaded inserts**: Use heat-set inserts for M3 standoffs

### Printing Tolerances (Resin Final)

- **Dimensional accuracy**: ±0.1-0.2 mm
- **Hole diameters**: More precise, less reaming needed
- **Surface finish**: Smoother, better for sliding fits
- **Post-curing**: Account for slight shrinkage (~0.5-1%)

### PCB Fit

- **PCB thickness**: 1.6 mm (standard)
- **Standoff clearance**: Allow ±0.5 mm for PCB manufacturing tolerances
- **Component height**: Measure actual components, add 2-3 mm margin

---

## Design Notes for CAD Work

1. **Start with internal components**: Model PCBs, breadboards, carriers first
2. **Verify clearances**: Ensure all components fit with margins
3. **Panel cutouts**: Align USB-C, banana jacks, headers precisely
4. **Cable routing**: Design dedicated lanes (avoid crossing breadboards)
5. **Ventilation**: Add slots or fan mounts for airflow (buck converters, variable bay)
6. **Assembly sequence**: Ensure enclosure can be assembled/disassembled
7. **Fasteners**: Use consistent M3 screws (PCBs), M5 screws (rails)
8. **Accessibility**: All user-accessible connectors should be easy to reach

---

## Validation Checklist

Before finalizing dimensions:

- [ ] All PCBs fit with ≥10 mm clearance to walls
- [ ] 2× full-size breadboards fit in clean zone
- [ ] MCU carrier mounting points accessible (80×120 mm envelope)
- [ ] USB-C cutouts align with carrier USB connectors
- [ ] Rear panel cutouts align with 24V input, banana jacks, display
- [ ] Internal cavity height accommodates tallest component (variable bay module ~40 mm)
- [ ] Cable routing has ≥20 mm clearance lanes
- [ ] Steel plate + magnetic mat fit within top surface dimensions
- [ ] 2020 rails fit along rear and side edges
- [ ] Overall enclosure is ergonomic (not too large or too small)

---

## References

- Feature F002: Power PCB and DBB component sizes
- Feature F003 §4.3: Carrier envelope (80×120 mm)
- Feature F004 §4.6: Breadboards (2× full-size, ~830)
- Feature F004 §4.3: Embedded steel plate
- Feature F004 §4.5: 2020 rails

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
**Author**: Claude Code (Sonnet 4.5)
