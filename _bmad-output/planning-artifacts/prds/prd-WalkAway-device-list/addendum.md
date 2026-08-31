# Addendum — Device list stays selectable

Mechanism for implementers. FR IDs refer to `prd.md`.

`sortedDevicesForMenu` orders by localized name, then id. `deviceMenuRows` uses that order. `shouldReloadDeviceMenu(isOpen:)` is false while the popup menu is tracking. Preferences observes `NSMenu.didBeginTrackingNotification` / `didEndTrackingNotification` on the popup menu. `bleMonitorDidUpdate` calls `reloadDevicesFromHost`, not a full control reload.
