---
title: Proximity tuner
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/23
---

# PRD: Proximity tuner

Hobby/solo. One user-visible goal: Preferences show a live signal for the trusted device, and lock vs return RSSI bands stop the desk from flapping.

## 1. Vision

WalkAway’s lock threshold is a single number. −80 is a guess. Rooms, Watch orientation, and hubs change RSSI. Users either lock while sitting or never lock at the door.

Preferences show the same smoothed RSSI Core already uses. Two bands: weaker than Lock RSSI is away; Near again only when stronger than Return RSSI. Optional desk/doorway buttons write those two values from the live sample.

## 2. User journeys

- **UJ-1. See the signal.** Anna opens Preferences with her Watch on. The meter moves as she lifts her wrist. The numeric RSSI matches what presence uses.
- **UJ-2. Calibrate.** She stands in the doorway, taps Use this as lock, sits down, taps Use this as return. Armed walk-away uses those bands.
- **UJ-3. No flap.** Return RSSI is stronger than Lock RSSI. Walking the room does not lock-unlock-lock the latch.
- **UJ-4. No device.** No trusted device: meter is idle; calibration buttons do nothing useful; copy says pick a device first.
- **UJ-5. Upgrade.** Existing installs: Return RSSI defaults to Lock RSSI + 8, clamped. One-threshold settings keep working.

## 3. Features

#### FR-1: Live RSSI in Preferences

Preferences show a live, smoothed RSSI for the trusted device (same window as presence). Lost or stale samples show as away/missing, not a frozen last value presented as current.

**Consequences:**
- Open Preferences with a trusted Watch advertising → meter updates.
- Device lost past `rssiStaleInterval` → meter is missing/away, not the last good number as “now”.

#### FR-2: Lock RSSI and Return RSSI

Settings store `lockRssi` and `returnRssi`. Away when RSSI is nil or `< lockRssi`. Near when RSSI `>= returnRssi`. Between the two, keep the previous band (hysteresis). `returnRssi` is always `>= lockRssi`.

**Consequences:**
- RSSI −90, lock −80 → away (same idea as today).
- RSSI −75, return −72, previously away → stay away until −72.
- Invalid pair (return below lock) is rejected or clamped on save.

#### FR-3: Desk / doorway capture

Preferences can set Lock RSSI or Return RSSI from the current smoothed sample. Disabled when there is no current sample.

**Consequences:**
- Doorway tap writes lock from live RSSI.
- Desk tap writes return from live RSSI and keeps return >= lock.

#### FR-4: Defaults and migration

Default lock remains −80. Default return is lock + 8, clamped to a documented RSSI range. Missing `returnRssi` in old JSON migrates on load.

**Consequences:**
- Fresh install: lock −80, return −72.
- Old settings.json with only lockRssi: return = lock + 8 after load/save.

## 4. Non-goals

- Auto-calibrate with no user action.
- Floor plans, heatmaps, raw CoreBluetooth noise UI.
- Changing away delay in this increment (already in foundation).
- Second trusted device (separate PRD).

## 5. Success metrics

- **SM-1**: At the desk the meter is Near; in the doorway after capture, walk-away locks once.
- **SM-2**: With return 8 dB above lock, sitting and shifting in the chair does not produce a lock.
- **SM-C1**: Presence still never stores a password and never auto-unlocks.
