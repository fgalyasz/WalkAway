# Addendum — Timed pause

Mechanism for implementers. FR IDs refer to `prd.md`.

## State

Treat pause as `pauseUntil: Date?` in settings, not a boolean. Evaluate with injected `now`. Paused ⇒ `LockAction.none` from presence, same as disarmed, but armed flag may stay true or a tri-state is used.

Prefer: `armed` stays true, `isPaused(now)` gates evaluation. Disarm sets `armed = false` and clears `pauseUntil`.

## Clock

Until-clock is local timezone. Store absolute `Date`.

## Tests

Expiry, disarm-cancels, arm-cancels, relaunch future/past, no device at expiry. No real sleeps in tests.
