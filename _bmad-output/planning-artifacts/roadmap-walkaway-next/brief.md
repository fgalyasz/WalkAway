---
title: WalkAway next increment — ten feature ideas
status: selected
created: 2026-09-02
updated: 2026-09-02
---

# WalkAway next increment

Hobby/solo. Foundation (0.1.x) already locks the screen when you walk away with a trusted BLE device and does not sleep the Mac. This brief picks the next ten features users will thank us for, ranked by usefulness then importance. Ferenc selects a subset. Each selected item becomes a PDLC PRD and GitHub issues on project #8. No issues until that pick.

## 1. Vision

WalkAway should feel inevitable after one afternoon: pick a Watch, see that it is Near, walk to the kitchen, lock. Today the mechanism works and the windows work. The product still hides its state, makes RSSI a guess, and punishes a demo with a forgotten Disarm.

The next wave does not add auto-unlock, sleep, accounts, or a companion phone app. It makes the lock you already have trustworthy and pauseable. Notarized download is parked until a Developer ID exists.

## 2. Ranking method

Each idea scored 1–5:

- **Usefulness (U)** — daily value for someone who already Armed WalkAway.
- **Importance (I)** — activation, trust, distribution, or competitive gap.

**Score = 2×U + I.** Usefulness is weighted because the request was user delight first. Effort (S/M/L) and core-risk inform sequence, not rank. Core-risk is high if the idea threatens lock-not-sleep, no password, or local-only.

Parked ideas (auto-unlock, sleep, YubiKey, Focus/Calendar, iPhone companion, Polar, in-app localization) stay in `addendum.md`.

## 3. Ranked ideas

### 1. Proximity tuner — live RSSI and hysteresis — P0

| | |
|---|---|
| Score | **15** (U5 / I5) |
| Effort | M |
| Core-risk | Low |
| Slug | `proximity-tuner` |

**Job.** Preferences show a live signal for the trusted device. Two bands: lock when weaker than Lock RSSI; count as Near again only when stronger than Return RSSI. Optional “sit at the desk / stand in the doorway” helper sets both.

**Why users want it.** −80 is a magic number. Rooms, Watch orientation, and USB-C hubs change RSSI. Users either get false locks at the desk or no lock at the door. Competitors that survive all expose a meter.

**Why it advances WalkAway.** Turns BLE from a black box into a calibrated tool. Unlocks every later presence feature. Core already has a single threshold; hysteresis is the correct presence model.

**Journeys.**

- UJ-1. Anna opens Preferences. The meter moves as she lifts her wrist. She stands in the doorway, taps Use this as lock, sits down, taps Use this as return.
- UJ-2. Flapping at the desk: Return RSSI is 8 dB stronger than Lock RSSI. Walking the room no longer lock-unlock-locks the latch.

**In.** Live RSSI (smoothed, same window as Core). Lock RSSI and Return RSSI. Defaults: lock −80, return lock+8, clamped. Meter does not lock by itself.

**Out.** Heatmaps, floor plans, auto-calibrate with no user action, exposing raw CoreBluetooth noise.

---

### 2. Presence in the menu — P0

| | |
|---|---|
| Score | **15** (U5 / I5) |
| Effort | S |
| Core-risk | Low |
| Slug | `menu-presence` |

**Job.** The status item and the first menu rows say Armed/Disarmed, Near/Away/Unknown, a short signal hint, and “Last lock: 2 minutes ago” when there is one. Bluetooth off is explicit: not evaluating, will not lock.

**Why users want it.** After install the icon is a lock glyph. You cannot tell if WalkAway sees the Watch. When it “does not work,” the first question is always: was I Away?

**Why it advances WalkAway.** Trust is the product. A menu bar utility that hides its only state looks broken. This is also the surface for pause countdown and pre-lock warning later.

**Journeys.**

- UJ-1. Armed, Watch on the wrist at the desk → menu: Armed · Near.
- UJ-2. Bluetooth off → menu: Bluetooth is off. WalkAway will not lock. No presence evaluation.
- UJ-3. After a real lock → Last lock: 3:14 PM.

**In.** Status derived from existing `PresenceTracker` / adapter state. Status item image or title may change by band. Copy stays English in-app.

**Out.** Graphs in the menu, notification center spam, Dock badge.

---

### 3. Timed pause — auto re-arm — P0

| | |
|---|---|
| Score | **14** (U5 / I4) |
| Effort | S–M |
| Core-risk | Low |
| Slug | `timed-pause` |

**Job.** Menu: Pause for 15 / 30 / 60 minutes, or Pause until a clock. While paused, presence never locks. When the timer ends, WalkAway Arms again if a trusted device is still set. Disarm remains permanent until the user Arms.

**Why users want it.** The demo, the kitchen conversation, the hallway call. Permanent Disarm is how people “turn it off” and then leave the Mac unlocked for the rest of the day.

**Why it advances WalkAway.** Same job as SessionGuard’s timed session, inverted: stay unlocked for a bounded window, then restore the lock habit. Differentiates from abandoned BLE lockers that only have on/off.

**Journeys.**

- UJ-1. Before a standup: Pause for 30 minutes. Walks around. No lock. At +30 min Armed again.
- UJ-2. Pause until 17:00. At 17:00 Armed. If no trusted device, stays disarmed and the menu says why.
- UJ-3. During pause, Disarm cancels the timer and stays disarmed. Arm cancels the timer and is Armed now.

**In.** Presets 15/30/60. Optional until-clock. Menu shows remaining time. Pause does not sleep or lock.

**Out.** Calendar/Focus-driven pause, “pause while Keynote is frontmost” (parked as a later latch).

---

### 4. First-run that proves the lock — P1

| | |
|---|---|
| Score | **13** (U4 / I5) |
| Effort | M |
| Core-risk | Low |
| Slug | `first-run` |

**Job.** First launch with no trusted device: a short panel (not a website). Pick device → see live signal (depends on idea 1 or a minimal meter) → Arm → “Walk out of range. The screen will lock. Your jobs keep running.” Does not lock during the picker itself unless Armed.

**Why users want it.** Preferences buried behind a menu bar they just installed is how utilities die. The promise is one afternoon; the UI should enact it.

**Why it advances WalkAway.** Activation metric SM-1 only happens if they pick a device and Arm. Catalog copy cannot do that.

**Journeys.**

- UJ-1. Fresh install. Panel: choose Watch, Arm, dismiss. Next launches skip the panel.
- UJ-2. User closes the panel with no device. App stays in the menu. Armed stays off. Menu still explains why.
- UJ-3. Returning user who already has settings.json: no panel.

**In.** One-shot, skippable. Launch at Login offered here, still off by default.

**Out.** Account, iCloud, forced tutorial video, Accessibility permission theatre.

---

### 5. Pre-lock warning — P1

| | |
|---|---|
| Score | **12** (U4 / I4) |
| Effort | S |
| Core-risk | Low |
| Slug | `pre-lock-warning` |

**Job.** When Away is in progress and lock is due in N seconds (default 3, range 0–10, 0 = off), the status item pulses and an optional system sound plays. Coming Near cancels. The lock itself is unchanged.

**Why users want it.** False locks at the edge of the room feel hostile. A beat to step back or raise the wrist is the difference between “clever” and “I uninstalled it.”

**Why it advances WalkAway.** Complements hysteresis. Warning without hysteresis still helps; together they kill the main complaint of BLE lockers.

**Journeys.**

- UJ-1. Delay 8s, warning 3s. At away+5s the icon pulses. At +8s lock. She steps back at +6s → Near, no lock.
- UJ-2. Warning 0: silent as today.

**In.** Menu-bar visual. Optional sound, off by default (meetings). No notification banners that steal focus during a screen share if we can avoid them.

**Out.** Spoken VoiceOver-only custom utterances, iMessage “your Mac locked.”

---

### 6. Second trusted device (OR) — P1

| | |
|---|---|
| Score | **12** (U4 / I4) |
| Effort | M |
| Core-risk | Medium |
| Slug | `second-device` |

**Job.** Up to two trusted BLE devices. Near if either is near. Away only if both are away or lost. Primary remains the Watch; phone is fallback when the Watch is charging.

**Why users want it.** Watch on the charger, phone in the pocket, Mac unlocked at the desk is the actual evening. One-device FR-3 does not cover it.

**Why it advances WalkAway.** Same product, fewer “it failed because I left the Watch.” iPhone random addresses stay documented; Watch still the reliable pick.

**Journeys.**

- UJ-1. Watch + iPhone. Leaves Watch on charger, walks with phone → no lock. Leaves both → lock after delay.
- UJ-2. Only one configured: behavior identical to 0.1.x.

**In.** Two slots. OR semantics only (not AND — AND would lock when you leave the phone in the other room). Preferences list both.

**Out.** N devices, geofence, iCloud device list, pairing a device that does not advertise.

---

### 7. Notarized, signed download — PARKED

| | |
|---|---|
| Score | **11** (U3 / I5) |
| Effort | M (account/certs, not code) |
| Core-risk | Low |
| Slug | `notarized-dmg` |

**Parked 2026-09-02.** No Apple Developer ID. Membership cost is not justified while WalkAway (and the catalog) do not earn. Reopen this PRD when a paid account exists. Do not create GitHub issues for this slug now.

**Job.** The public DMG is Developer ID signed and notarized. Double-click install. Sparkle updates stay signed. Gatekeeper does not require right-click Open as the normal path.

**Why users want it.** Unsigned menu-bar apps that lock the screen look like malware. Friends will not install what macOS scares them off.

**Why it advances WalkAway.** Distribution is product. Sparkle already assumes a trusted feed; notarization completes the trust chain SnappyZones/SessionGuard may already have.

**Journeys.**

- UJ-1. Download from tenprintsoftware.com. Open DMG, drag to Applications, launch. No unidentified-developer dead end.
- UJ-2. Sparkle update replaces with another notarized build.

**In.** Signing identity, notary, staple, updated build script. Website copy can drop the “if macOS blocks it” FAQ if true.

**Out.** Mac App Store, sandbox that kills BLE + lock.

---

### 8. Lock event log — P2

| | |
|---|---|
| Score | **10** (U3 / I4) |
| Effort | S–M |
| Core-risk | Low |
| Slug | `lock-log` |

**Job.** Preferences (or a short About-adjacent panel): last ~20 local events. Examples: locked (RSSI −91 for 8s), skipped (Bluetooth off), skipped (paused), armed, disarmed. Timestamps. No network. User can copy as text for a bug report.

**Why users want it.** “It locked while I was here” and “it never locks” are the two support mails. Without a log we guess.

**Why it advances WalkAway.** Makes support cheap. Pairs with the menu’s last-lock line. Local-only keeps the privacy promise.

**Journeys.**

- UJ-1. False lock. Opens log: Away 8.2s, RSSI −88, lock. She raises Return RSSI.
- UJ-2. Quit and relaunch: log persists in Application Support, capped.

**In.** Ring buffer on disk. No RSSI time series dump unless we already store samples for the meter.

**Out.** Cloud telemetry, crash analytics vendors, screenshots.

---

### 9. Trusted Wi-Fi pause — P2

| | |
|---|---|
| Score | **11** (U4 / I3) |
| Effort | M |
| Core-risk | Medium (privacy) |
| Slug | `trusted-wifi` |

**Job.** Optional: while associated to named SSIDs (e.g. home), treat as paused — presence does not lock. Other networks: normal Armed behavior. SSIDs stored locally. Off by default. Foundation listed trusted Wi-Fi as a non-goal; this increment reopens it as opt-in.

**Why users want it.** Home office: walking to the printer should not lock. Cafe: it should. This is the most requested rule in Dynamic Lock-class tools after “pause for a meeting.”

**Why it advances WalkAway.** Location-shaped without Core Location. Still local. Document that SSID is not a security boundary (neighbor spoof).

**Journeys.**

- UJ-1. Adds “HomeNet”. At home, Armed, walks to kitchen: no lock. Menu: Paused on HomeNet.
- UJ-2. Cafe Wi-Fi: locks as today.
- UJ-3. Ethernet only / Wi-Fi off: no SSID match → normal presence.

**In.** List of SSIDs, current SSID display, add current. No geofence.

**Out.** Trusted BSSID-only as v1 (maybe later), VPN names, “trusted IP.”

---

### 10. Global hotkeys — P2

| | |
|---|---|
| Score | **9** (U3 / I3) |
| Effort | S |
| Core-risk | Low |
| Slug | `hotkeys` |

**Job.** Optional shortcuts: Lock Now, Arm, Disarm, Pause 30 min. Defaults empty (no stolen keys). Recorded in Preferences. Conflict copy if macOS rejects registration.

**Why users want it.** Menu bar is crowded. Lock Now from the keyboard is the power-user equivalent of Control-Command-Q, but Arm/Pause have no system equivalent.

**Why it advances WalkAway.** Accessibility and speed. Small, independent, good Polar-preview polish later.

**Journeys.**

- UJ-1. Sets ⌃⌥L to Lock Now. Key locks; Armed unchanged.
- UJ-2. No shortcuts set: 0.1.x behavior.

**In.** Four actions max. Local, no Accessibility API to click our own menu.

**Out.** Per-app hotkey schemes, vim-style chords.

## 4. Suggested waves

Ship in this order unless Ferenc cuts:

| Wave | Ideas | Outcome |
|---|---|---|
| **A — trust** | 1 tuner, 2 menu presence, 3 timed pause | Calibrated, visible, pauseable. Daily driver. |
| **B — activation** | 4 first-run, 5 warning, 6 second device | New users succeed; Watch-on-charger covered. |
| **C — power** | 8 log, 9 trusted Wi-Fi, 10 hotkeys | Support, home-office rule, keyboard. |

Idea 2 is cheap and should land with or immediately after 1. Idea 7 (notarization) is parked until a Developer ID exists.

## 5. Non-goals for this roadmap

Unchanged from foundation unless a later PRD explicitly reopens:

- Auto-unlock, storing the login password.
- Sleeping the Mac, lid-close theft alarm.
- YubiKey, calendar, Focus, iPhone companion, iPad, iCloud.
- Polar / paid tier as a prerequisite for these ten (all ten can ship free).
- Mac App Store.
- SessionGuard process integration.

## 6. Next step

Selected 2026-09-02: ideas 1–6 and 8–10. Idea 7 parked. PRDs and GitHub epics are on project **#8**:

- Wave A: [#23](https://github.com/fgalyasz/WalkAway/issues/23) proximity tuner, [#27](https://github.com/fgalyasz/WalkAway/issues/27) menu presence, [#30](https://github.com/fgalyasz/WalkAway/issues/30) timed pause
- Wave B: [#34](https://github.com/fgalyasz/WalkAway/issues/34) first-run, [#37](https://github.com/fgalyasz/WalkAway/issues/37) pre-lock warning, [#41](https://github.com/fgalyasz/WalkAway/issues/41) second device
- Wave C: [#45](https://github.com/fgalyasz/WalkAway/issues/45) lock log, [#49](https://github.com/fgalyasz/WalkAway/issues/49) trusted Wi-Fi, [#53](https://github.com/fgalyasz/WalkAway/issues/53) hotkeys
