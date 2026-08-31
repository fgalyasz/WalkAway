import AppKit

final class AboutWindowController: NSWindowController, NSWindowDelegate {
    init() {
        super.init(window: makeAboutWindow())
        window?.delegate = self
        window?.isReleasedWhenClosed = false
    }

    required init?(coder: NSCoder) { nil }

    func show() {
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

func makeAboutWindow() -> NSWindow {
    let rect = NSRect(x: 0, y: 0, width: 420, height: 220)
    let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    window.title = "About WalkAway"
    window.isReleasedWhenClosed = false
    window.contentViewController = AboutViewController()
    return window
}
