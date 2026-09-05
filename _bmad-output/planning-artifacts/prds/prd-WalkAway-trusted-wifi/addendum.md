# Addendum — Trusted Wi-Fi pause

Mechanism for implementers. FR IDs refer to `prd.md`.

## Policy

Core: `shouldEvaluatePresence` also false when currentSSID is in the trusted set (and the feature is on). Inject current SSID in tests; do not call CoreWLAN in unit tests.

Timed pause and Wi-Fi pause: either one is enough to skip presence lock.

## API

Read SSID from CoreWLAN / NEHotspotHelper-free path. If the OS hides SSID without location permission, document: add-current may be unavailable; do not silently require Location if we can avoid it. If macOS requires location for SSID, that is an implementation decision logged here when discovered — do not auto-enable Location.

## Foundation non-goal

This PRD reopens trusted Wi-Fi as opt-in. Foundation PRD non-goals stay for YubiKey, calendar, Focus, etc.
