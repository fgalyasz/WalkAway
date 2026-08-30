# WalkAway product PDLC

Every **new product feature** and every **user-visible bugfix** follows this path. The agent does not wait for the user to list the steps. Chat stays Hungarian; artifacts, code, GitHub, and commit messages stay English.

## Track

| Track | When | Skip |
| ----- | ---- | ---- |
| **Feature** | New capability or user-visible change | Nothing below |
| **Fix** | Bug with a product consequence | Coaching-path PRD; still write a thin PRD or investigation + FRs |
| **Chore** | Typo, refactor with no behavior change, process-only | PRD, GitHub epic/project items, DMG, website copy |

## Pipeline

1. **Classify** — Feature, fix, or chore. If chore, do the change and stop.
2. **BMad planning** — Fast path unless Ferenc asks for coaching. Record decisions in `.decision-log.md`.
3. **PRD** — `_bmad-output/planning-artifacts/prds/prd-WalkAway-<slug>/` with `prd.md`, `.decision-log.md`, `addendum.md`, `epics.md`. Hobby/solo, ~2 pages. Stable FR IDs. `./scripts/pdlc-new.sh <slug>` scaffolds the folder.
4. **Epic + stories + GitHub Project** — `gh issue create` `[EPIC] …` then `[STORY]` / `[DEV]` / `[TEST]` sub-issues with `--parent`. Link the PRD in the epic. Put `parent_issue` in PRD frontmatter. Add **every** epic, story, and sub-issue to [WalkAway project #8](https://github.com/users/fgalyasz/projects/8) and set Status:
   - created → `Todo`
   - implementation started → `In Progress`
   - shipped and issue closed → `Done`
   Helper: `./scripts/pdlc-project-item.sh <n> "Todo"`.
5. **Dev** — English names, existing Swift style, no TCC.db writes, no auto-enable of Privacy switches.
6. **Unit tests** — New Core logic ≥95% of the new types. Positive and negative. No timing-sensitive asserts. `swift test` must pass.
7. **Review** — Diff vs FR consequences. If the diff is large, security-sensitive, or Ferenc asks, run `bmad-code-review`. Fix blockers before build.
8. **Changelog + website** — `CHANGELOG.md` first. User-facing copy when the site must explain the change. Then `./build_dmg.sh --patch` (or `--minor` / `--major`) once that script exists.
9. **Commit + push** — One release commit after tests (and DMG when the release path exists). Push `origin HEAD`. Close the GitHub stories and epic. Set those Project items to `Done`.

## Do not

- Skip the PRD because the change “is obvious”.
- Push without green `swift test`.
- Commit secrets or TCC.db.
- Force-push `main`.
- Auto-enable Bluetooth or Accessibility.

## References

- Issue templates: `.github/ISSUE_TEMPLATE/`
- PRD stubs: `docs/pdlc-templates/`
- GitHub Project: [users/fgalyasz/projects/8](https://github.com/users/fgalyasz/projects/8)

If `gh project` returns Forbidden, refresh token scopes: `gh auth refresh -s project`.
