# Git Workflow — ForgePCB Branch Strategy

## Overview

ForgePCB follows a **hierarchical branching model** to ensure traceability, review, and clean separation between development and stable releases.

```
work-item/WI-XXX → feature/fXXX-name → develop → main
```

---

## Branch Hierarchy

### 1. `main` — Production/Release Branch
- **Purpose:** Stable, released code only
- **Merges from:** `develop` (via release merge)
- **Protected:** Yes (require PR review in future)
- **Naming:** Always `main`

**Rules:**
- Never commit directly to `main`
- Only merge from `develop` when a sprint/feature is complete
- All merges use `--no-ff` (non-fast-forward) to preserve history
- Tag releases: `git tag -a v0.1.0 -m "Release SPRINT_002"`

---

### 2. `develop` — Integration Branch
- **Purpose:** Ongoing development, feature integration
- **Merges from:** Feature branches (`feature/fXXX-name`)
- **Merges to:** `main` (when ready for release)
- **Naming:** Always `develop`

**Rules:**
- Never commit directly to `develop`
- Only merge completed feature branches
- Feature branches must have all work items complete and validated
- Use `--no-ff` merges for traceability

---

### 3. `feature/fXXX-name` — Feature Branches
- **Purpose:** Implementation of a single Feature (e.g., F002, F003)
- **Merges from:** Work item branches (`work-item/WI-XXX`)
- **Merges to:** `develop` (when feature is complete)
- **Naming:** `feature/f002-power-signal-subsystems`, `feature/f003-mcu-carriers`

**Lifecycle:**
1. Branch from `develop`: `git checkout -b feature/f002-power-signal-subsystems develop`
2. Merge work item branches as they complete
3. When all work items done: validate feature per closure conditions
4. Merge to `develop`: `git checkout develop && git merge --no-ff feature/f002-power-signal-subsystems`
5. Push to remote: `git push origin feature/f002-power-signal-subsystems`
6. Optionally delete after merge: `git branch -d feature/f002-power-signal-subsystems`

**Rules:**
- One feature branch per Feature (F002, F003, etc.)
- All work items for that feature merge here first
- Feature branch stays alive until merged to `develop`
- Use `--no-ff` when merging work item branches

---

### 4. `work-item/WI-XXX` — Work Item Branches
- **Purpose:** Implementation of a single work item from a sprint plan
- **Merges from:** None (leaf branches)
- **Merges to:** Parent feature branch
- **Naming:** `work-item/WI-007-setup-atopile`, `work-item/WI-008-power-input`

**Lifecycle:**
1. Branch from feature branch: `git checkout -b work-item/WI-007-setup-atopile feature/f002-power-signal-subsystems`
2. Implement the work item (single focused task)
3. Commit with descriptive message referencing work item
4. Merge to feature branch: `git checkout feature/f002-power-signal-subsystems && git merge --no-ff work-item/WI-007-setup-atopile`
5. Delete after merge: `git branch -d work-item/WI-007-setup-atopile`

**Rules:**
- One work item branch per work item (WI-XXX)
- Keep scope tight: only implement what's in the work item description
- Commit messages must reference work item ID
- Merge to feature branch when work item reaches DONE status
- Delete after successful merge

---

## Naming Conventions

### Branch Names

| Branch Type | Pattern | Example |
|-------------|---------|---------|
| Main | `main` | `main` |
| Develop | `develop` | `develop` |
| Feature | `feature/fXXX-short-name` | `feature/f003-mcu-carriers` |
| Work Item | `work-item/WI-XXX-short-name` | `work-item/WI-020-esp32-carrier` |

**Guidelines:**
- Use lowercase and hyphens (kebab-case)
- Feature branches: `fXXX` matches Feature ID from `/features/FEATURE_XXX_*.md`
- Work item branches: `WI-XXX` matches work item ID from sprint plan
- Short names: 2-4 words describing the work

### Commit Messages

**Format:**
```
<Subject line (imperative, max 72 chars)>

<Body: detailed description, reasoning, context>

<Footer: work item reference, co-authored-by>
```

**Examples:**

**Work Item Commit:**
```
Implement Power PCB input module (WI-008)

Create input.ato with 24V power brick connector, 10A blade fuse,
and input protection per F002 frozen decision §4.1.

Components:
- Locking DC connector (≥10A @ 24V)
- Blade fuse holder and 10A fuse
- Input bulk capacitor (470uF)

Work Item: WI-008
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Feature Merge Commit:**
```
Merge feature/f002-power-signal-subsystems into develop

SPRINT_002 complete: Feature F002 (Power and Signal Subsystems)
All work items WI-007 through WI-019 implemented and validated.
```

**Release Merge Commit:**
```
Release SPRINT_002: Feature F002 (Power and Signal Subsystems) complete

Merge develop into main for SPRINT_002 release.

Complete electrical architecture implemented in Atopile:
- Power PCB with eFuse protection and variable bay
- DBB with bus headers and logic analyzer integration
- All 11 frozen decisions validated

Feature F002 is now frozen and ready for downstream work.
```

---

## Workflow Examples

### Example 1: Starting a New Sprint (F003 — MCU Carriers)

```bash
# 1. Ensure develop is up to date
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/f003-mcu-carriers

# 3. Push feature branch to remote
git push -u origin feature/f003-mcu-carriers

# 4. For each work item in sprint plan:

# Work item WI-020: Setup MCU structure
git checkout -b work-item/WI-020-setup-mcu-structure feature/f003-mcu-carriers
# ... do work ...
git add hardware/mcu/
git commit -m "Setup MCU carrier directory structure (WI-020)

Create directory structure for MCU carriers:
- hardware/mcu/esp32s3_carrier.ato
- hardware/mcu/rp2040_pico_carrier.ato

Work Item: WI-020
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git checkout feature/f003-mcu-carriers
git merge --no-ff work-item/WI-020-setup-mcu-structure
git branch -d work-item/WI-020-setup-mcu-structure

# Work item WI-021: ESP32-S3 carrier
git checkout -b work-item/WI-021-esp32-carrier feature/f003-mcu-carriers
# ... do work ...
git add hardware/mcu/esp32s3_carrier.ato
git commit -m "Implement ESP32-S3 carrier module (WI-021)

... details ...

Work Item: WI-021
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git checkout feature/f003-mcu-carriers
git merge --no-ff work-item/WI-021-esp32-carrier
git branch -d work-item/WI-021-esp32-carrier

# ... repeat for all work items WI-022, WI-023, etc. ...

# 5. When all work items complete, validate feature
# (run validation checklist per feature closure conditions)

# 6. Merge feature to develop
git checkout develop
git merge --no-ff feature/f003-mcu-carriers -m "Merge feature/f003-mcu-carriers into develop

SPRINT_003 complete: Feature F003 (MCU Carriers and I/O Exposure)
All work items WI-020 through WI-0XX implemented and validated."

git push origin develop

# 7. Optionally push feature branch for transparency
git push origin feature/f003-mcu-carriers

# 8. Release to main (when ready)
git checkout main
git merge --no-ff develop -m "Release SPRINT_003: Feature F003 (MCU Carriers) complete

... release notes ..."

git push origin main

# 9. Tag release
git tag -a v0.2.0 -m "Release: F002 + F003 complete"
git push origin v0.2.0
```

---

### Example 2: Hotfix on Main (Emergency)

For critical fixes that can't wait for the next sprint:

```bash
# 1. Branch from main
git checkout main
git checkout -b hotfix/fix-critical-bom-error

# 2. Make fix
git add BOM.csv
git commit -m "Hotfix: Correct fuse rating in BOM

Fixed critical error in BOM.csv: fuse rating was 5A, should be 10A
per F002 frozen decision §4.1.

Hotfix: Critical BOM correction"

# 3. Merge to main
git checkout main
git merge --no-ff hotfix/fix-critical-bom-error
git push origin main

# 4. Also merge to develop (keep in sync)
git checkout develop
git merge --no-ff hotfix/fix-critical-bom-error
git push origin develop

# 5. Delete hotfix branch
git branch -d hotfix/fix-critical-bom-error
```

---

## Integration with ForgeOS

ForgePCB is consumed by ForgeOS as a **git subtree** at `components/forgepcb/`.

**Rule:** All ForgePCB work happens in the ForgePCB repository using this workflow. ForgeOS pulls changes via subtree.

**Workflow:**
1. Work in ForgePCB repository (this workflow)
2. Merge to `main` when feature complete
3. In ForgeOS repository, pull subtree updates:
   ```bash
   cd ForgeOS/
   git subtree pull --prefix=components/forgepcb forgepcb main --squash
   ```

See `/CLAUDE.md` § Repository Topology for full details.

---

## Branch Protection Rules (GitHub)

**Recommended settings (to be configured on GitHub):**

### `main` branch:
- ✅ Require pull request before merging
- ✅ Require approvals: 1 (human review)
- ✅ Require status checks to pass (if CI/CD added)
- ✅ Require branches to be up to date before merging
- ✅ Do not allow bypassing the above settings

### `develop` branch:
- ✅ Require pull request before merging (optional, can allow direct merges from feature branches)
- ✅ Require status checks to pass (if CI/CD added)

### Feature and work-item branches:
- No protection (developers work freely)

---

## Retrospective Notes

### SPRINT_002 (Feature F002)
**What happened:**
- All work items (WI-007 through WI-019) were committed in a single commit on the feature branch
- No individual work-item branches were created
- Feature branch merged to develop, then develop to main

**Why:**
- Git workflow was not defined at sprint start
- Claude Code executed all work items sequentially in one session

**Lesson learned:**
- Future sprints MUST use work-item branches for each WI-XXX
- Provides better traceability and allows incremental review
- Easier to rollback individual work items if needed

**Action:**
- This GIT_WORKFLOW.md document created to prevent recurrence
- SPRINT_003 and beyond will follow proper branch hierarchy

---

## Summary

| Branch | Purpose | Lifetime | Merges From | Merges To |
|--------|---------|----------|-------------|-----------|
| `main` | Stable releases | Permanent | `develop` | None |
| `develop` | Integration | Permanent | `feature/*` | `main` |
| `feature/fXXX-name` | Feature work | Sprint duration | `work-item/*` | `develop` |
| `work-item/WI-XXX-name` | Single task | Hours to days | None | `feature/*` |

**Golden Rule:** Code flows in one direction:
```
work-item → feature → develop → main
```

Never merge backwards (e.g., main → develop) except for hotfixes.

---

**Last Updated:** 2026-02-08
**Applies From:** SPRINT_003 onwards
**Retroactive Application:** SPRINT_002 used simplified workflow (documented above)
