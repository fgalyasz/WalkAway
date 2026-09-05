---
title: Second trusted device
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/41
---

# PRD: Second trusted device

Hobby/solo. One user-visible goal: up to two trusted BLE devices; Near if either is near; Away only if both are away or lost.

## 1. Vision

The Watch on the charger and the phone in the pocket is the evening. One-device FR-3 leaves the Mac unlocked. OR semantics: you are present if any trusted device is present. AND would lock when the phone is in the other room — hostile, out of scope.

Watch remains the reliable pick; iPhone random addresses stay documented.

## 2. User journeys

- **UJ-1. Watch + phone.** Leaves Watch charging, walks with phone → no lock. Leaves both → lock after delay.
- **UJ-2. One device.** Only slot one filled → identical to 0.1.x.
- **UJ-3. Clear second.** Removing the second device returns to one-device rules immediately.
- **UJ-4. Both lost.** Both stale/nil → away, then lock after delay once.

## 3. Features

#### FR-1: Two slots

Settings store up to two trusted device IDs (and display names). Preferences lists both. Slot two is optional.

**Consequences:**
- One ID → same as foundation.
- Two IDs → both are scanned/matched.

#### FR-2: OR presence

Near if any trusted device is near (using current hysteresis if the tuner shipped). Away only if every configured trusted device is away or lost.

**Consequences:**
- Watch away, phone near → Near, no lock.
- Both away → Away, delay then one lock.

#### FR-3: Arm still needs at least one

Cannot Arm with zero devices. One device is enough.

**Consequences:**
- Empty slots → cannot Arm (foundation).
- One slot filled → can Arm.

#### FR-4: Picker does not steal slot one by accident

Adding a second device is an explicit second row/action. Changing slot one does not clear slot two unless the same device would duplicate; duplicates are rejected.

**Consequences:**
- Same BLE ID in both slots is not stored twice.
- Device list reload rules stay as in 0.1.7.

## 4. Non-goals

- More than two devices.
- AND semantics, geofence, iCloud device list.
- Pairing a device that does not advertise.

## 5. Success metrics

- **SM-1**: Watch on charger, phone in pocket, Armed, walk to kitchen → no lock.
- **SM-2**: Leave both behind → one lock after delay.
- **SM-C1**: One-device users keep 0.1.x behavior.
