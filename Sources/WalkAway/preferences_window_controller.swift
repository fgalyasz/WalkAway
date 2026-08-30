import AppKit
import WalkAwayCore

protocol PreferencesHost: AnyObject {
    func readSettings() -> WalkAwaySettings
    func readDevices() -> [DiscoveredDevice]
    func writeSettings(_ settings: WalkAwaySettings)
}

final class PreferencesWindowController: NSWindowController {
    let preferencesViewController: PreferencesViewController

    init(host: PreferencesHost) {
        preferencesViewController = PreferencesViewController(host: host)
        super.init(window: nil)
        window = makePreferencesWindow(preferencesViewController)
    }

    required init?(coder: NSCoder) { nil }

    func show() {
        preferencesViewController.reloadFromHost()
        guard let window else { return }
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

func makePreferencesWindow(_ content: NSViewController) -> NSWindow {
    let window = NSWindow(contentViewController: content)
    window.title = "Preferences"
    window.styleMask = [.titled, .closable]
    window.isReleasedWhenClosed = false
    window.setContentSize(NSSize(width: 480, height: 430))
    return window
}
