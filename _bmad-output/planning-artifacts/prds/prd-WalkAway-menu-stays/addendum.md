# Addendum — Menu bar icon stays

Mechanism for implementers. FR IDs refer to `prd.md`.

`deviceMenuRows` in Core maps discovered devices (plus a trusted placeholder) to id and title. `reloadFromHost` returns unless `isViewLoaded`. Popup rebuild adds `NSMenuItem`s onto `devicePopup.menu`. `bleMonitorDidUpdate` may still call reload; the view-loaded guard makes that a no-op until Preferences has loaded its view.
