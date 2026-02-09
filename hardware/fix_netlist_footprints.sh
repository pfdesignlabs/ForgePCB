#!/bin/bash
# Post-process Atopile netlist to use KiCAD standard footprint libraries
# Run this after: ato build

set -e

NETLIST="build/default.net"

if [ ! -f "$NETLIST" ]; then
    echo "Error: $NETLIST not found. Run 'ato build' first."
    exit 1
fi

echo "Fixing footprint library names in $NETLIST..."

sed -i '' \
  -e 's/lib:R1206/Resistor_SMD:R_1206_3216Metric/g' \
  -e 's/lib:R0805/Resistor_SMD:R_0805_2012Metric/g' \
  -e 's/lib:R0603/Resistor_SMD:R_0603_1608Metric/g' \
  -e 's/lib:C1210/Capacitor_SMD:C_1210_3225Metric/g' \
  -e 's/lib:C0805/Capacitor_SMD:C_0805_2012Metric/g' \
  -e 's/lib:C0603/Capacitor_SMD:C_0603_1608Metric/g' \
  "$NETLIST"

echo "✓ Footprints updated to KiCAD standard libraries"
echo "✓ Ready for import into KiCAD PCB Editor"
