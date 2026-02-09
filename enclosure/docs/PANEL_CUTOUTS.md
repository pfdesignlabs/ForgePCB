# Panel Cutouts Specification

Feature F004: Front/rear/side panel access cutouts

## Front Panel Cutouts

### MCU Carrier USB-C
- **Quantity**: 1× (for active carrier)
- **Dimensions**: 9 mm (W) × 3.5 mm (H) + tolerance
- **Tolerance**: +0.5 mm for alignment
- **Alignment**: Must align precisely with carrier USB-C connector (F003 §4.4)
- **Position**: Centered on carrier location (~60 mm from top surface)

## Rear Panel Cutouts

### 24V Power Input (Locking DC Jack)
- **Quantity**: 1×
- **Diameter**: ~15 mm (panel-mount cutout)
- **Type**: Locking DC barrel jack (e.g., Kycon KLDX series)
- **Position**: Upper center or upper left (~30 mm from top)

### Variable Bay Banana Jacks
- **Quantity**: 2× (red + black)
- **Diameter**: 4.5 mm per jack
- **Spacing**: 19 mm (standard banana jack spacing)
- **Position**: Center rear panel, ~60-80 mm from top
- **Labeling**: "0-24V VARIABLE" (silkscreen or label)

### Variable Bay Display
- **Dimensions**: ~40 mm (W) × 20 mm (H) rectangular cutout
- **Type**: LED/LCD display module cutout or flush-mount
- **Position**: Above or beside banana jacks
- **Alternative**: Mount display module flush with rear panel

### Ventilation (Optional)
- **Type**: Slots or fan cutout
- **Dimensions**: 60-80 mm (for 60 mm fan) or multiple slots
- **Position**: Lower rear panel (heat exhaust)
- **Purpose**: Cooling for buck converters and variable bay module

## Side Panel Cutouts

### DBB Bus Headers (Choose Left or Right Side)
All cutouts for Dupont header access:

**I²C Header (1×6)**
- Dimensions: ~15 mm (W) × 40 mm (H)
- Position: Mid-height, forward section

**UART Header (1×6)**
- Dimensions: ~15 mm (W) × 40 mm (H)
- Position: Below I²C header

**SPI Header (2×5)**
- Dimensions: ~30 mm (W) × 20 mm (H)
- Position: Below UART header

**RS-485 Header (1×6)**
- Dimensions: ~15 mm (W) × 40 mm (H)
- Position: Below SPI header

**Alternative**: Side panels removable for easier header access

### DIP Switches (Optional Side Access)
- **Dimensions**: Cutouts for DIP switch actuators
- **Position**: Accessible from top or side (TBD based on DBB placement)

## Top Surface Cutouts

### Carrier Mounting Area
- **No cutouts**: Carriers mount on flat magnetic mat surface
- **Alignment**: USB-C cutout in front panel must align with carrier connector

### Breadboard Area
- **No cutouts**: Breadboards sit on magnetic mat (locked position)

### GPIO Headers/Terminals (Carrier)
- **Access**: From top (no cutouts, connectors face upward)

## Tolerance Guidelines

### USB-C Cutout
- **Fit**: Snug but not tight (±0.3-0.5 mm)
- **Alignment**: Critical for rigid USB alignment (F003 §4.4)
- **Testing**: Verify with actual carrier before finalizing

### Banana Jacks
- **Fit**: Panel-mount jacks have threads and nuts (tight fit)
- **Spacing**: Precisely 19 mm (standard spacing)

### Headers
- **Fit**: Loose enough for easy cable insertion/removal
- **Margin**: +1-2 mm around header perimeter

## Labeling

### Rear Panel Labels (Silkscreen or Adhesive)
- "24V DC INPUT 10A MAX"
- "VARIABLE 0-24V 3A MAX"
- "⚠ HIGH VOLTAGE - REAR ACCESS ONLY"

### Front Panel Labels
- "CLEAN LOGIC ZONE - MAX 5V"
- Carrier type labels (optional): "ESP32-S3" or "RP2040 PICO"

### Side Panel Labels
- "I²C BUS"
- "UART"
- "SPI"
- "RS-485"

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
