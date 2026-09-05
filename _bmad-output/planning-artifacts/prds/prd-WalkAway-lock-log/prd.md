---
title: Lock event log
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/45
---

# PRD: Lock event log

Hobby/solo. One user-visible goal: Preferences shows the last ~20 local events so “it locked while I was here” and “it never locks” have an answer.

## 1. Vision

Support without telemetry. A ring buffer on disk: locked (presence), Lock Now, skipped because Bluetooth off, skipped because paused, armed, disarmed. Copy as text for a bug report. No network.

## 2. User journeys

- **UJ-1. False lock.** Opens log: Away 8.2s, RSSI −88, lock. She raises Return RSSI.
- **UJ-2. Never locks.** Log shows Bluetooth off or paused or never Armed.
- **UJ-3. Relaunch.** Last events still there, capped at ~20.
- **UJ-4. Copy.** Copy as text puts a plain English/timestamp dump on the pasteboard.

## 3. Features

#### FR-1: Ring buffer

WalkAway appends events locally. Cap ~20. Oldest dropped. Path under Application Support.

**Consequences:**
- 21st event drops the oldest.
- Quit/relaunch keeps the file.

#### FR-2: Event kinds

Record at least: presence lock (include delay and last RSSI if known), Lock Now, Bluetooth not evaluating, pause skip (if we would have locked or when pause starts — keep it simple: pause start/end, adapter not evaluating, arm, disarm).

**Consequences:**
- A presence lock line is distinguishable from Lock Now.
- Adapter-off does not look like a lock.

#### FR-3: Preferences list

A short list in Preferences (or an adjacent panel) shows newest first with timestamps.

**Consequences:**
- User can read it without Console.app.

#### FR-4: Copy as text

A button copies the current buffer as UTF-8 text. Nothing is uploaded.

**Consequences:**
- Pasteboard contains the log. No HTTP.

## 4. Non-goals

- Cloud telemetry, crash vendors, screenshots, RSSI time-series dumps beyond the last sample on a lock line.

## 5. Success metrics

- **SM-1**: After a presence lock, the newest line is that lock with enough RSSI/delay to tune.
- **SM-2**: Copy as text works offline.
- **SM-C1**: Log never leaves the Mac except via the user’s pasteboard.
