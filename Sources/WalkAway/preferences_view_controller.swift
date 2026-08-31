import AppKit
import WalkAwayCore

final class PreferencesViewController: NSViewController {
    weak var host: PreferencesHost?
    let deviceLabel = NSTextField(labelWithString: "Trusted device")
    let devicePopup = NSPopUpButton(frame: .zero, pullsDown: false)
    let deviceHint = NSTextField(wrappingLabelWithString: "")
    let rssiLabel = NSTextField(labelWithString: "Lock RSSI threshold")
    let rssiValue = NSTextField(labelWithString: "")
    let rssiSlider = NSSlider(value: -80, minValue: -100, maxValue: -40, target: nil, action: nil)
    let delayLabel = NSTextField(labelWithString: "Away delay")
    let delayValue = NSTextField(labelWithString: "")
    let delaySlider = NSSlider(value: 8, minValue: 3, maxValue: 60, target: nil, action: nil)
    let launchCheckbox = NSButton(checkboxWithTitle: "Launch at login", target: nil, action: nil)
    let launchHint = NSTextField(wrappingLabelWithString: "")
    let privacyHint = NSTextField(wrappingLabelWithString: "")
    var isReloading = false

    init(host: PreferencesHost) {
        self.host = host
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 480, height: 430))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureControls()
        layoutContent()
        reloadFromHost()
    }

    func reloadFromHost() {
        guard isViewLoaded, let settings = host?.readSettings() else { return }
        isReloading = true
        applySettingsToControls(settings)
        reloadDevicePopup(settings, host?.readDevices() ?? [])
        isReloading = false
    }
}

private extension PreferencesViewController {
    func configureControls() {
        deviceHint.stringValue =
            "Apple Watch is the reliable pick. iPhone BLE addresses may change."
        launchHint.stringValue =
            "Launch at login works only when running as an .app bundle (not via swift run)."
        privacyHint.stringValue =
            "The first lock asks permission to control System Events. WalkAway never stores your password."
        wireActions()
        styleHints()
    }

    func wireActions() {
        devicePopup.target = self
        devicePopup.action = #selector(deviceChanged)
        rssiSlider.target = self
        rssiSlider.action = #selector(rssiChanged)
        delaySlider.target = self
        delaySlider.action = #selector(delayChanged)
        launchCheckbox.target = self
        launchCheckbox.action = #selector(launchChanged)
    }

    func styleHints() {
        [deviceHint, launchHint, privacyHint].forEach { hint in
            hint.textColor = .secondaryLabelColor
            hint.font = NSFont.systemFont(ofSize: 11)
        }
        rssiSlider.numberOfTickMarks = 0
        delaySlider.numberOfTickMarks = 0
        delaySlider.allowsTickMarkValuesOnly = false
    }

    func applySettingsToControls(_ settings: WalkAwaySettings) {
        rssiSlider.integerValue = settings.lockRssi
        rssiValue.stringValue = "\(settings.lockRssi) dBm"
        delaySlider.integerValue = settings.awayDelaySeconds
        delayValue.stringValue = "\(settings.awayDelaySeconds) s"
        launchCheckbox.state = settings.launchAtLogin ? .on : .off
    }

    func reloadDevicePopup(_ settings: WalkAwaySettings, _ devices: [DiscoveredDevice]) {
        guard let menu = devicePopup.menu else { return }
        menu.removeAllItems()
        deviceMenuRows(devices, settings: settings).forEach { addDeviceMenuRow(menu, $0) }
        selectTrustedDevice(settings.trustedDeviceId)
    }

    func addDeviceMenuRow(_ menu: NSMenu, _ row: DeviceMenuRow) {
        let item = NSMenuItem(title: row.title, action: nil, keyEquivalent: "")
        item.representedObject = row.id
        menu.addItem(item)
    }

    func selectTrustedDevice(_ id: String?) {
        guard let id else { return }
        let index = devicePopup.itemArray.firstIndex { $0.representedObject as? String == id }
        if let index { devicePopup.selectItem(at: index) }
    }

    @objc func deviceChanged() {
        if isReloading { return }
        guard let settings = host?.readSettings() else { return }
        guard let id = devicePopup.selectedItem?.representedObject as? String else { return }
        let name = devicesName(for: id)
        host?.writeSettings(settingsWithDevice(settings, deviceId: id, deviceName: name))
    }

    @objc func rssiChanged() {
        if isReloading { return }
        guard var settings = host?.readSettings() else { return }
        settings.lockRssi = clampRssi(rssiSlider.integerValue)
        rssiValue.stringValue = "\(settings.lockRssi) dBm"
        host?.writeSettings(settings)
    }

    @objc func delayChanged() {
        if isReloading { return }
        guard var settings = host?.readSettings() else { return }
        settings.awayDelaySeconds = clampDelay(delaySlider.integerValue)
        delayValue.stringValue = "\(settings.awayDelaySeconds) s"
        host?.writeSettings(settings)
    }

    @objc func launchChanged() {
        if isReloading { return }
        guard var settings = host?.readSettings() else { return }
        settings.launchAtLogin = launchCheckbox.state == .on
        host?.writeSettings(settings)
    }

    func devicesName(for id: String) -> String {
        let devices = host?.readDevices() ?? []
        return devices.first(where: { $0.id == id })?.name ?? "Trusted device"
    }
}
