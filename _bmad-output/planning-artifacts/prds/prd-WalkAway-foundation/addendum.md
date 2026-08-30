# Addendum — WalkAway foundation

Mechanism for implementers. FR IDs refer to `prd.md`.

## Layout

- `Sources/WalkAwayCore` — settings, presence bands, lock latch. No AppKit.
- `Sources/WalkAway` — menu bar, BLE scan, lock command, autostart.
- Tests cover Core only in this increment. No timing-sensitive asserts: pass `now` in.

## Presence

`band(rssi:lockRssi:)` — `nil` RSSI is away (lost device), not unknown after a device is trusted. Before any sample, band is unknown and does not lock.

Threshold: `rssi >= lockRssi` is near. Default `lockRssi` is `-80`.

## Latch

`PresenceTracker` holds `awaySince` and `lockedThisAbsence`. `evaluate` returns `LockAction.lock` or `LockAction.none`. Disarmed always `none` and does not start `awaySince`.

## Lock command

Production calls System Events `lock screen` (or Control-Command-Q). Injected `LockPort` in tests. Never `pmset sleep` / `displaysleepnow`.

## BLE

CoreBluetooth scan, duplicates on, moving RSSI average (window 5). iPhone random addresses may drop; Watch and AirPods are the reliable picks. Document that in Preferences copy.

Bluetooth off, unauthorized, or unavailable: do not evaluate presence. Do not lock from adapter state.

Lost advertisements while powered on still count as away after `rssiStaleInterval` (3s).

## Persistence

JSON at `~/Library/Application Support/WalkAway/settings.json`.
