import Foundation

public struct DiscoveredDevice: Equatable {
    public let id: String
    public let name: String
    public let rssi: Int?

    public init(id: String, name: String, rssi: Int?) {
        self.id = id
        self.name = name
        self.rssi = rssi
    }
}

public func deviceMenuTitle(_ device: DiscoveredDevice) -> String {
    guard let rssi = device.rssi else { return "\(device.name) (not in range)" }
    return "\(device.name) (\(rssi) dBm)"
}

public func devicesIncludingTrusted(
    _ devices: [DiscoveredDevice],
    settings: WalkAwaySettings
) -> [DiscoveredDevice] {
    guard let id = settings.trustedDeviceId else { return devices }
    if devices.contains(where: { $0.id == id }) { return devices }
    return [placeholderDevice(id: id, name: settings.trustedDeviceName)] + devices
}

func placeholderDevice(id: String, name: String?) -> DiscoveredDevice {
    DiscoveredDevice(id: id, name: name ?? "Trusted device", rssi: nil)
}
