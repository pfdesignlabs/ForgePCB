# Cable Routing Specification

Feature F004 §5: Cable routing lanes and constraints

## Routing Principles

1. **Clean/Dirty Separation**: 24V and variable bay cables stay in rear zone
2. **Breadboard Clearance**: No cables cross over breadboard area (F004 §8)
3. **Strain Relief**: All cables have strain relief at connectors
4. **Bend Radius**: Minimum 10 mm radius for all cables
5. **Separation**: High-current cables separated from signal cables

## Primary Cable Routes

### Power Distribution (Rear → Front)
```
24V Input → Power PCB → Buck Converters
                      ↓
                  5V/3.3V Rails → Ribbon Cable
                                ↓
                            DBB + Carriers
```

**Cable Type**: Ribbon cable or harness (5V, 3.3V, GND)
**Routing Lane**: Along side wall (left or right)
**Clearance**: ≥20 mm from breadboards

### Variable Bay (Internal)
```
Power PCB → Variable Bay Module → Rear Panel (Banana Jacks)
```

**Cable Type**: High-current wire (14-16 AWG)
**Routing**: Stays in rear zone, no front access
**Color**: Red (positive), Black (negative)

### USB Hub Connections
```
Host (USB-C/A) → Hub → ESP32 Carrier
                    → Pico Carrier
                    → LA Dongle
```

**Cable Type**: USB-C or USB-A cables
**Routing Lane**: Along opposite side wall from power cables
**Length**: Keep short (~150-200 mm)

### Bus Headers (DBB → Side Panel)
```
DBB PCB → Side Panel Cutouts (I²C, UART, SPI, RS-485)
```

**Cable Type**: Ribbon or individual Dupont wires
**Routing**: Direct path to side panel (minimize length)

## Cable Lanes (Top View)
```
┌─────────────────────────────────────┐
│                                     │
│  [Breadboards - NO CABLES ABOVE]    │
│                                     │
├─────────────────────────────────────┤
│ LEFT LANE:          RIGHT LANE:     │
│ - Power cables      - USB cables    │
│   (5V, 3.3V, GND)   - Signal cables │
│ - Ribbon harness                    │
└─────────────────────────────────────┘
```

## Strain Relief
- **Connectors**: Cable ties or zip ties at connector points
- **Panel exits**: Rubber grommets or printed strain relief clips
- **Internal**: Cable routing clips attached to 2020 rails or enclosure walls

## Cable Management Accessories
- **Cable clips**: 3D printed clips for 2020 rails
- **Tie-down points**: Integrated into enclosure base
- **Cable channels**: Optional printed channels for neat routing

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
