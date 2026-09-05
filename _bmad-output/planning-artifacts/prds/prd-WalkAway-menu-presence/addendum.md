# Addendum — Menu presence

Mechanism for implementers. FR IDs refer to `prd.md`.

## State source

Menu copy is a pure function of: armed, adapter evaluable, band, lastLockAt, trusted device present. Put that in Core so tests do not need AppKit.

## Status item

Reuse existing lock template if possible; variant images or a title string. Avoid animation here (warning PRD owns pulse).

## Last lock

Store ISO-8601 or epoch in settings.json. Lock Now and presence lock both write it.
