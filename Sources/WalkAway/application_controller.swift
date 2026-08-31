import AppKit
import WalkAwayCore

final class ApplicationController: NSObject, StatusItemActions, PreferencesHost, BlePresenceMonitorDelegate {
    private var settings: WalkAwaySettings
    private let settingsURL: URL
    private let lockPort: LockPort
    private let ble = BlePresenceMonitor()
    private let loop = PresenceLoop()
    private var status: StatusItemController?
    private var preferences: PreferencesWindowController?
    private let about = AboutWindowController()
    private let sparkleUpdateService = SparkleUpdateService()

    override init() {
        settingsURL = defaultSettingsURL()
        settings = loadSettings(from: settingsURL)
        lockPort = SystemLockPort()
        super.init()
        settings.launchAtLogin = syncedLaunchAtLogin(stored: settings.launchAtLogin)
        preferences = PreferencesWindowController(host: self)
    }

    func start() {
        ble.delegate = self
        ble.trustedDeviceId = settings.trustedDeviceId
        showStatusItem()
        ble.start()
        loop.start { [weak self] in self?.tick() }
        applyLaunchAtLogin(desired: settings.launchAtLogin)
        sparkleUpdateService.start()
    }

    func toggleArm() {
        if settings.trustedDeviceId == nil { return }
        settings.armed.toggle()
        persistAndRefresh()
    }

    func lockNow() {
        lockPort.lockScreen()
    }

    func openPreferences() {
        preferences?.show()
    }

    func openAbout() {
        about.show()
    }

    func checkForUpdates() {
        sparkleUpdateService.checkForUpdates()
    }

    func quitApp() {
        NSApp.terminate(nil)
    }

    func readSettings() -> WalkAwaySettings { settings }

    func readDevices() -> [DiscoveredDevice] {
        ble.devices(now: Date())
    }

    func writeSettings(_ settings: WalkAwaySettings) {
        let deviceChanged = self.settings.trustedDeviceId != settings.trustedDeviceId
        self.settings = settings
        ble.trustedDeviceId = settings.trustedDeviceId
        if deviceChanged { loop.reset() }
        persistAndRefresh()
        applyLaunchAtLogin(desired: settings.launchAtLogin)
    }

    func bleMonitorDidUpdate(_ monitor: BlePresenceMonitor) {
        refreshChrome()
        preferences?.preferencesViewController.reloadDevicesFromHost()
    }
}

private extension ApplicationController {
    func showStatusItem() {
        let item = StatusItemController()
        item.actions = self
        item.apply(settings: settings, adapter: ble.status)
        status = item
    }

    func tick() {
        refreshChrome()
        if shouldEvaluatePresence(adapter: ble.status, settings: settings) == false { return }
        let rssi = ble.trustedRssi(now: Date())
        let action = loop.evaluate(settings: settings, rssi: rssi, now: Date())
        if action == .lock { lockPort.lockScreen() }
    }

    func persistAndRefresh() {
        try? saveSettings(settings, to: settingsURL)
        refreshChrome()
    }

    func refreshChrome() {
        status?.apply(settings: settings, adapter: ble.status)
    }
}
