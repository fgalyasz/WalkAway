---
title: Sparkle updates
status: final
created: 2026-08-31
updated: 2026-08-31
parent_issue: https://github.com/fgalyasz/WalkAway/issues/7
---

# PRD: Sparkle updates

Hobby/solo. One user-visible goal: WalkAway checks the website for a newer build and can install it from the menu, like SnappyZones and SessionGuard.

## 1. Vision

0.1.0 ships as a DMG. The next build should not require hunting GitHub. Installed from the DMG, WalkAway notices a newer published version, offers it, and replaces itself. `swift run` does not start the updater.

## 2. User journeys

- **UJ-1. Newer version published.** This copy is 0.1.0. The site publishes 0.1.1. After launch WalkAway offers the update. Confirm. Download, install, relaunch. No browser.
- **UJ-2. Check from the menu.** Check for Updates… runs the same updater. Current → short up-to-date alert. Newer → same install path as UJ-1.
- **UJ-3. Network fails.** Background check is quiet. Menu-triggered check reports the failure.
- **UJ-4. Postpone.** Dismiss leaves this copy running. The next launch may offer again.
- **UJ-5. swift run.** Check for Updates… explains that updates need the .app from the DMG.

## 3. Features

#### FR-1: Check after launch

When running from an installed `.app`, WalkAway queries the update feed after launch.

**Consequences:**
- `swift run` / non-bundle builds do not start the updater.
- A bundle build starts the updater after launch.

#### FR-2: Newer version is offered

If the feed’s latest version is newer than this copy, the updater presents that version and an install action.

**Consequences:**
- Feed newer than local → install UI.
- Feed equal to local → no install UI from the background check.

#### FR-3: Background failure is quiet

A failed background check does not lock, disarm, or quit.

**Consequences:**
- Offline launch → app still Armed/Disarmed as before.
- Menu check still available.

#### FR-4: Check for Updates menu

The status menu has Check for Updates…. It runs the same updater. Confirm-then-install is the default until [Auto-install updates](../prd-WalkAway-auto-install-updates/prd.md); when that switch is on, there is no Install click.

**Consequences:**
- Menu item is visible in the .app and in `swift run`.
- `swift run` shows why the updater is unavailable.
- Confirming an update replaces the `.app` and relaunches.

#### FR-5: Published feed on the website

`build_dmg.sh` writes a signed Sparkle appcast and zip. The feed URL is the TenPrint WalkAway downloads path.

**Consequences:**
- Appcast and zip are reachable at `https://tenprintsoftware.com/downloads/walkaway/`.
- Info.plist `SUFeedURL` matches that appcast.
- Private EdDSA key is not in git.

## 4. Non-goals

- Apple Developer ID notarization.
- Silent relaunch with no Sparkle UI. Auto-install with a user toggle is [Auto-install updates](../prd-WalkAway-auto-install-updates/prd.md) (supersedes the earlier “`SUAutomaticallyUpdate` stays false” non-goal).
- A dedicated walkaway.com domain.
- Updating a `swift run` binary.

## 5. Success metrics

- **SM-1**: Installed 0.1.0 (or any older .app) offers 0.1.1 from the menu after the site publishes it.
- **SM-2**: `swift run` never starts Sparkle.
- **SM-C1**: Private Sparkle key never lands in the repo.
