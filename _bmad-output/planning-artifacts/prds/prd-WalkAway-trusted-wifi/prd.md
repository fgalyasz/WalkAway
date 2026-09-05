---
title: Trusted Wi-Fi pause
status: ready-for-dev
created: 2026-09-02
updated: 2026-09-02
parent_issue: https://github.com/fgalyasz/WalkAway/issues/49
---

# PRD: Trusted Wi-Fi pause

Hobby/solo. One user-visible goal: optional named SSIDs pause presence locking while associated; other networks behave as today.

## 1. Vision

Home office: walking to the printer should not lock. Cafe: it should. Foundation listed trusted Wi-Fi as a non-goal; this increment reopens it as opt-in, local SSIDs only. Off by default. SSID is not a security boundary (neighbor spoof) — copy must say so.

## 2. User journeys

- **UJ-1. Home.** Adds current SSID “HomeNet”. Armed, walks to kitchen on that network → no presence lock. Menu: paused on that SSID (if menu-presence shipped).
- **UJ-2. Cafe.** Different SSID → locks as today.
- **UJ-3. Ethernet / Wi-Fi off.** No matching SSID → normal presence.
- **UJ-4. Off.** Feature disabled or empty list → 0.1.x.
- **UJ-5. Remove SSID.** Removing HomeNet restores locking at home.

## 3. Features

#### FR-1: Opt-in SSID list

Settings store a list of SSID strings. Empty or a master off switch → no Wi-Fi pause. User can add the current SSID and remove rows. No geofence.

**Consequences:**
- Fresh install: no SSIDs, no pause.
- Add current while on HomeNet → HomeNet in the list.

#### FR-2: Associated match pauses presence lock

While Wi-Fi is associated to a listed SSID, presence does not lock. Lock Now still locks. Same idea as timed pause for evaluation, but the reason is SSID.

**Consequences:**
- On listed SSID + Armed + walk away → no presence lock.
- Off that SSID → delay/latch as usual.

#### FR-3: Show current SSID

Preferences shows the current SSID when known, or that Wi-Fi is off / unknown.

**Consequences:**
- User can see what “Add current” would store.

#### FR-4: Local only + spoof copy

SSIDs never leave the Mac. Preferences includes a short note that a nearby network can reuse the same name.

**Consequences:**
- No location permission required for v1 (SSID via system config APIs already used by many menu-bar apps).
- Copy does not claim SSID is authentication.

## 4. Non-goals

- Trusted BSSID-only as the only matcher (may add later).
- VPN names, trusted IP, Core Location geofence.
- Enabling this by default.

## 5. Success metrics

- **SM-1**: Listed home SSID, Armed, walk away → screen stays unlocked; Lock Now still works.
- **SM-2**: Unlisted cafe SSID → presence lock still happens.
- **SM-C1**: SSID list is not uploaded.
