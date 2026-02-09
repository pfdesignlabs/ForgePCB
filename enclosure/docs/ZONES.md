# Zone Layout Specification

Feature F004 §4.1: Zone definition and enforcement

## Zone Philosophy

ForgePCB enforces safe behavior through **physical zone separation**. The enclosure is divided into distinct zones based on voltage levels and usage patterns:

- **Clean Zone** (Front): Low voltage logic (≤5V), user workspace
- **Dirty Zone** (Rear): High voltage/current (up to 24V), power distribution

**Critical Rule**: No connectors carrying >5V are accessible from the clean/front zone.

---

## Zone Map (Top View)

```
        FRONT (Clean Zone)
┌─────────────────────────────────────┐
│                                     │
│  ┌──────────┐        ┌──────────┐  │ USB-C (Carrier)
│  │Breadboard│        │Breadboard│  │ Dupont Headers
│  │  (~830)  │        │  (~830)  │  │ Screw Terminals
│  └──────────┘        └──────────┘  │ LA Header
│                                     │
│  ┌────────────────────────────┐    │
│  │   MCU Carrier Zone         │    │ 3.3V/5V/GND only
│  │   (80×120 mm)              │    │
│  └────────────────────────────┘    │
│                                     │
│  [Magnetic Mat Surface]             │
│  [Steel Plate - Isolated]           │
├─────────────────────────────────────┤
│  Internal:                          │
│  - DBB PCB (headers, switches)      │
│  - USB Hub                          │
│  - Power PCB (front section)        │
└─────────────────────────────────────┘
        MIDDLE (Transition)

┌─────────────────────────────────────┐
│  Internal:                          │
│  - Power PCB (rear section)         │
│    - Buck converters                │
│    - eFuse protection               │
│  - Variable bay module              │
└─────────────────────────────────────┘
        REAR (Dirty Zone)

REAR PANEL:
├─ 24V Power Input (locking connector)
├─ Variable Bay Banana Jacks (0-24V)
├─ Variable Bay Display
└─ (Optional) Ventilation
```

---

## Zone Definitions

### 1. Front Clean Zone (User Workspace)

**Location**: Top surface, front half

**Accessible Elements**:
- 2× Full-size breadboards (~830 tie points each)
- MCU carrier GPIO headers (16× Dupont pins)
- MCU carrier screw terminals (8× terminals + 2× GND)
- Bus headers from DBB (I²C, UART, SPI, RS-485)
- Logic analyzer header (16 channels)
- MCU carrier USB-C connector
- Control buttons (EN, BOOT, RUN on carriers)

**Voltage Levels**:
- Maximum: **5V DC**
- Typical: 3.3V, 5V, GND
- **Forbidden**: Variable bay power (>5V)

**Materials**:
- Magnetic mat (top surface)
- Isolated steel plate (embedded, not electrical ground)
- Breadboard mounting (locked position, swappable)

**Safety Constraints**:
- No direct access to Power PCB high-voltage rails
- No variable bay connections
- Cable routing must not cross over breadboard area
- All connectors rated for ≤5V operation

---

### 2. Rear Dirty Zone (Power Distribution)

**Location**: Rear panel and rear internal area

**Accessible Elements** (Rear Panel):
- 24V DC power input (locking connector, 10A fuse inside)
- Variable bay banana jacks (red + black, 0-24V adjustable)
- Variable bay display module (voltage/current readout)
- Power ON/FAULT LEDs (visible from rear or top)

**Internal Components**:
- Variable bay DC-DC module (0-24V, 3A)
- Power PCB rear section (buck converters, eFuses)
- High-current cable routing (24V input, variable bay output)

**Voltage Levels**:
- Input: **24V DC** (from power brick)
- Variable bay: **0-24V DC** (user-adjustable, 3A max)
- Internal rails: 5V, 3.3V (eFuse protected, routed forward to clean zone)

**Safety Constraints**:
- All >5V connectors rear-accessible only
- No front-panel access to variable bay or 24V input
- Clear labeling: "HIGH VOLTAGE - REAR ACCESS ONLY"
- Cable routing separated from clean zone

---

### 3. Middle Transition Zone (Internal Only)

**Location**: Internal cavity between front and rear

**Components**:
- DBB (Digital Backbone) PCB
- Internal USB hub (CH334F or similar)
- Cable routing from Power PCB to DBB and carriers
- Ribbon cables or harnesses (5V, 3.3V, GND distribution)

**Voltage Levels**:
- 5V, 3.3V, GND (protected rails from Power PCB)
- No high-voltage routing through this zone

**Cable Management**:
- Dedicated cable lanes (avoid crossing over breadboards)
- Strain relief for all internal cables
- Ribbon cables or bundled harnesses (not loose wires)

---

## Zone Enforcement Mechanisms

### Physical Barriers

1. **Enclosure Walls**: Front zone physically separated from rear by internal divider (optional, if needed for cable management)

2. **Panel Access Control**:
   - Front panel: Only USB-C, Dupont headers, low-voltage terminals
   - Rear panel: Only 24V input, variable bay outputs
   - Side panels: Bus headers (DBB), DIP switches

3. **Top Surface Isolation**:
   - Steel plate fully isolated from electrical paths
   - Magnetic mat provides insulation layer
   - No conductive surfaces exposed in workspace

### Electrical Barriers

1. **Voltage Routing**:
   - 24V and variable bay rails stay in rear zone
   - Only 5V, 3.3V, GND routed to front zone
   - eFuses on Power PCB enforce current limits

2. **Breadboard Power**:
   - Breadboards connected ONLY to 5V/3.3V/GND rails
   - No physical path for variable bay power to reach breadboards
   - Any exception requires decision log entry (F004 §4.7)

### Procedural Barriers

1. **Labeling**:
   - Front zone: "CLEAN LOGIC ZONE - MAX 5V"
   - Rear zone: "DIRTY POWER ZONE - UP TO 24V"
   - Variable bay: "ADJUSTABLE 0-24V - CAUTION"

2. **Color Coding** (optional):
   - Green: ≤5V (safe, clean zone)
   - Yellow: 5-12V (caution)
   - Red: >12V (danger, rear zone only)

---

## Zone Layout Dimensions

### Top Surface (Clean Zone)

- **Total usable area**: Approx. 300 mm × 400 mm (estimate, adjust based on enclosure size)
- **Breadboard area**: 2× breadboards (~170 mm × 55 mm each) + spacing
- **Carrier zone**: 80 mm × 120 mm (per carrier, M3 mounting)
- **Header access**: Side edges or front edge (Dupont headers, terminals)
- **Magnetic mat coverage**: Full top surface minus cutouts

### Internal Cavity

- **Height clearance**:
  - Power PCB: ~30-40 mm (buck converters, eFuses, variable bay module)
  - DBB: ~20-30 mm (headers, DIP switches)
  - USB hub: ~15-20 mm
  - Cable routing: ~20 mm clearance

- **Width allocation**:
  - Power PCB: ~120-150 mm wide
  - DBB: ~100-120 mm wide
  - Variable bay module: ~80-100 mm wide

### Rear Panel

- **Cutouts**:
  - 24V power input: Locking DC jack cutout (~15 mm diameter)
  - Banana jacks: 2× holes (~4 mm diameter, 19 mm spacing)
  - Variable bay display: Rectangular cutout (~40 mm × 20 mm)

---

## Zone Transition Rules

### Clean → Dirty (Forward to Rear)

**Not Allowed**:
- User cannot route wires from front breadboards to rear variable bay
- No physical or electrical path for >5V to enter clean zone

**Allowed** (with caution):
- Internal cables (5V, 3.3V, GND) from Power PCB (rear) to DBB/carriers (front)
- USB cables from internal hub to carriers (data only, ≤5V)

### Dirty → Clean (Rear to Front)

**Required Path**:
- 24V input → Power PCB → Buck converters → 5V/3.3V rails (eFuse protected) → DBB/carriers
- Voltage stepped down and protected before entering clean zone
- No direct connection from 24V or variable bay to clean zone

---

## Usage Scenarios

### Scenario 1: Normal Development Workflow

1. User powers on ForgePCB via rear 24V input
2. Power PCB generates 5V/3.3V rails (eFuse protected)
3. User works in front clean zone:
   - Breadboards powered by 5V/3.3V rails only
   - MCU carriers (ESP32/Pico) powered by 5V from Power PCB
   - GPIO signals on headers/terminals (logic level, ≤5V)
   - Bus headers (I²C, UART, SPI, RS-485) for peripherals
4. Variable bay stays in rear zone, used only for high-power devices (motors, external loads)

### Scenario 2: High-Power Device Testing

1. User needs to test a 12V motor
2. Motor connects to rear variable bay banana jacks (set to 12V)
3. Motor control signal from MCU carrier GPIO (logic level, 3.3V/5V)
4. Motor power remains in rear zone, never routed through front zone
5. User does NOT connect motor power to breadboard (forbidden by F004 §4.7)

### Scenario 3: Fault Condition

1. Overcurrent fault on 5V rail (e.g., short circuit on breadboard)
2. Power PCB eFuse trips (latch-off)
3. 5V rail disabled, front zone becomes unpowered
4. User sees FAULT LED on Power PCB (visible from top or front)
5. User presses reset button to clear fault latch
6. User investigates and fixes short circuit before re-enabling

---

## Validation Checklist

Before finalizing enclosure design, verify:

- [ ] No >5V connectors accessible from front/clean zone
- [ ] Breadboards physically cannot connect to variable bay
- [ ] Cable routing does not cross over breadboard area
- [ ] Steel plate is isolated (not used as electrical ground)
- [ ] Magnetic mat fully covers clean zone workspace
- [ ] USB-C cutouts align with carrier USB connectors (rigid alignment)
- [ ] All headers (Dupont, terminals, bus headers) accessible from front/side
- [ ] Variable bay outputs (banana jacks) accessible only from rear
- [ ] 24V power input accessible only from rear
- [ ] Internal cable routing has strain relief and separation
- [ ] Zones are intuitive and visually distinct (labeling, optional color coding)

---

## References

- Feature F002 §4.5: Breadboard policy (3.3V/5V/GND only)
- Feature F002 §4.6: Variable bay (0-24V, rear-mounted)
- Feature F003 §4.3: Carrier envelope (80×120 mm)
- Feature F004 §4.1: Zone layout (clean vs dirty)
- Feature F004 §4.2: Voltage accessibility (no >5V in clean zone)
- Feature F004 §4.7: Breadboard electrical constraint

---

**Document Status**: Complete
**Last Updated**: 2026-02-08
**Author**: Claude Code (Sonnet 4.5)
