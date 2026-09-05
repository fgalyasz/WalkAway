---
title: Pre-lock warning
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/37
---

# PRD: Pre-lock warning

Hobby/solo. One user-visible goal: in the last seconds before a presence lock, the status item pulses; an optional sound can play; coming Near cancels.

## 1. Vision

False locks at the edge of the room feel hostile. A beat to step back or raise the wrist is the difference between clever and uninstalled. The lock itself, the delay, and the once-per-absence latch stay as in foundation.

## 2. User journeys

- **UJ-1. Warning then lock.** Away delay 8s, warning 3s. At away+5s the icon pulses. At +8s lock. Default sound off.
- **UJ-2. Cancel.** She steps back at +6s → Near, pulse stops, no lock.
- **UJ-3. Warning off.** Warning seconds = 0 → silent as 0.1.x, lock at delay only.
- **UJ-4. Disarmed or paused.** No warning, no presence lock.
- **UJ-5. Lock Now.** No warning pulse; immediate lock.

## 3. Features

#### FR-1: Warning window

Settings: `warningSeconds` default 3, range 0–10. 0 disables. Warning starts when remaining time to lock is `<= warningSeconds` and a presence lock is pending.

**Consequences:**
- Delay 8, warning 3, away for 5s → warning on.
- Delay 8, warning 3, away for 4s → no warning yet.

#### FR-2: Status item pulse

During the warning window the status item visibly pulses or otherwise changes until lock, Near, disarm, or pause.

**Consequences:**
- Warning on → user can see it without a banner.
- Near → pulse stops.

#### FR-3: Optional sound

A system sound may play at the start of the warning window. Default off. At most once per absence.

**Consequences:**
- Sound off → visual only.
- Sound on, flap Near/Away → one sound per absence, not a strobe.

#### FR-4: No focus-stealing banner

Do not post a Notification Center alert that would steal focus during a screen share. Menu bar + optional sound only.

**Consequences:**
- No `NSUserNotification` / UserNotifications banner for this warning.

## 4. Non-goals

- Spoken custom utterances.
- iMessage “your Mac locked.”
- Changing hysteresis (proximity-tuner PRD).

## 5. Success metrics

- **SM-1**: With delay 8 and warning 3, a user who returns at second 6 is not locked.
- **SM-2**: Warning 0 matches current lock timing.
- **SM-C1**: Warning never unlocks and never sleeps the Mac.
