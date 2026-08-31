# Addendum — Preferences window appears

Mechanism for implementers. FR IDs refer to `prd.md`.

## Cause

`LSUIElement` / `NSApp.setActivationPolicy(.accessory)` plus a status-item menu. `makeKeyAndOrderFront` during menu dismissal does not leave a key window. About used `.floating`; Preferences did not.

## Fix

`PanelActivationPolicy` in Core decides regular vs accessory from the visible keyable window count. `PanelPlacement` centers the frame on the pointer’s screen. `PanelActivation` switches to `.regular`, then `orderFrontRegardless()`. Status menu item actions present that panel on the next run loop. Do not open from `menuDidClose` (that event can run before the item action).
