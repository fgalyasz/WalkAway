---
title: Preferences window appears
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: https://github.com/fgalyasz/WalkAway/issues/12
---

# PRD: Preferences window appears

Hobby/solo. One user-visible goal: Preferences… and About WalkAway open a visible window from the menu bar.

## 1. Vision

WalkAway is an accessory menu bar app. Preferences exists, but clicking the menu item does not show a window. The user cannot pick a device or change delay. The window must come to the front, then the app can go back to accessory when it closes.

## 2. User journeys

- **UJ-1. Open Preferences.** Menu → Preferences…. A Preferences window appears on the active space, in front. Device, RSSI, delay, Launch at Login are usable.
- **UJ-2. Open About.** Menu → About WalkAway. The About window appears the same way.
- **UJ-3. Close.** Closing the last of those windows does not quit WalkAway. The Dock icon goes away again.

## 3. Features

#### FR-1: Preferences is visible

Preferences… shows the Preferences window in front of other apps.

**Consequences:**
- A click from the status menu still shows the window after the menu dismisses.
- The window is key and on the active Space.

#### FR-2: About is visible

About WalkAway shows the About window in front.

**Consequences:**
- Same activation path as Preferences.

#### FR-3: Closing does not quit

Closing Preferences or About leaves WalkAway in the menu bar.

**Consequences:**
- No Dock icon after the last panel closes.
- Status item stays.

## 4. Non-goals

- Hungarian UI in the app.
- Changing Preferences fields or layout.
- Notarization.

## 5. Success metrics

- **SM-1**: Preferences… from the installed .app opens a window you can see and click.
- **SM-C1**: Quit is still only Quit WalkAway.
