# Changelog

## 0.1.6 — 2026-08-31

- Preferences… opens Preferences, and About WalkAway opens About, on that click. Earlier builds could open the previous menu item’s window.

## 0.1.5 — 2026-08-31

- WalkAway stays in the menu bar after launch. Bluetooth discovery no longer crashes the app while Preferences is still closed.

## 0.1.4 — 2026-08-31

- Preferences and About open on the screen under the pointer. The previous builds could put the window on a display that is not visible.

## 0.1.3 — 2026-08-31

- Preferences… and About WalkAway now come to the front: wait for regular activation, then order the window front regardless of the status menu.

## 0.1.2 — 2026-08-31

- Preferences… and About WalkAway open a visible window from the menu bar (accessory apps need a brief regular activation).

## 0.1.1 — 2026-08-31

- Check for Updates… in the menu. Installed copies query tenprintsoftware.com and can install a newer build.
- `swift run` does not start the updater; the menu explains that the DMG build is required.

## 0.1.0 — 2026-08-31

- Menu bar app: Armed/Disarmed, Lock Now, Preferences, About.
- Trusted BLE device (Apple Watch or iPhone), RSSI threshold, away delay, lock once per absence.
- Lock the screen, do not sleep. No auto-unlock. No password stored.
- Launch at Login via SMAppService. Off by default.
