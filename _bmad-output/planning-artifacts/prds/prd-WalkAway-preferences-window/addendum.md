# Addendum — Preferences window appears

Mechanism for implementers. FR IDs refer to `prd.md`.

## Cause

`LSUIElement` / `NSApp.setActivationPolicy(.accessory)` plus a status-item menu. `makeKeyAndOrderFront` during menu dismissal does not leave a key window. About used `.floating`; Preferences did not.

## Fix

`PanelActivationPolicy` in Core decides regular vs accessory from the visible keyable window count. `PanelActivation` in the app applies it. Preferences and About call `begin()` then `presentWindow` after a zero delay. `windowWillClose` calls `endIfNoKeyWindow()`.
