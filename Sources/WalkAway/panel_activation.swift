import AppKit
import WalkAwayCore

final class PanelActivation: NSObject {
    static let shared = PanelActivation()
    private var pending: NSWindow?

    func show(_ window: NSWindow) {
        pending = window
        NSApp.setActivationPolicy(.regular)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(orderPendingFront), with: nil, afterDelay: 0.05)
    }

    @objc func orderPendingFront() {
        guard let window = pending else { return }
        placeOnActiveScreen(window)
        NSApp.activate(ignoringOtherApps: true)
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
    }

    func placeOnActiveScreen(_ window: NSWindow) {
        let screen = screenUnderPointer() ?? NSScreen.main ?? NSScreen.screens.first
        guard let screen else { return }
        let frame = PanelPlacement.centeredFrame(visibleFrame: screen.visibleFrame, size: window.frame.size)
        window.setFrame(frame, display: true)
    }

    func screenUnderPointer() -> NSScreen? {
        let point = NSEvent.mouseLocation
        return NSScreen.screens.first { NSMouseInRect(point, $0.frame, false) }
    }

    func endIfNoKeyWindow() {
        let count = visibleKeyableWindowCount()
        if PanelActivationPolicy.shouldUseRegularPolicy(visibleKeyableWindowCount: count) {
            return
        }
        NSApp.setActivationPolicy(.accessory)
    }

    func visibleKeyableWindowCount() -> Int {
        NSApp.windows.filter(isNormalKeyablePanel).count
    }

    func isNormalKeyablePanel(_ window: NSWindow) -> Bool {
        window.isVisible && window.canBecomeKey && window.level == .normal
    }
}
