---
title: Device list stays selectable
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: https://github.com/fgalyasz/WalkAway/issues/21
---

# PRD: Device list stays selectable

Hobby/solo. One user-visible goal: the trusted-device popup can be clicked; the item under the pointer is the one that becomes trusted.

## 1. Vision

Preferences lists nearby Apple Watch and iPhone devices. BLE RSSI changes every advertisement, and the menu is rebuilt in RSSI order. Items jump while the list is open, so a click almost never selects the intended device. Order must be stable, and the open menu must not rebuild.

## 2. User journeys

- **UJ-1. Pick a device.** Open the trusted-device popup. Items stay in place. Click one. That device is trusted.
- **UJ-2. Signal changes.** While the list is open, RSSI still changes in the background. The rows do not swap. After the list closes, titles may show a newer RSSI.

## 3. Features

#### FR-1: Stable order

Device rows are ordered by name, then id. RSSI does not change order.

**Consequences:**
- Two devices keep the same relative order when their signals swap.

#### FR-2: Click selects that row

While the popup is open, the menu is not rebuilt. The clicked row is the trusted device.

**Consequences:**
- BLE discovery does not call `removeAllItems` during menu tracking.
- After the menu closes, the list may refresh.

## 4. Non-goals

- Changing how lock RSSI is measured.
- Filtering unnamed devices.

## 5. Success metrics

- **SM-1**: Clicking a named row in the open popup selects that device.
- **SM-C1**: Quit is still only Quit WalkAway.
