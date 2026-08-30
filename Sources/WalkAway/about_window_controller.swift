import AppKit

final class AboutWindowController: NSWindowController {
    init() {
        super.init(window: nil)
        window = makeAboutWindow()
    }

    required init?(coder: NSCoder) { nil }

    func show() {
        guard let window else { return }
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
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
