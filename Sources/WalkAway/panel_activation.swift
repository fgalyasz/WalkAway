import AppKit
import WalkAwayCore

final class PanelActivation: NSObject {
    static let shared = PanelActivation()
    private var pending: NSWindow?

    func show(_ window: NSWindow) {
        pending = window
        NSApp.setActivationPolicy(.regular)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(orderPendingFront), with: nil, afterDelay: 0.25)
    }

    @objc func orderPendingFront() {
        guard let window = pending else { return }
        prepare(window)
        NSApp.activate(ignoringOtherApps: true)
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
    }

    func prepare(_ window: NSWindow) {
        window.collectionBehavior.insert(.moveToActiveSpace)
        window.center()
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
