# Addendum — Auto-install updates

Mechanism. FR IDs refer to `prd.md`. Extends `prd-WalkAway-sparkle-updates`.

## Sparkle

Keep `SPUStandardUpdaterController(startingUpdater: true)` only when `UpdaterLaunchPolicy.shouldStartUpdater` is true.

- Info.plist `SUAutomaticallyUpdate` = **true** (default on for a fresh DMG). `build_dmg.sh` currently writes false; flip it.
- `SUEnableAutomaticChecks` stays true. Do not set `SUScheduledCheckInterval` (24h default).
- After `start()`, set `controller.updater.automaticallyDownloadsUpdates` from the same user-facing switch so a Preferences change applies without relaunch if Sparkle allows; otherwise document that the next launch applies it.
- Bind the checkbox to Sparkle’s setting, not a parallel `UserDefaults` key that can drift.

When `automaticallyDownloadsUpdates` is true, Sparkle downloads and installs in the background; the user is prompted to **relaunch**, not to Install. When false, Sparkle’s standard update alert with Install remains.

`Check for Updates…` still calls `checkForUpdates:`.

## Upgrade default

Older DMGs shipped `SUAutomaticallyUpdate` false. Sparkle may have persisted that. First launch of this version should treat “user never had a toggle” as **on**: one-shot set `automaticallyDownloadsUpdates` true unless a later user toggle already exists. There is no prior toggle UI, so a one-shot force-on at this feature’s first launch is correct.

## Preferences

Add **Install updates automatically** below Launch at Login, above the privacy hint. English UI. Window height may need a few extra points.

## Tests

- Policy: auto-on vs auto-off path is explicit on `SparkleUpdateService` (or a tiny wrapper) so unit tests do not boot Sparkle.
- `swift run` skip unchanged (`UpdaterLaunchPolicy`).
- Do not hit tenprintsoftware.com in unit tests.

## Website

Optional one-liner in FAQ/features: updates can install automatically from the app. Not a blocker for the DMG.
