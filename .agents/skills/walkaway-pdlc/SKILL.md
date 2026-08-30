---
name: walkaway-pdlc
description: >-
  Run the WalkAway product PDLC for a new feature or user-visible bugfix.
  Use when the user wants a feature, product bugfix, PRD, epic, story, release,
  or says PDLC / tervezés / építsük meg.
---

# WalkAway PDLC

Read and follow `{project-root}/docs/pdlc.md`. Do not skip steps on a Feature or Fix track.

## On activation

1. Classify Feature / Fix / Chore.
2. If Chore, implement the change only.
3. If Feature or Fix, execute the pipeline in `docs/pdlc.md` in order.
4. Scaffold with `{project-root}/scripts/pdlc-new.sh <slug>` when starting a new PRD folder.
5. Create GitHub issues with `gh issue create` (`--parent` for stories and sub-items). Add each issue to project **#8** (`fgalyasz`, WalkAway) with `{project-root}/scripts/pdlc-project-item.sh <n> "Todo"`. Move Status through In Progress → Done. Templates live in `.github/ISSUE_TEMPLATE/`.
6. After `swift test` is green, review the diff against FR consequences.
7. Update `CHANGELOG.md`, user-facing docs if needed, then `./build_dmg.sh` when that script exists.
8. Commit and `git push origin HEAD`. Close shipped issues and set Project Status to `Done`.

Speak Hungarian to the user. Write artifacts in English.
