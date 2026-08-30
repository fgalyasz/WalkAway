---
title: WalkAway foundation
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: pending
---

# PRD: WalkAway foundation

Hobby/solo. One user-visible goal: when you walk away from the Mac with your Watch or iPhone, the screen locks and your jobs keep running.

## 1. Vision

macOS unlocks with Apple Watch. It does not lock when you leave. Windows has had Dynamic Lock since 2016. Third-party Mac tools exist; most are abandoned, noisy, or sleep the machine.

WalkAway is a menu bar utility. Armed, it watches one trusted BLE device. Away past a short delay, it locks the screen. It does not sleep the Mac. Builds, downloads, and renders continue. Disarmed, it does nothing. Free, local, no account.

SessionGuard is the opposite product in the TenPrint catalog: keep the session alive. WalkAway lets it go.

## 2. User journeys

- **UJ-1. First arm.** Anna installs the DMG, picks her Watch, leaves Armed on. She walks to the kitchen. After the delay the lock screen is up. ffmpeg is still running.
- **UJ-2. Back at the desk.** She unlocks with Watch or Touch ID (system, not WalkAway). WalkAway is still Armed and will lock on the next leave.
- **UJ-3. Stay unlocked.** She disarms from the menu before a demo. Walking around does not lock. She arms again when done.
- **UJ-4. Lock now.** She chooses Lock Now. The screen locks immediately. Presence state is unchanged.
- **UJ-5. No device yet.** First launch with no trusted device: Armed is off until she picks one. The menu says so.

## 3. Features

#### FR-1: Menu bar app

WalkAway lives in the menu bar. No Dock icon. Menu: status, Arm/Disarm, Lock Now, Preferences, About, Quit.

**Consequences:**
- Launch shows a status item, not a window.
- Quit is explicit. Closing Preferences does not quit.

#### FR-2: Armed and disarmed

One toggle. Armed evaluates presence and may lock. Disarmed never locks from presence. Default after a trusted device is set: Armed.

**Consequences:**
- Disarmed + walk away → no lock.
- Armed + walk away past delay → lock once per absence.

#### FR-3: One trusted BLE device

The user picks one Apple Watch or iPhone (or any advertising BLE device the picker lists). WalkAway measures RSSI against a lock threshold.

**Consequences:**
- No device selected → cannot Arm; menu explains why.
- Signal stronger than or equal to the threshold → near.
- Weaker than the threshold, or lost → away.

#### FR-4: Away delay then lock once

Away must last `awayDelaySeconds` (default 8, range 3–60) before lock. One lock per absence. Near again clears the latch.

**Consequences:**
- Away for 3s with delay 8 → no lock.
- Away for 8s+ → one lock. Still away → no second lock.
- Near after a lock → next leave can lock again.

#### FR-5: Lock the screen, do not sleep

Lock uses the system lock screen. CPU and processes stay up. WalkAway does not call sleep or `pmset displaysleepnow`.

**Consequences:**
- After lock, a running encode continues.
- Display may dim under system settings; WalkAway does not force sleep.

#### FR-6: No auto-unlock

WalkAway does not type the password and does not unlock. Return uses system Unlock with Apple Watch, Touch ID, or password.

**Consequences:**
- Near again after lock → no unlock action from WalkAway.
- Password is never stored.

#### FR-7: Preferences

Preferences set: trusted device, lock RSSI threshold, away delay, Launch at Login.

**Consequences:**
- Changes persist across relaunch.
- Launch at Login uses `SMAppService`. Off by default.

#### FR-8: Lock Now

Menu action locks immediately, Armed or not, if the lock service can run.

**Consequences:**
- Lock Now does not change Armed.
- Lock Now does not require a trusted device.

## 4. Non-goals

- Auto-unlock or storing the login password.
- YubiKey, trusted Wi-Fi, calendar, or Focus rules.
- iPhone companion app, iPad, or iCloud.
- Polar / Pro license in this increment.
- Sleep, lid-close, or theft alarm (unplug siren).
- SessionGuard process integration.
- Mac App Store.

## 5. Success metrics

- **SM-1**: Armed user walks away with the Watch; lock screen appears after the delay; a running job is still running.
- **SM-2**: Disarmed user walks away; Mac stays unlocked.
- **SM-C1**: WalkAway never stores the user password.
- **SM-C2**: One absence produces at most one lock.
