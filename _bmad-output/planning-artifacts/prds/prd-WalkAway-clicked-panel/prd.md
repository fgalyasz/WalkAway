---
title: Clicked panel is the one that opens
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: https://github.com/fgalyasz/WalkAway/issues/19
---

# PRD: Clicked panel is the one that opens

Hobby/solo. One user-visible goal: Preferences… opens Preferences, About WalkAway opens About, on that click.

## 1. Vision

0.1.5 can show a window, but the wrong one. About does nothing; the next Preferences click opens About; the next About click opens Preferences. The item that was clicked must be the window that appears.

## 2. User journeys

- **UJ-1. About.** Menu → About WalkAway. The About window appears. Preferences stays closed.
- **UJ-2. Preferences.** Menu → Preferences…. The Preferences window appears. About stays closed unless it was already open.
- **UJ-3. Both.** Open About, then Preferences. Both windows can be visible. Each click still maps to that item.

## 3. Features

#### FR-1: About opens About

About WalkAway shows the About window on that click.

**Consequences:**
- No dependency on a previous menu selection.
- Do not open About from a later Preferences click.

#### FR-2: Preferences opens Preferences

Preferences… shows the Preferences window on that click.

**Consequences:**
- Same as FR-1, swapped.

## 4. Non-goals

- Changing window layout or fields.
- Closing the other panel when one opens.

## 5. Success metrics

- **SM-1**: First click on About shows About. First click on Preferences shows Preferences.
- **SM-C1**: Quit is still only Quit WalkAway.
