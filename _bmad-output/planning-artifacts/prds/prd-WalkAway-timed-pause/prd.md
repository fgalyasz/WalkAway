---
title: Timed pause
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/30
---

# PRD: Timed pause

Hobby/solo. One user-visible goal: pause locking for 15, 30, or 60 minutes, or until a clock, then Arm again automatically.

## 1. Vision

Permanent Disarm is how people survive a demo and then leave the Mac unlocked all day. Pause is a bounded unlocked window. When it ends, WalkAway Arms if a trusted device is still set.

Disarm stays Disarm until the user Arms. Pause is not sleep and not lock.

## 2. User journeys

- **UJ-1. Standup.** Pause for 30 minutes. Walks around. No lock. At +30 minutes Armed again.
- **UJ-2. Until 17:00.** Pause until 17:00. At 17:00 Armed.
- **UJ-3. No device at expiry.** Timer ends, no trusted device → stays unable to Arm; menu says why.
- **UJ-4. Disarm during pause.** Disarm cancels the timer and stays disarmed.
- **UJ-5. Arm during pause.** Arm cancels the timer and is Armed now.
- **UJ-6. Quit during pause.** Relaunch: remaining pause still applies if end time is in the future; if past, Arm as on expiry.

## 3. Features

#### FR-1: Pause presets

Menu: Pause for 15 / 30 / 60 minutes. While paused, presence never locks. Lock Now still locks.

**Consequences:**
- Armed + pause 15 → walk away → no presence lock for 15 minutes.
- Lock Now during pause still locks the screen.

#### FR-2: Pause until a clock

Menu or a small field: pause until a clock time today (if that time is still ahead). Same pause semantics as FR-1.

**Consequences:**
- Pause until 17:00 at 16:00 → unpause at 17:00.
- Chosen time already past → do not start a pause (or reject).

#### FR-3: Expiry arms

When the pause end is reached, WalkAway Arms if a trusted device is set; otherwise it does not evaluate presence and explains in the menu.

**Consequences:**
- Device still selected at expiry → Armed.
- Device cleared during pause → not Armed at expiry.

#### FR-4: Menu shows remaining time

While paused, the menu shows that WalkAway is paused and the remaining time or end clock.

**Consequences:**
- Open menu mid-pause → remaining time is visible.
- Pause and Disarm are distinct labels.

#### FR-5: Persist pause end

`pauseUntil` (absolute time) lives in settings. Relaunch honors a future end; a past end runs expiry once.

**Consequences:**
- Quit at T+5 of a 30-minute pause, relaunch at T+6 → still paused.
- Relaunch after end → Armed if device set (FR-3).

## 4. Non-goals

- Calendar or Focus-driven pause.
- Pause while Keynote is frontmost.
- Changing away delay here.

## 5. Success metrics

- **SM-1**: Pause 15 minutes, walk away, screen stays unlocked; after 15 minutes a new walk-away can lock.
- **SM-2**: Disarm during pause does not auto-arm at the old end time.
- **SM-C1**: Pause never sleeps the Mac and never stores a password.
