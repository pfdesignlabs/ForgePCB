# BOM.md — ForgePCB v1 (Freeze-Level)

This BOM is aligned with Features F002–F005. It is procurement-ready at the class level.
Part numbers may be selected later, but substitutions must respect invariants and be logged if they change behavior.

---

## External Power
- External AC/DC power supply: 24 V DC, 10 A (≈240 W), reputable brand class (Mean Well / Delta / TDK)

---

## Power PCB
### Input & Protection
- Locking high-current DC panel connector (≥10 A @ 24 V)
- Blade fuse holder (ATO/ATC)
- 10 A blade fuse

### Conversion
- Buck converter: 24 V → 5 V, 5 A capability
- Buck converter: 24 V → 3.3 V, 3 A capability

### Protection / Switching
- eFuse channels (programmable, latch-off): 3 channels
  - 5 V rail
  - 3.3 V rail
  - Variable bay output

### UI
- Rocker switches (rail enable via eFuse enable): 2
- Momentary push buttons (fault reset): 2
- LEDs:
  - Rail ON: 2
  - Rail FAULT: 2
  - Variable FAULT: 1

### Variable Power Bay
- Adjustable DC-DC module 0–24 V, ≥3 A, with display and its own enable
- Banana jacks: red + black (pair)

---

## Signal/Backbone PCB (DBB)
### Headers (2.54 mm)
- I²C 1×6
- UART 1×6
- SPI 2×5
- RS-485 1×6
- Logic analyzer 2×12 (16 channels + grounds)

### Switches
- DIP switch banks for:
  - I²C pull-ups enable + 3.3/5 selection
  - RS-485 TERM/BIAS/VLOGIC selection

### Passives / Protection
- I²C pull-up resistors footprints
- RS-485 termination resistor footprint (120 Ω)
- RS-485 bias resistors footprints
- Optional TVS footprint on A/B lines

---

## MCU Carriers (ESP32-S3 + RP2040)
- Carrier PCBs: 80×120 mm, 4× M3 mounting: 2
- Dupont header bank for 16 GPIO
- Screw terminals: 8 GPIO + 2 GND per carrier (qty depends on terminal pitch/blocks)
- Control buttons accessible (EN/BOOT, RUN)

---

## USB & Debug
- Internal USB 2.0 hub module: 4-port
- Logic analyzer dongle (external): 16-channel class

---

## Mechanical & Assembly
- Embedded steel plate (isolated)
- Isolation sheet (PET/FR4)
- Magnetic mat (printer-bed style)
- 2020 extrusion: rear + sides
- Heat-set inserts: M3
- M3 fasteners/standoffs
- Ferrules assortment
- Power wire: 16–18 AWG
- Dupont wires assortment
