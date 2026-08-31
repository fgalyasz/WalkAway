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
    let rect = NSRect(x: 0, y: 0, width: 480, height: 430)
    let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    window.title = "Preferences"
    window.isReleasedWhenClosed = false
    window.contentViewController = content
    return window
}
