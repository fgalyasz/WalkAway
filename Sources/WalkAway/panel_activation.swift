import AppKit
import WalkAwayCore

enum PanelActivation {
    static func begin() {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    static func endIfNoKeyWindow() {
        let count = visibleKeyableWindowCount()
        if PanelActivationPolicy.shouldUseRegularPolicy(visibleKeyableWindowCount: count) {
            return
        }
        NSApp.setActivationPolicy(.accessory)
    }

    static func visibleKeyableWindowCount() -> Int {
        NSApp.windows.filter(\.isVisible).filter(\.canBecomeKey).count
    }
}
