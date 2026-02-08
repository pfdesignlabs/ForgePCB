# /status/DEFINITIONS.md — Status Meanings and Rules

## Work Item Status
- **PLANNED**: Exists, not started.
- **IN_PROGRESS**: Actively being executed.
- **BLOCKED**: Cannot proceed; blocking reason must be explicit.
- **DONE**: Acceptance criteria met, verification recorded.

## Feature State (Recommended)
- **DRAFT**: Still gathering decisions.
- **FROZEN**: Invariants and interfaces locked; safe for work-item derivation.
- **STABLE**: Implementable without open architectural unknowns.

## Rules
- A status change without a reason is invalid.
- Any deviation from Features requires a decision log entry.
- Humans do not create work items; Claude Code does.
