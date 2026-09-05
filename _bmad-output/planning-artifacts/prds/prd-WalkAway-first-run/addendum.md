# Addendum — First-run

Mechanism for implementers. FR IDs refer to `prd.md`.

## Flag

`firstRunCompleted` in settings.json, or infer completed when a trusted device was ever saved. Prefer an explicit flag so skip without a device still suppresses the panel.

## Placement

Reuse `PanelPlacement` / activation used by Preferences and About.

## Picker

Share device menu rows with Preferences; do not fork sort/reload rules.
