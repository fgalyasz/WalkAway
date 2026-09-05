# Addendum — Proximity tuner

Mechanism for implementers. FR IDs refer to `prd.md`.

## Presence bands

Replace single `rssi >= lockRssi` near-test with:

- `nil` or stale → away (unchanged).
- `rssi < lockRssi` → away.
- `rssi >= returnRssi` → near.
- else → previous band; if unknown, treat as away (do not lock from unknown).

Default `returnRssi = min(lockRssi + 8, maxRssi)`.

## Meter

Preferences reads the same moving average the tracker uses. Do not run a second unsmoothed feed on the meter.

## Tests

Core: band transitions, clamp, migration of missing returnRssi. No timing-sensitive asserts; pass `now` and RSSI samples in.
