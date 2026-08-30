import AppKit
import WalkAwayCore

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let applicationController = ApplicationController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        applicationController.start()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
