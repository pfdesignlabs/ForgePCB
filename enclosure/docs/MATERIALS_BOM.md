# Materials Bill of Materials (Enclosure)

Feature F004: Enclosure materials and components

## Overview

This document specifies all materials, components, and fasteners required to fabricate and assemble the ForgePCB enclosure. It complements the electrical BOM (`/BOM.md`) and focuses exclusively on mechanical/structural components.

---

## Enclosure Shell

### FDM Prototype (Initial Build)

**Material**: PLA or PETG
- **PLA**: Easier to print, good dimensional accuracy, lower cost
  - Print temp: 200-220°C
  - Bed temp: 60°C
  - Suitable for low-stress prototyping
- **PETG**: Higher strength, better heat resistance, more durable
  - Print temp: 230-250°C
  - Bed temp: 80-90°C
  - Recommended for functional prototype

**Wall Thickness**: 3-5 mm (standard FDM walls)

**Infill**: 20-30% (structural sections), 15% (non-structural)

**Print Settings**:
- Layer height: 0.2-0.3 mm
- Perimeters: 3-4 walls
- Top/bottom layers: 5-6 layers
- Support: Minimal (design for printability)

**Estimated Print Time**: 40-60 hours (depending on printer and enclosure size)

**Estimated Filament**: 1.5-2.5 kg total

**Color Suggestions**:
- Main body: Black or dark gray (professional look)
- Front panel: Optional contrasting color (e.g., white for clean zone)

---

### Resin Final Build (Production Quality)

**Material**: Tough resin or ABS-like resin
- **Tough Resin** (e.g., Formlabs Tough 2000, Elegoo ABS-like):
  - High impact resistance
  - Good dimensional stability
  - Smooth surface finish
- **Standard Resin**: Lower cost, suitable for non-stressed parts
  - Use for panels, covers, non-structural components

**Wall Thickness**: 2-4 mm (resin allows thinner walls than FDM)

**Print Settings**:
- Layer height: 0.05-0.1 mm (high resolution)
- Orientation: Minimize supports on visible surfaces
- Post-cure: UV curing for 30-60 minutes (per resin datasheet)

**Estimated Print Time**: 20-40 hours (depending on printer build volume)

**Estimated Resin**: 1-2 liters total (depends on part count and hollowing)

**Post-Processing**:
- Support removal
- IPA wash (2-stage recommended)
- UV post-cure
- Light sanding (optional, for ultra-smooth finish)

**Color**: Black, gray, or transparent (for rear panel with LEDs visible)

---

## Structural Components

### 2020 Aluminum Extrusion Rails

**Profile**: 2020 (20 mm × 20 mm) aluminum extrusion
**Type**: Standard T-slot profile (single slot per face)

**Lengths Required**:
- **Rear rail**: 1× ~400-450 mm (match enclosure width)
- **Left side rail**: 1× ~350-400 mm (match enclosure depth)
- **Right side rail**: 1× ~350-400 mm (match enclosure depth)

**Total**: ~1100-1250 mm linear length

**Material**: 6063-T5 aluminum (standard extrusion alloy)

**Finish**: Anodized black (preferred) or mill finish

**Suppliers**:
- Misumi (cut to length, pre-tapped ends optional)
- 80/20 Inc. (standard lengths, cut-to-size service)
- Amazon/AliExpress (economy option, verify profile compatibility)

**Accessories Needed**:
- T-nuts (M5): 12-20× (for mounting accessories)
- End caps: 6× (optional, for clean look)
- Corner brackets: 0-4× (optional, if rails form a frame)

---

### Embedded Steel Plate (Magnetic Surface)

**Dimensions**: Match top surface footprint (~380 mm × 330 mm, adjust to CAD)

**Thickness**: 1-2 mm (thin sheet steel)

**Material**: Mild steel (A36 or equivalent)
- **Not** stainless steel (non-magnetic)
- **Not** galvanized (if using adhesive, check compatibility)

**Finish**:
- Option 1: Powder-coated or painted (prevents rust, isolates electrically)
- Option 2: Bare steel with isolation layer (enclosure plastic provides isolation)

**Supplier**:
- Local metal supplier (cut to size)
- Online metal cutting service (e.g., SendCutSend, OSH Cut)
- Hardware store sheet metal (cut with shears or angle grinder)

**Mounting**:
- Embedded into enclosure top surface during printing (FDM: pause and insert)
- Or adhered with strong adhesive (e.g., epoxy, double-sided tape)

**Critical Constraint**: Plate MUST be fully isolated from electrical paths (F004 §4.3). Ensure ≥2 mm plastic layer between steel and any conductive component.

---

### Magnetic Mat (Top Surface)

**Dimensions**: Match steel plate (~380 mm × 330 mm)

**Thickness**: 1-2 mm

**Material Options**:

1. **PEI Spring Steel Sheet** (3D printer bed style):
   - Flexible, removable
   - Magnetic backing pre-applied
   - Smooth PEI surface (ideal for breadboards)
   - Example: Prusa/Creality replacement bed sheets
   - Cut to size with heavy scissors or utility knife

2. **Magnetic Rubber Sheet**:
   - Adhesive-backed magnetic sheet
   - More flexible, less rigid than PEI
   - Suitable for non-removable installation
   - Cut to size easily

3. **Custom Magnetic Mat**:
   - Thin silicone or rubber mat with embedded magnets
   - Provides grip and magnetic hold
   - Laser-cut or die-cut to size

**Recommended**: PEI spring steel sheet (best rigidity and surface quality)

**Mounting**:
- Adhered to steel plate with strong double-sided adhesive
- Or friction-fit if using PEI spring steel (magnetic attraction holds it)

**Suppliers**:
- 3D printing suppliers (for PEI sheets)
- Hardware stores (for magnetic rubber sheet)
- Industrial suppliers (for custom magnetic materials)

---

## Fasteners

### PCB Mounting

**M3 × 6-8 mm Screws** (PCB to standoffs):
- Quantity: 16-20× (4 per PCB × 3-4 PCBs + spares)
- Type: Pan head or button head (low profile)
- Material: Stainless steel or black oxide steel
- Thread: Fully threaded

**M3 Heat-Set Inserts** (embedded in enclosure base):
- Quantity: 16-20×
- Dimensions: M3 × 5-6 mm (length) × 4-5 mm (OD)
- Material: Brass (preferred for durability)
- Installation: Heat gun or soldering iron (set to ~200-220°C for PLA/PETG)

**M3 Nylon Standoffs** (PCB elevation):
- Quantity: 16-20×
- Heights needed:
  - 10-15 mm (DBB, USB hub)
  - 15-20 mm (Power PCB, for cable clearance)
- Type: Female-female threaded standoffs
- Material: Nylon (electrical isolation) or brass (if grounding needed)

---

### Rail Mounting

**M5 × 10-12 mm Screws** (rails to enclosure):
- Quantity: 12-16× (4-6 per rail × 3 rails)
- Type: Button head or flat head (countersunk if rail has countersunk holes)
- Material: Stainless steel or black oxide steel
- Thread: Fully threaded or partial thread (depending on rail attachment method)

**M5 T-Nuts** (for 2020 rail slots):
- Quantity: 12-20× (for mounting accessories to rails)
- Type: Spring-loaded T-nuts (easier to install) or standard sliding T-nuts
- Material: Carbon steel with zinc plating

**Alternative**: If rails are recessed into enclosure walls, use M5 heat-set inserts in enclosure + M5 screws.

---

### Panel Mounting (Optional, if removable panels)

**M3 × 6 mm Screws** (panel to enclosure):
- Quantity: 12-20× (depends on panel count and mounting points)
- Type: Pan head or countersunk (flush-mount)
- Material: Stainless steel or black oxide steel

**M3 Heat-Set Inserts** (panel mounting points):
- Quantity: 12-20×
- Same spec as PCB mounting inserts

---

### Breadboard Mounting (Optional, if using clips)

**M3 × 6 mm Screws** (clips to enclosure):
- Quantity: 8-12×
- Type: Pan head
- Material: Stainless steel

**3D-Printed Breadboard Clips** (if not using adhesive):
- Quantity: 4-6× clips (2-3 per breadboard)
- Material: PLA or PETG (same as enclosure)
- Design: Snap-fit or screw-down style

---

### Enclosure Feet (Optional)

**Rubber Bumpers** (stick-on feet):
- Quantity: 4-6×
- Dimensions: 10-15 mm diameter × 5-10 mm height
- Type: Adhesive-backed rubber or silicone
- Purpose: Prevent scratching, improve stability

**Or 3D-Printed Feet**:
- Quantity: 4×
- Material: TPU (flexible) or PLA/PETG with rubber pads
- Height: 10-15 mm

---

## Cable Management Accessories

### Cable Clips (3D Printed)

**Quantity**: 10-20×
**Type**: Snap-fit clips for 2020 rail T-slots
**Material**: PLA or PETG
**Design**: For ribbon cables, individual wires, or USB cables
**Sizes**: Various (for different cable diameters)

**Alternative**: Commercial cable clips compatible with 2020 extrusion

---

### Zip Ties / Cable Ties

**Quantity**: 20-30×
**Sizes**:
- Small (100-150 mm): Signal cables, USB cables
- Medium (200-250 mm): Power cables, ribbon harnesses
- Large (300+ mm): Bundling multiple cables

**Type**: Reusable zip ties preferred (easier to rework)

---

### Rubber Grommets (Panel Exits)

**Quantity**: 4-8×
**Sizes**: Match panel cutout holes (e.g., 10-15 mm ID for USB-C routing)
**Purpose**: Strain relief and protection for cables exiting enclosure
**Material**: Rubber or silicone

---

## Adhesives and Bonding

### Strong Adhesive (Steel Plate, Magnetic Mat)

**Type**: 2-part epoxy or industrial double-sided tape

**Epoxy** (permanent bond):
- Example: J-B Weld, Gorilla Epoxy
- Cure time: 24 hours
- Use for steel plate to enclosure (if not embedded during print)

**Double-Sided Tape** (removable option):
- Example: 3M VHB tape
- Thickness: 1-2 mm
- Use for magnetic mat to steel plate (easier to replace mat if needed)

---

### IPA (Isopropyl Alcohol) for Resin Cleaning

**Quantity**: 1-2 liters (for resin builds)
**Concentration**: 90-99% IPA
**Purpose**: Washing uncured resin from printed parts

---

## Labels and Silkscreen

### Rear Panel Labels

**Option 1: Vinyl Decals**
- Printed vinyl stickers (waterproof, UV-resistant)
- Text:
  - "24V DC INPUT 10A MAX"
  - "VARIABLE 0-24V 3A MAX"
  - "⚠ HIGH VOLTAGE - REAR ACCESS ONLY"

**Option 2: Direct Printing**
- Use label maker or print on clear vinyl
- Apply with spray adhesive or self-adhesive vinyl

**Option 3: Engraved/Embossed**
- Laser engrave or 3D emboss text during printing
- Requires CAD integration

---

### Front Panel Labels

**Text**:
- "CLEAN LOGIC ZONE - MAX 5V"
- Optional: Carrier type labels ("ESP32-S3" or "RP2040 PICO")

**Method**: Same as rear panel (vinyl decals or direct printing)

---

### Side Panel Labels

**Text**:
- "I²C BUS"
- "UART"
- "SPI"
- "RS-485"

**Method**: Same as rear panel

---

## Optional Components

### Ventilation

**Fan** (if using active cooling):
- Size: 60 mm × 60 mm × 15-25 mm (standard PC fan)
- Voltage: 12V DC or 24V DC (from Power PCB)
- Mounting: 4× M4 screws (typically included with fan)
- Airflow: ~20-30 CFM (low noise)

**Fan Grill/Guard**:
- 60 mm fan grill (prevents finger/debris ingress)
- Plastic or metal

**Alternative**: Passive ventilation slots (no fan, rely on convection)

---

### Handles (Portable Configuration)

**Type**: Recessed or fold-down handles
**Quantity**: 2× (left and right sides)
**Material**: Plastic or metal
**Mounting**: M4 or M5 screws into heat-set inserts

---

## BOM Summary Table

| Category | Component | Quantity | Material | Notes |
|----------|-----------|----------|----------|-------|
| **Enclosure Shell** | FDM printed parts | 1 set | PLA/PETG | 3-5 mm walls, 1.5-2.5 kg filament |
| **Enclosure Shell** | Resin printed parts (alternative) | 1 set | Tough resin | 2-4 mm walls, 1-2 L resin |
| **Rails** | 2020 extrusion (rear) | 1× ~450 mm | Aluminum 6063-T5 | Anodized black |
| **Rails** | 2020 extrusion (side) | 2× ~400 mm | Aluminum 6063-T5 | Anodized black |
| **Rails** | M5 T-nuts | 12-20× | Steel | Spring-loaded preferred |
| **Magnetic** | Steel plate | 1× ~380×330 mm | Mild steel, 1-2 mm | Powder-coated or isolated |
| **Magnetic** | Magnetic mat | 1× ~380×330 mm | PEI spring steel, 1-2 mm | Cut to size |
| **Fasteners** | M3 × 6-8 mm screws | 30-40× | Stainless steel | PCB + panel mounting |
| **Fasteners** | M3 heat-set inserts | 30-40× | Brass, M3×5-6 mm | For FDM/PETG |
| **Fasteners** | M3 nylon standoffs (10-20 mm) | 16-20× | Nylon or brass | PCB elevation |
| **Fasteners** | M5 × 10-12 mm screws | 12-16× | Stainless steel | Rail mounting |
| **Cable Mgmt** | Zip ties (assorted) | 20-30× | Nylon | Reusable preferred |
| **Cable Mgmt** | Rubber grommets | 4-8× | Rubber/silicone | Panel exits |
| **Cable Mgmt** | 3D printed cable clips | 10-20× | PLA/PETG | For 2020 rails |
| **Adhesive** | 2-part epoxy or VHB tape | 1 set | Epoxy or 3M VHB | Steel plate bonding |
| **Labels** | Vinyl decals or engraving | 1 set | Vinyl | Safety and zone labels |
| **Optional** | 60 mm fan + grill | 1× | Plastic/metal | If active cooling needed |
| **Optional** | Rubber feet | 4-6× | Rubber/silicone | 10-15 mm diameter |

---

## Cost Estimation (Rough)

**FDM Prototype Build**:
- Filament (1.5-2.5 kg): $30-50 USD
- 2020 rails (~1.2 m): $15-25 USD
- Steel plate (cut to size): $10-20 USD
- Magnetic mat: $15-30 USD
- Fasteners (M3/M5 bulk): $15-25 USD
- Cable management: $10-15 USD
- Labels: $5-10 USD
- **Total**: ~$100-175 USD

**Resin Final Build**:
- Resin (1-2 L): $60-120 USD
- 2020 rails: $15-25 USD
- Steel plate: $10-20 USD
- Magnetic mat: $15-30 USD
- Fasteners: $15-25 USD
- Cable management: $10-15 USD
- Labels: $5-10 USD
- **Total**: ~$130-245 USD

*Costs exclude printer ownership/operating costs and labor.*

---

## Supplier Recommendations

### 2020 Rails
- **Misumi USA**: High quality, cut-to-length service
- **80/20 Inc.**: North American standard, extensive catalog
- **AliExpress**: Economy option (verify T-slot compatibility)

### Steel Plate
- **SendCutSend**: Online sheet metal cutting, fast turnaround
- **OSH Cut**: Laser cutting service
- **Local metal supplier**: Often cheapest for simple cuts

### Magnetic Mat
- **Prusa Research**: PEI spring steel sheets (cut to size)
- **Amazon**: Generic PEI sheets or magnetic rubber sheet
- **Hardware stores**: Adhesive-backed magnetic sheet

### Fasteners
- **McMaster-Carr**: Comprehensive catalog, fast shipping (US)
- **Misumi**: Metric fasteners, heat-set inserts
- **Amazon**: Bulk fastener kits (M3/M5 assortments)

### 3D Printing Filament/Resin
- **Prusa Filament**: High-quality PLA/PETG
- **eSun, Hatchbox**: Mid-range quality, good value
- **Formlabs Resin**: Premium tough resin
- **Elegoo Resin**: Economy ABS-like resin

---

## Notes

- **Heat-Set Insert Installation**: Practice on scrap prints first. Overheating can deform the plastic or cause inserts to sink too deep.

- **Steel Plate Isolation**: Verify ≥2 mm isolation layer between steel and any PCB or electrical component. Test with multimeter (steel plate should be electrically isolated from GND).

- **Magnetic Mat Surface**: If using PEI spring steel, ensure the textured side faces UP (smooth side attaches to steel plate). PEI provides excellent grip for breadboards.

- **2020 Rail Cutting**: If cutting rails yourself, use a miter saw or hacksaw with a fine-tooth blade. Deburr cut ends with a file.

- **Resin Post-Cure**: Follow resin manufacturer's datasheet for post-cure time and temperature. Under-cured parts may be weak or tacky.

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
