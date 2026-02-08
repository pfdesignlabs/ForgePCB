# /status/NEXT.md — What To Do Next

## Status: Git Topology Bootstrap Complete ✅

SPRINT_001 has been successfully executed. All work items (WI-001 through WI-006) reached DONE status.

**Completed:**
- ✅ GitHub repository `pfdesignlabs/ForgePCB` created
- ✅ Git history initialized in ForgePCB with governance files
- ✅ ForgePCB pushed to GitHub (authoritative source of truth)
- ✅ ForgePCB integrated as git subtree in ForgeOS at `components/forgepcb/`
- ✅ Subtree workflow documented in ForgeOS/SUBTREE_WORKFLOW.md
- ✅ Guard rails implemented (pre-commit hook prevents subtree commits)
- ✅ Round-trip sync workflow verified

**Repository State:**
- ForgePCB: Independent repository at pfdesignlabs/ForgePCB
- ForgeOS: Consumes ForgePCB as read-only subtree at components/forgepcb/
- Topology satisfies Feature F001 requirements

## Next Action

With git topology operational, the next logical step is to begin Feature implementation work.

**Recommended Next Sprint: Feature F002 Implementation**

Feature F002 (Power and Signal Subsystems) is the hardware foundation:
- Power PCB architecture and design
- Signal backbone (DBB) architecture
- Atopile source file generation
- Component selection and BOM updates

Before proceeding, human should review:
1. ACTIVE_SLICE.md — Update slice scope if needed
2. Feature F002 frozen decisions — Ensure clarity on requirements
3. BOM.md — Review current component decisions

**Alternative Actions:**
- Feature F003: MCU carriers and I/O exposure
- Feature F004: Enclosure zones and physical execution
- Feature F005: Firmware tooling and ForgeOS integration

Human should select next feature to implement and update ACTIVE_SLICE.md accordingly.

## Resume Rule
Do not start execution work unless:
- A Claude-generated work item exists
- It is inside the current ACTIVE_SLICE
