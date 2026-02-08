# PLAYBOOK.md — ForgePCB Execution Playbook

## Purpose
This playbook defines how ForgePCB is run as an operating system:
- mixed technical + hands-on work
- deterministic progress
- interruption-safe execution
- auditable decisions
- correct Git repository boundaries

---

## Feature-First Execution Model (Hard Rule)
This project operates strictly as:

**Features → Claude Code work items → Execution → Verification → Status**

Humans:
- Define and freeze features
- Execute hands-on work
- Validate outputs

Claude Code:
- Derives work items from Features
- Orders execution into sprints
- Maintains deterministic status updates
- Executes Git operations in the correct repository context

---

## Git Workflow: ForgePCB + ForgeOS Subtree (Hard Rule)

### Topology
- ForgePCB (authoring): `pfdesignlabs/ForgePCB`
- ForgeOS (consumer): `pfdesignlabs/ForgeOS` with subtree at `components/forgepcb/`

### Daily workflow (authoring)
1. Make changes in ForgePCB
2. Commit + push in ForgePCB
3. In ForgeOS, update subtree:
   `git subtree pull --prefix=components/forgepcb forgepcb main --squash`

### Forbidden
- Direct edits committed inside `ForgeOS/components/forgepcb/`
- “Quick fixes” in the subtree without upstream ForgePCB commits

---

## How Work Starts
1. Ensure Features are complete and frozen enough to derive work items.
2. Claude Code generates work items and proposes a sprint.
3. Declare/confirm an `ACTIVE_SLICE.md` for what is in scope now.
4. Execute only work items inside the active slice.

---

## Decisions and Deviations
If execution would deviate from a Feature or from the current plan:
1. Log a decision in `/decisions/DECISIONS.md`
2. Update the Feature to reflect the new truth
3. Only then proceed

---

## Interruption and Resume
When stopping:
- Update the work item state (what is done, what remains)
- Write a RESUME BLOCK with the exact next safe action
- Update `/status/NEXT.md` to point to the resume action

When resuming:
- Read `ACTIVE_SLICE.md`
- Read `/status/NEXT.md`
- Read the RESUME BLOCK referenced by NEXT
- Continue only from a known state

---

## Definition of Done (Global)
A work item is DONE only if:
- acceptance criteria are met
- verification evidence is recorded (even for hands-on work)
- no open TODOs remain that affect correctness
- status pages are updated

A Feature is STABLE only if:
- invariants are respected
- interfaces are consistent
- no open “unknowns” remain that would force redesign downstream

---

## Status Files Are the Navigation System
- `/status/INDEX.md` is the single-pane-of-glass
- `/status/NEXT.md` is the single next action
- `/status/DEFINITIONS.md` defines state meanings and rules
