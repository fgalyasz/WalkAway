---
title: Menu presence
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/27
---

# PRD: Menu presence

Hobby/solo. One user-visible goal: the menu bar tells you Armed/Disarmed, Near/Away, last lock, and when Bluetooth is off so WalkAway will not lock.

## 1. Vision

The status item is a lock glyph. You cannot tell if WalkAway sees the Watch. “It does not work” always starts with: was I Away?

The first menu rows and the status item derive from Core presence and adapter state. Bluetooth off is explicit. A last-lock timestamp appears after a real lock this process (and persists across relaunch if cheap).

## 2. User journeys

- **UJ-1. At the desk.** Armed, Watch on the wrist → menu: Armed · Near (and a short signal hint if we already have RSSI).
- **UJ-2. Bluetooth off.** Menu: Bluetooth is off. WalkAway will not lock. No presence evaluation (foundation rule).
- **UJ-3. After a lock.** Menu: Last lock: a relative or clock time.
- **UJ-4. Disarmed.** Menu: Disarmed. Presence may still show Near/Away as informational, or hide lock-risk copy; it never locks.
- **UJ-5. No trusted device.** Cannot Arm; menu still says why (foundation) plus no presence band.

## 3. Features

#### FR-1: Presence rows in the menu

The status menu shows Armed or Disarmed, then Near, Away, or Unknown, using the same bands Core uses. Adapter unavailable/off/unauthorized is a distinct row: not evaluating, will not lock.

**Consequences:**
- Armed + near → those two facts are visible without Preferences.
- Bluetooth off → no “Away” that implies a lock is coming.

#### FR-2: Status item reflects band

The status item image or accessibility title changes enough to distinguish Disarmed, Armed-Near, Armed-Away, and not-evaluating. English copy.

**Consequences:**
- Glance at the bar without opening the menu: at least Armed vs Disarmed vs problem.
- Does not use a Dock badge.

#### FR-3: Last lock line

After WalkAway locks (presence or Lock Now), the menu shows when. Persist last lock time in settings. Missing/never → omit the line.

**Consequences:**
- Lock Now updates last lock.
- Relaunch still shows the last lock if stored.

## 4. Non-goals

- Graphs in the menu.
- Notification Center spam.
- Hungarian in-app copy.
- Pre-lock pulse (separate PRD).

## 5. Success metrics

- **SM-1**: Armed user can answer “does it see my Watch?” from the menu in one look.
- **SM-2**: Bluetooth off never looks like Away-about-to-lock.
- **SM-C1**: Displaying state does not change when we lock; lock policy stays in Core.
