# Git Workflow — ForgePCB Branch Strategy

## Overview

ForgePCB follows a **hierarchical branching model** with **Pull Request (PR) based merges** to ensure traceability, review, and clean separation between development and stable releases.

```
work-item/WI-XXX → feature/fXXX-name → develop → main
     (PR)              (PR)              (PR)
```

**Critical Rule:** All merges between branches MUST go through Pull Requests on GitHub. Direct command-line merges are NOT allowed.

---

## Branch Hierarchy

### 1. `main` — Production/Release Branch
- **Purpose:** Stable, released code only
- **Merges from:** `develop` (via release merge)
- **Protected:** Yes (require PR review in future)
- **Naming:** Always `main`

**Rules:**
- Never commit directly to `main`
- Never merge directly via command line
- Only merge from `develop` via Pull Request when sprint/feature is complete
- All PRs require review and approval before merge
- GitHub will automatically use `--no-ff` (non-fast-forward) to preserve history
- Tag releases after PR merge: `git tag -a v0.1.0 -m "Release SPRINT_002"`

---

### 2. `develop` — Integration Branch
- **Purpose:** Ongoing development, feature integration
- **Merges from:** Feature branches (`feature/fXXX-name`)
- **Merges to:** `main` (when ready for release)
- **Naming:** Always `develop`

**Rules:**
- Never commit directly to `develop`
- Never merge directly via command line
- Only merge completed feature branches via Pull Request
- Feature branches must have all work items complete and validated before PR
- All PRs require review and approval before merge

---

### 3. `feature/fXXX-name` — Feature Branches
- **Purpose:** Implementation of a single Feature (e.g., F002, F003)
- **Merges from:** Work item branches (`work-item/WI-XXX`)
- **Merges to:** `develop` (when feature is complete)
- **Naming:** `feature/f002-power-signal-subsystems`, `feature/f003-mcu-carriers`

**Lifecycle:**
1. Branch from `develop`: `git checkout -b feature/f002-power-signal-subsystems develop`
2. Push to remote: `git push -u origin feature/f002-power-signal-subsystems`
3. Merge work item branches as they complete (via PR or direct if same developer)
4. When all work items done: validate feature per closure conditions
5. Create Pull Request: `feature/f002-power-signal-subsystems` → `develop`
6. Review and approve PR on GitHub
7. Merge PR via GitHub interface (squash or merge commit)
8. Delete feature branch after merge (via GitHub or locally)

**Rules:**
- One feature branch per Feature (F002, F003, etc.)
- All work items for that feature merge here first
- Feature branch stays alive until PR is merged to `develop`
- Work item → feature merges can be direct (same developer) or via PR (team review)

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

## Pull Request Process

All merges between protected branches (`main`, `develop`, `feature/*`) MUST use Pull Requests.

### Creating a Pull Request

**Option 1: GitHub Web Interface**
1. Push your branch to remote: `git push origin <branch-name>`
2. Go to https://github.com/pfdesignlabs/ForgePCB
3. Click "Compare & pull request" banner (appears automatically)
4. Select base branch (target) and compare branch (source)
5. Fill in PR title and description (see template below)
6. Click "Create pull request"

**Option 2: GitHub CLI** (recommended for automation)
```bash
gh pr create --base <target-branch> --head <source-branch> \
  --title "Your PR title" \
  --body "Your PR description"
```

### PR Title Format

```
<Type>: <Brief description (max 72 chars)>
```

**Types:**
- `SPRINT_XXX:` — Feature implementation (e.g., `SPRINT_003: Feature F003 complete`)
- `Hotfix:` — Emergency fix to main
- `Docs:` — Documentation updates
- `Refactor:` — Code refactoring without feature changes
- `Fix:` — Bug fix in development

**Examples:**
- `SPRINT_003: Feature F003 (MCU Carriers and I/O Exposure)`
- `Hotfix: Correct critical BOM error`
- `Docs: Update Git workflow with PR requirements`
- `Fix: Correct RS-485 termination resistor value`

### PR Description Template

```markdown
## Summary
<1-2 sentence summary of what this PR does>

## Changes
- <Bullet list of key changes>
- <Component additions/modifications>
- <Interface updates>

## Validation
- [ ] All frozen decisions implemented (if feature PR)
- [ ] BOM alignment verified (if hardware changes)
- [ ] Interface contracts explicit (if architecture changes)
- [ ] No regressions introduced
- [ ] Documentation updated (if needed)

## Closes
- Work items: WI-XXX through WI-YYY (if feature PR)
- Issue: #XXX (if fixing a tracked issue)

## Notes
<Any additional context, decisions made, or follow-up work>
```

### PR Review Process

**Reviewer Checklist:**
1. **Code Quality**
   - [ ] Atopile syntax is valid
   - [ ] Component specifications match BOM requirements
   - [ ] Comments are clear and reference frozen decisions where applicable

2. **Architecture**
   - [ ] Changes align with feature frozen decisions
   - [ ] No excluded scope has leaked in
   - [ ] Interface contracts are explicit and documented

3. **Governance**
   - [ ] Changes follow CLAUDE.md execution rules
   - [ ] Work items are properly completed (if feature PR)
   - [ ] Decision log updated (if architectural changes)

4. **Documentation**
   - [ ] Status files updated (INDEX.md, NEXT.md)
   - [ ] ACTIVE_SLICE.md reflects current state (if applicable)
   - [ ] New modules have adequate inline comments

**Approval:**
- At least 1 approval required for `develop` merges
- At least 1 approval required for `main` merges (release)
- Hotfixes may bypass review in true emergencies (document in PR)

**Merge Strategy:**
- Use "Merge commit" (preserves full history, non-fast-forward)
- Avoid "Squash and merge" for feature PRs (loses work item granularity)
- "Squash and merge" acceptable for small docs/hotfix PRs

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

# 6. Push feature branch (if not already pushed)
git push origin feature/f003-mcu-carriers

# 7. Create Pull Request: feature/f003-mcu-carriers → develop
# Go to GitHub: https://github.com/pfdesignlabs/ForgePCB/compare/develop...feature/f003-mcu-carriers
# Or use GitHub CLI:
gh pr create --base develop --head feature/f003-mcu-carriers \
  --title "SPRINT_003: Feature F003 (MCU Carriers and I/O Exposure)" \
  --body "## Summary
SPRINT_003 complete: All work items WI-020 through WI-0XX implemented and validated.

## Changes
- ESP32-S3 carrier module implemented
- RP2040 Pico carrier module implemented
- GPIO headers and I/O exposure defined
- Integration with DBB bus headers complete

## Validation
- All frozen decisions implemented ✓
- BOM alignment verified ✓
- Interface contracts explicit ✓

## Closes
- Work items: WI-020 through WI-0XX"

# 8. Review PR, get approval, then merge via GitHub interface
# After merge, pull latest develop locally:
git checkout develop
git pull origin develop

# 9. Delete feature branch (locally and remotely)
git branch -d feature/f003-mcu-carriers
git push origin --delete feature/f003-mcu-carriers

# 10. When ready for release: Create PR develop → main
gh pr create --base main --head develop \
  --title "Release SPRINT_003: Feature F003 complete" \
  --body "## Release Notes
Feature F003 (MCU Carriers and I/O Exposure) complete.

## Includes
- ESP32-S3 carrier support
- RP2040 Pico carrier support
- GPIO headers and I/O exposure

Ready for PCB layout and firmware integration."

# 11. Review release PR, get approval, merge via GitHub
# After merge, pull latest main locally:
git checkout main
git pull origin main

# 12. Tag release
git tag -a v0.2.0 -m "Release: F002 + F003 complete"
git push origin v0.2.0
```

---

### Example 2: Hotfix on Main (Emergency)

For critical fixes that can't wait for the next sprint:

```bash
# 1. Branch from main
git checkout main
git pull origin main
git checkout -b hotfix/fix-critical-bom-error

# 2. Make fix
git add BOM.csv
git commit -m "Hotfix: Correct fuse rating in BOM

Fixed critical error in BOM.csv: fuse rating was 5A, should be 10A
per F002 frozen decision §4.1.

Hotfix: Critical BOM correction"

# 3. Push hotfix branch
git push -u origin hotfix/fix-critical-bom-error

# 4. Create PR: hotfix → main
gh pr create --base main --head hotfix/fix-critical-bom-error \
  --title "Hotfix: Correct critical BOM error" \
  --body "## Issue
Fuse rating in BOM.csv was incorrectly specified as 5A.

## Fix
Corrected to 10A per F002 frozen decision §4.1.

## Impact
Critical - affects part ordering and safety compliance."

# 5. Review and merge PR to main via GitHub

# 6. Also apply to develop (keep in sync)
# Create second PR: hotfix → develop
gh pr create --base develop --head hotfix/fix-critical-bom-error \
  --title "Hotfix: Correct critical BOM error (backport to develop)" \
  --body "Backport of hotfix from main to keep develop in sync."

# 7. Review and merge PR to develop via GitHub

# 8. After both PRs merged, delete hotfix branch
git push origin --delete hotfix/fix-critical-bom-error
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
