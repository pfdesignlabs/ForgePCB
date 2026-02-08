# /status/NEXT.md — What To Do Next

## Claude Code Instruction (Priority)

Claude Code MUST generate work items to establish the Git repository
infrastructure for ForgePCB and its integration with ForgeOS.

This includes, but is not limited to:
- Creating the GitHub repository `pfdesignlabs/ForgePCB`
- Initializing git history in ForgePCB
- Defining ForgePCB as the authoritative source of truth
- Adding ForgePCB as a Git subtree inside ForgeOS at `components/forgepcb/`
- Documenting and enforcing correct commit boundaries
- Defining the standard update workflow (`git subtree pull ... --squash`)
- Creating guard rails to prevent committing changes inside the subtree (recommended)

No human-authored work items are allowed for this task.

## Resume Rule
Do not start execution work unless:
- A Claude-generated work item exists
- It is inside the current ACTIVE_SLICE
