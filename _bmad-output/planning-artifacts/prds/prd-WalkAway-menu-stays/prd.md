---
title: Menu bar icon stays
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: https://github.com/fgalyasz/WalkAway/issues/17
---

# PRD: Menu bar icon stays

Hobby/solo. One user-visible goal: WalkAway stays in the menu bar after launch. Bluetooth discovery must not kill the process.

## 1. Vision

WalkAway is a menu bar app. 0.1.4 creates Preferences at launch, then BLE discovery reloads the device popup before that view is in a window. `NSPopUpButton.item(at:)` aborts. The status item vanishes. The app must keep running whether Preferences is open or not.

## 2. User journeys

- **UJ-1. Launch.** Open WalkAway. The menu icon stays. Arm, Lock Now, Preferences remain usable after devices appear.
- **UJ-2. Open Preferences later.** Preferences still lists discovered devices without crashing.

## 3. Features

#### FR-1: Process stays alive

Bluetooth discovery does not terminate WalkAway.

**Consequences:**
- Preferences UI is not rebuilt until its view is loaded.
- Device popup rows are added as menu items, not by index into an empty menu.

#### FR-2: Device list still updates

When Preferences is open, new devices still appear in the popup.

**Consequences:**
- Reload after `viewDidLoad` keeps working.

## 4. Non-goals

- Changing BLE scan policy.
- Changing Preferences layout.

## 5. Success metrics

- **SM-1**: After install, the menu icon is still there a minute later with Bluetooth on.
- **SM-C1**: Quit is still only Quit WalkAway.
