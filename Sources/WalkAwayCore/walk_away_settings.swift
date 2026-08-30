import Foundation

public struct WalkAwaySettings: Equatable, Codable {
    public var armed: Bool
    public var lockRssi: Int
    public var awayDelaySeconds: Int
    public var launchAtLogin: Bool
    public var trustedDeviceId: String?

    public init(
        armed: Bool,
        lockRssi: Int,
        awayDelaySeconds: Int,
        launchAtLogin: Bool,
        trustedDeviceId: String?
    ) {
        self.armed = armed
        self.lockRssi = lockRssi
        self.awayDelaySeconds = clampDelay(awayDelaySeconds)
        self.launchAtLogin = launchAtLogin
        self.trustedDeviceId = trustedDeviceId
    }

    public static let `default` = WalkAwaySettings(
        armed: false,
        lockRssi: -80,
        awayDelaySeconds: 8,
        launchAtLogin: false,
        trustedDeviceId: nil
    )
}

public func clampDelay(_ seconds: Int) -> Int {
    min(60, max(3, seconds))
}

public func settingsWithDevice(_ settings: WalkAwaySettings, deviceId: String) -> WalkAwaySettings {
    var next = settings
    next.trustedDeviceId = deviceId
    next.armed = true
    return next
}
