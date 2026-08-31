import AppKit
import WalkAwayCore

protocol PreferencesHost: AnyObject {
    func readSettings() -> WalkAwaySettings
    func readDevices() -> [DiscoveredDevice]
    func writeSettings(_ settings: WalkAwaySettings)
}

final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    let preferencesViewController: PreferencesViewController

    init(host: PreferencesHost) {
        preferencesViewController = PreferencesViewController(host: host)
        super.init(window: makePreferencesWindow(preferencesViewController))
        window?.delegate = self
        window?.isReleasedWhenClosed = false
    }

    required init?(coder: NSCoder) { nil }

    func show() {
        _ = preferencesViewController.view
        preferencesViewController.reloadFromHost()
        guard let window else { return }
        PanelActivation.shared.show(window)
    }

    func windowWillClose(_ notification: Notification) {
        perform(#selector(endPanelIfNeeded), with: nil, afterDelay: 0.1)
    }

    @objc func endPanelIfNeeded() {
        PanelActivation.shared.endIfNoKeyWindow()
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
