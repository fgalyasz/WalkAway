---
title: First-run
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/34
---

# PRD: First-run

Hobby/solo. One user-visible goal: a fresh install walks you through pick a device, see a signal, Arm, then dismiss — without a website tutorial.

## 1. Vision

Preferences behind a brand-new menu bar icon is how utilities die. First launch with no trusted device opens a short panel on the screen under the pointer (same placement as Preferences). Skip is allowed. Returning users with settings never see it.

## 2. User journeys

- **UJ-1. Fresh install.** Panel: choose Watch (same picker as Preferences), live signal if available, Arm, dismiss. Next launches skip the panel.
- **UJ-2. Skip with no device.** Close/Skip. App stays in the menu. Armed stays off. Menu still explains why.
- **UJ-3. Returning user.** settings.json already has a trusted device (or a completed first-run flag) → no panel.
- **UJ-4. Launch at Login.** Offered on the panel, still off by default.

## 3. Features

#### FR-1: One-shot panel

First launch without a completed first-run shows a panel. Completing (device + Arm or explicit skip) sets a flag so it does not return.

**Consequences:**
- Empty settings, first launch → panel appears.
- Flag set → later launches are menu-bar only as today.

#### FR-2: Pick device and Arm on the panel

The panel can set the trusted device and Arm. Device list behavior matches Preferences (stable order, no reload while the menu/popup is tracking).

**Consequences:**
- Pick Watch, Arm, dismiss → Armed with that device, same as Preferences.
- Cannot Arm with no device (foundation).

#### FR-3: Live signal if present

If a live RSSI is available (proximity tuner or existing smoothed sample), show it. Otherwise a short “waiting for signal” state. The panel does not lock by itself.

**Consequences:**
- Advertising Watch → user sees a number or meter.
- Panel open does not trigger a presence lock unless Armed and the existing policy would lock (keep Armed off until they Arm).

#### FR-4: Skip

Skip/close without a device does not quit WalkAway. Launch at Login remains off unless the user turns it on.

**Consequences:**
- Skip → menu bar app, not Armed.
- Launch at Login checkbox default off.

## 4. Non-goals

- Account, iCloud, video, Accessibility permission theatre.
- Forced walk-away during the panel.
- Replacing Preferences (Preferences stays the full editor).

## 5. Success metrics

- **SM-1**: New install can Arm a Watch from the panel without opening Preferences.
- **SM-2**: Skip leaves a running menu-bar app that does not lock.
- **SM-C1**: First-run never stores a password.
