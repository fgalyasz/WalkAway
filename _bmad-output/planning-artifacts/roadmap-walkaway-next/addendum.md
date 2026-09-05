# Addendum — WalkAway next increment

Planning notes. Idea IDs refer to `brief.md`.

## Scoring table

| Rank | Slug | U | I | Score | Effort | Wave |
|---:|---|---:|---:|---:|---|---|
| 1 | proximity-tuner | 5 | 5 | 15 | M | A |
| 2 | menu-presence | 5 | 5 | 15 | S | A |
| 3 | timed-pause | 5 | 4 | 14 | S–M | A |
| 4 | first-run | 4 | 5 | 13 | M | B |
| 5 | pre-lock-warning | 4 | 4 | 12 | S | B |
| 6 | second-device | 4 | 4 | 12 | M | B |
| 7 | notarized-dmg | 3 | 5 | 11 | M (certs) | PARKED |
| 8 | lock-log | 3 | 4 | 10 | S–M | C |
| 9 | trusted-wifi | 4 | 3 | 11 | M | C |
| 10 | hotkeys | 3 | 3 | 9 | S | C |

Trusted Wi-Fi scores 11, same as notarization, but ranks 9 because Importance is lower and privacy needs an explicit opt-in PRD. Notarization unblocks people who never launch the app.

## Dependencies

- `menu-presence` can ship without the tuner; the tuner is better if the menu already shows Near/Away.
- `first-run` wants a live meter (idea 1) or a stripped-down RSSI label.
- `pre-lock-warning` uses the same status item as idea 2.
- `second-device` changes Core presence: Near = any device near. Tests must cover one-device regression.
- `lock-log` reads the same lock/pause/adapter events as the menu.
- `trusted-wifi` should show pause state on the menu (idea 2).
- `notarized-dmg` is orthogonal to Swift features.

## Parked (not in the ten)

| Idea | Why parked |
|---|---|
| Auto-unlock / password | Foundation non-goal. Security identity. |
| Sleep the Mac | Opposite of the product. SessionGuard’s neighbor, not WalkAway. |
| YubiKey | Niche, extra hardware, not BLE. |
| Focus / Calendar pause | Privacy + TCC + false “in a meeting.” Timed pause covers the demo. |
| iPhone companion / iPad / iCloud | Foundation non-goal. Random BLE addresses do not get fixed by a phone app we do not want to maintain. |
| In-app Hungarian UI | Site is localized. In-app English matches SnappyZones/SessionGuard. Revisit as a catalog-wide i18n increment. |
| Polar / Pro license | Do not gate Wave A on paywall. |
| Theft / unplug siren | Different product. |
| SessionGuard integration | Two binaries stay independent. |
| Display-sleep after lock | Easy to confuse with system sleep; jobs-keep-running copy would suffer. |
| AND of two devices | Locks when the phone is in the bedroom. Hostile. OR only if we do two devices. |

## Competitive note

Windows Dynamic Lock is native. Mac third parties (historical BLEUnlock, ProximityLock, Unlock) fail on abandonware, sleep-the-machine, or opaque RSSI. WalkAway’s wedge stays: lock not sleep, one-toggle, TenPrint catalog next to SessionGuard. Wave A defends that wedge. Wave B makes it installable and survivable when the Watch is charging.

## Tracker

WalkAway issues live on **GitHub** (`fgalyasz/WalkAway`, project #8), not GitLab.

Selected 2026-09-02: `proximity-tuner`, `menu-presence`, `timed-pause`, `first-run`, `pre-lock-warning`, `second-device`, `lock-log`, `trusted-wifi`, `hotkeys`.

Parked: `notarized-dmg` — no Apple Developer ID yet; membership cost vs unpaid apps. Reopen when a paid account exists.
