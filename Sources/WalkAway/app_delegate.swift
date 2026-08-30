import AppKit
import WalkAwayCore

final class AppDelegate: NSObject, NSApplicationDelegate, StatusItemActions {
    private var status: StatusItemController?
    private var settings: WalkAwaySettings
    private let settingsURL: URL
    private let lockPort: LockPort

    override init() {
        settingsURL = defaultSettingsURL()
        settings = loadSettings(from: settingsURL)
        lockPort = SystemLockPort()
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        let item = StatusItemController()
        item.actions = self
        item.apply(settings: settings)
        status = item
    }

    func toggleArm() {
        if settings.trustedDeviceId == nil { return }
        settings.armed.toggle()
        persistAndRefresh()
    }

    func lockNow() {
        lockPort.lockScreen()
    }

    func quitApp() {
        NSApp.terminate(nil)
    }

    private func persistAndRefresh() {
        try? saveSettings(settings, to: settingsURL)
        status?.apply(settings: settings)
    }
}
