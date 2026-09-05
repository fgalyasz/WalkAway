---
title: Auto-install updates
status: final
created: 2026-09-03
updated: 2026-09-03
parent_issue: https://github.com/fgalyasz/WalkAway/issues/56
---

# PRD: Auto-install updates

Hobby/solo. When automatic install is on, a published newer build downloads and replaces this copy without an Install click.

This extends [Sparkle updates](../prd-WalkAway-sparkle-updates/prd.md) (`#7`). Background check, quiet launch failure, Check for Updates…, and `swift run` skip stay as they are. When auto-install is on, it supersedes that PRD’s “user confirms” path and the non-goal that `SUAutomaticallyUpdate` stays false.

## 1. Vision

Sparkle already checks the WalkAway feed about once a day. Today it still waits for **Install**. Ferenc wants the DMG copy to apply the update: replace `WalkAway.app`, then relaunch. A Preferences switch turns that on or off.

## 2. User journeys

- **UJ-1. Auto on, newer feed.** This copy is 0.1.7. The site publishes 0.1.8. After the usual background check, Sparkle downloads the zip, replaces the app, and asks to relaunch. No Install button. No browser. No Finder DMG.
- **UJ-2. Auto off.** Same as today: background check may show Sparkle’s install prompt; Ferenc confirms or postpones.
- **UJ-3. Toggle.** Preferences has **Install updates automatically**, default on, near Launch at Login. Turning it off restores UJ-2 for later checks. Turning it on applies to the next check.
- **UJ-4. Menu check, auto on.** Check for Updates… uses the same updater. If newer, download/replace without Install. If current, “up to date.” Network error is visible (existing Sparkle PRD).
- **UJ-5. `swift run`.** No updater. Unavailable alert on Check for Updates…. The new checkbox is irrelevant.

## 3. Features

#### FR-1: Preferences switch

Preferences shows **Install updates automatically**. Default **on** for new and upgraded DMG copies. The value is what Sparkle uses (`automaticallyDownloadsUpdates` / `SUAutomaticallyUpdate`), not a second shadow flag.

**Consequences:**
- The checkbox exists in Preferences, near Launch at Login.
- Default is on.
- Changing it changes the next automatic and menu-triggered update path.

#### FR-2: On → download and replace without Install

When the switch is on and the feed is newer, Sparkle downloads the enclosure and replaces this `.app` without an Install confirmation. The only remaining Sparkle UI is relaunch (or equivalent) so the new binary runs. Menu-bar life: after replace, the user must get a relaunch path; postponing relaunch leaves the old process in memory until quit/relaunch.

**Consequences:**
- Auto on + newer feed → no Install click required.
- Auto on + same version → no replace.
- Cancel/later on relaunch does not roll back a completed replace; the next launch is the new build.

#### FR-3: Off → confirm Install (existing)

When the switch is off, keep the current confirm-then-replace flow from the Sparkle updates PRD.

**Consequences:**
- Auto off + newer feed → Install (or later) before replace.
- Cancel leaves this copy’s files unchanged.

#### FR-4: Existing updater contract

Launch check, 24h Sparkle interval, quiet background failure, Check for Updates…, signed appcast zip, and no updater outside a `.app` bundle do not change.

**Consequences:**
- `swift run` still does not start Sparkle.
- Failed launch check still has no alert.

## 4. Non-goals

- Silent relaunch with **no** Sparkle UI at all (custom `SPUUserDriver`).
- Changing the 24-hour check interval.
- Auto-update for `swift run` / unsigned copies.
- A dedicated walkaway.com domain.
- Developer ID notarization.

## 5. Success metrics

- **SM-1**: A DMG copy with the switch on replaces itself from the live appcast without an Install click.
- **SM-C1**: Switch off still requires confirm before replace. `swift run` still has no updater.
