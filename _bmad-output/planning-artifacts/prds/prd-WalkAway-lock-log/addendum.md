# Addendum — Lock event log

Mechanism for implementers. FR IDs refer to `prd.md`.

## Storage

JSON array in Application Support, newest last or first — pick one and sort in UI. Tests: cap, persist, kinds. No clocks that depend on `sleep`.

## Privacy

No device advertisement payload dumps. Device display name + RSSI integer is enough on lock lines.
