# Addendum — Sparkle updates

Mechanism for implementers. FR IDs refer to `prd.md`.

## Stack

Sparkle 2 via SwiftPM (`from: "2.7.0"`). `SparkleUpdateService` wraps `SPUStandardUpdaterController`. `UpdaterLaunchPolicy.shouldStartUpdater(bundlePath:)` is Core, unit-tested.

## Feed

- `SUFeedURL`: `https://tenprintsoftware.com/downloads/walkaway/appcast.xml`
- Enclosure: `https://tenprintsoftware.com/downloads/walkaway/WalkAway-{VERSION}.zip`
- `AppcastFeedBuilder` in Core builds the XML used by tests. `scripts/write_appcast.py` writes the file at DMG time.

## Keys

Private EdDSA key stays outside git. Sparkle Keychain account defaults to `walkaway` (`SPARKLE_ACCOUNT`). Optional file: `$HOME/.config/walkaway/sparkle_eddsa` or `SPARKLE_ED_KEY_FILE`. Public key is `scripts/sparkle_public_ed_key.txt`, copied into Info.plist as `SUPublicEDKey`.

## Bundle

`build_dmg.sh` embeds `Sparkle.framework`, adds `@executable_path/../Frameworks` rpath, zips the `.app` with `ditto --keepParent`, signs with `sign_update`, writes appcast, copies artifacts to TenPrint `public/downloads/walkaway/`, deploys the company site.

## Menu

Check for Updates… sits with Preferences / About. `swift run` shows `UpdateMenuCopy.updaterUnavailableMessage`.
