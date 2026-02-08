# Feature F001 — ForgePCB Execution Governance

## 1. Feature Mission
Define the operating system for running ForgePCB for months:
- deterministic execution
- auditable progress
- interruption-safe resume
- mixed technical + hands-on work treated equally
- strict Git repository boundaries (ForgePCB vs ForgeOS)

This feature exists to prevent scope drift, “documentation theater,” context loss,
and repository history corruption.

## 2. System Position
- Root feature. No dependencies.
- All other features depend on this governance layer.
- Any change to governance rules requires a decision log entry.

## 3. Scope Boundary (Hard)
### Included
- Repository structure and canonical files (CLAUDE.md, PLAYBOOK.md, status, decisions, sessions)
- Feature-first execution model (Features are truth; work items derived)
- Rules that make hands-on work first-class
- ACTIVE_SLICE and RESUME discipline
- Deterministic status/navigation updates
- Git topology and subtree governance (ForgePCB as source of truth; ForgeOS as consumer)

### Excluded
- Electrical design
- Mechanical CAD design
- Firmware implementation
- Purchasing and assembly workflows

## 4. Frozen Decisions (Invariants)
1. **Execution over documentation theater**
2. **No work without a work item**
3. **No deviation without a decision log**
4. **Feature-first, work items derived**
   - Claude Code generates work items; humans do not.
5. **Interruption-resume is mandatory**
6. **Repository topology is hard**
   - ForgePCB commits occur only in ForgePCB repo
   - ForgeOS subtree is read-only; updates happen via subtree pull

## 5. Structural Decomposition
- Governance and authority model
- Status/navigation layer
- Decision logging layer
- Session control layer (ACTIVE_SLICE, RESUME BLOCK)
- Git topology and subtree integration workflow

## 6. Interfaces & Contracts
### Process / Governance
- Features are the source of truth.
- Claude Code produces work items and sprints.
- Humans execute physical work and log verification evidence.

### Git
- ForgePCB is authored in its own repo and consumed via subtree in ForgeOS.

## 7. Execution Constraints
- No “just continue” without state.
- No implicit scope changes.
- Subtree editing in ForgeOS is forbidden.

## 8. Validation Model
Stable when:
- a human can resume after weeks using only repo state
- Claude Code can derive work items without asking non-blocking questions
- deviations are always logged
- git actions happen in the correct repository

## 9. Non-Goals & Anti-Patterns
- velocity tracking
- “quick fixes” inside subtree

## 10. Feature Closure Conditions
Foundational; must remain internally consistent and enforced.
