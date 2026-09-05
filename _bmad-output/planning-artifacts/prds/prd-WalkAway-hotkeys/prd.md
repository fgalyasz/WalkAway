---
title: Global hotkeys
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/53
---

# PRD: Global hotkeys

Hobby/solo. One user-visible goal: optional shortcuts for Lock Now, Arm, Disarm, and Pause 30 minutes; defaults empty.

## 1. Vision

The menu bar is crowded. Lock Now from the keyboard is the power-user path. Arm and Pause have no system equivalent. Shortcuts are recorded in Preferences. Empty defaults so we do not steal keys.

## 2. User journeys

- **UJ-1. Lock Now.** Sets a shortcut to Lock Now. Key locks; Armed unchanged.
- **UJ-2. Pause.** Shortcut starts a 30-minute pause (same as the menu preset).
- **UJ-3. None set.** 0.1.x; no global monitors that eat keys.
- **UJ-4. Conflict.** macOS rejects registration → Preferences explains; the other shortcuts still work.
- **UJ-5. Disarm / Arm.** Shortcuts match menu behavior (including cancelling a timed pause as in that PRD).

## 3. Features

#### FR-1: Four actions

Optional hotkeys: Lock Now, Arm, Disarm, Pause 30 min. Stored in settings.

**Consequences:**
- Each action can be unset independently.
- Pause shortcut uses the 30-minute preset, not a custom duration.

#### FR-2: Defaults empty

Fresh install registers nothing.

**Consequences:**
- No key is captured until the user records one.

#### FR-3: Record in Preferences

A recorder captures a key combo. Clear button unsets. English copy.

**Consequences:**
- User can set and clear without editing JSON.

#### FR-4: No Accessibility to click our menu

Hotkeys call the same actions as the menu (lock port, arm/disarm/pause). Do not script the status item via Accessibility.

**Consequences:**
- No extra TCC prompt for this feature beyond what recording a global hotkey already needs on that OS version. Do not auto-enable Accessibility.

## 4. Non-goals

- Per-app schemes, vim chords, more than these four actions.
- Changing the system Control-Command-Q lock.

## 5. Success metrics

- **SM-1**: Recorded Lock Now shortcut locks immediately; Armed unchanged.
- **SM-2**: No shortcuts set → typing is unaffected.
- **SM-C1**: No Accessibility scripting of other apps; no password stored.
