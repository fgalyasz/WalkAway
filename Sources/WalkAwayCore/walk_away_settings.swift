import Foundation

public struct WalkAwaySettings: Equatable, Codable {
    public var armed: Bool
    public var lockRssi: Int
    public var awayDelaySeconds: Int
    public var launchAtLogin: Bool
    public var trustedDeviceId: String?
    public var trustedDeviceName: String?

    public init(
        armed: Bool,
        lockRssi: Int,
        awayDelaySeconds: Int,
        launchAtLogin: Bool,
        trustedDeviceId: String?,
        trustedDeviceName: String? = nil
    ) {
        self.armed = armed
        self.lockRssi = clampRssi(lockRssi)
        self.awayDelaySeconds = clampDelay(awayDelaySeconds)
        self.launchAtLogin = launchAtLogin
        self.trustedDeviceId = trustedDeviceId
        self.trustedDeviceName = trustedDeviceName
    }

    public static let `default` = WalkAwaySettings(
        armed: false,
        lockRssi: -80,
        awayDelaySeconds: 8,
        launchAtLogin: false,
        trustedDeviceId: nil,
        trustedDeviceName: nil
    )

    public init(from decoder: Decoder) throws {
        self = try decodeWalkAwaySettings(decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try encodeWalkAwaySettings(self, encoder)
    }
}

public func clampDelay(_ seconds: Int) -> Int {
    min(60, max(3, seconds))
}

public func clampRssi(_ rssi: Int) -> Int {
    min(-40, max(-100, rssi))
}

public func settingsWithDevice(
    _ settings: WalkAwaySettings,
    deviceId: String,
    deviceName: String = "Device"
) -> WalkAwaySettings {
    var next = settings
    next.trustedDeviceId = deviceId
    next.trustedDeviceName = deviceName
    next.armed = true
    return next
}
