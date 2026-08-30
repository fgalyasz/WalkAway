import AppKit

final class AboutWindowController: NSWindowController, NSWindowDelegate {
    init() {
        super.init(window: makeAboutWindow())
        window?.delegate = self
        window?.isReleasedWhenClosed = false
    }

    required init?(coder: NSCoder) { nil }

    func show() {
        PanelActivation.begin()
        perform(#selector(presentWindow), with: nil, afterDelay: 0)
    }

    @objc func presentWindow() {
        guard let window else { return }
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {
        perform(#selector(endPanelIfNeeded), with: nil, afterDelay: 0)
    }

    @objc func endPanelIfNeeded() {
        PanelActivation.endIfNoKeyWindow()
    }
}

func makeAboutWindow() -> NSWindow {
    let window = NSWindow(contentViewController: AboutViewController())
    window.title = "About WalkAway"
    window.styleMask = [.titled, .closable]
    window.isReleasedWhenClosed = false
    window.setContentSize(NSSize(width: 420, height: 220))
    window.level = .floating
    return window
}
