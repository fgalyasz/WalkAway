# Addendum — Pre-lock warning

Mechanism for implementers. FR IDs refer to `prd.md`.

## Core

`PresenceTracker.evaluate` can return a new action or a parallel `shouldWarn` derived from `awaySince`, delay, and warningSeconds. Prefer a pure `warningActive(now:)` for tests.

Sound-once: flag on the current absence, cleared when Near.

## AppKit

Pulse the status item only. No notification permission prompt.
