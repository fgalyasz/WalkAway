# Addendum — Global hotkeys

Mechanism for implementers. FR IDs refer to `prd.md`.

## Storage

Store key code + modifiers in settings. Core can validate/serialize; AppKit registers `NSEvent` / Carbon hotkeys. Tests cover parse/round-trip, not live key delivery.

## Pause

If timed-pause is not shipped yet, hide or disable the Pause shortcut until that PRD lands — or no-op with menu copy. Prefer shipping pause first (Wave A before C).
