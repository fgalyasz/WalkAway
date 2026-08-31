# Addendum — Clicked panel is the one that opens

Mechanism for implementers. FR IDs refer to `prd.md`.

`StatusItemController` handlers for Preferences, About, and Check for Updates schedule the matching `StatusItemActions` method with `perform(_:with:afterDelay:)` `0`. They do not store a pending panel, and they are not `NSMenuDelegate`. `PanelActivation.show` still switches to `.regular` and orders the window after a short delay.
