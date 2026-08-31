# Addendum — Preferences window appears

Mechanism for implementers. FR IDs refer to `prd.md`.

## Cause

`LSUIElement` / `NSApp.setActivationPolicy(.accessory)` plus a status-item menu. `makeKeyAndOrderFront` during menu dismissal does not leave a key window. About used `.floating`; Preferences did not.

## Fix

`PanelActivationPolicy` in Core decides regular vs accessory from the visible keyable window count. `PanelActivation` switches to `.regular`, waits 0.25s, then `orderFrontRegardless()` + `makeKeyAndOrderFront`. Status-menu clicks must not activate the app in the same turn. Closing the last normal panel returns to `.accessory`.
