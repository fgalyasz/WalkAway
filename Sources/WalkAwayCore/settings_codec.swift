import Foundation

enum SettingsKey: String, CodingKey {
    case armed
    case lockRssi
    case awayDelaySeconds
    case launchAtLogin
    case trustedDeviceId
    case trustedDeviceName
}

func decodeWalkAwaySettings(_ decoder: Decoder) throws -> WalkAwaySettings {
    let container = try decoder.container(keyedBy: SettingsKey.self)
    return WalkAwaySettings(
        armed: try container.decodeIfPresent(Bool.self, forKey: .armed) ?? false,
        lockRssi: try container.decodeIfPresent(Int.self, forKey: .lockRssi) ?? -80,
        awayDelaySeconds: try container.decodeIfPresent(Int.self, forKey: .awayDelaySeconds) ?? 8,
        launchAtLogin: try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false,
        trustedDeviceId: try container.decodeIfPresent(String.self, forKey: .trustedDeviceId),
        trustedDeviceName: try container.decodeIfPresent(String.self, forKey: .trustedDeviceName)
    )
}

func encodeWalkAwaySettings(_ settings: WalkAwaySettings, _ encoder: Encoder) throws {
    var container = encoder.container(keyedBy: SettingsKey.self)
    try container.encode(settings.armed, forKey: .armed)
    try container.encode(settings.lockRssi, forKey: .lockRssi)
    try container.encode(settings.awayDelaySeconds, forKey: .awayDelaySeconds)
    try encodeOptionalFields(&container, settings)
}

func encodeOptionalFields(
    _ container: inout KeyedEncodingContainer<SettingsKey>,
    _ settings: WalkAwaySettings
) throws {
    try container.encode(settings.launchAtLogin, forKey: .launchAtLogin)
    try container.encodeIfPresent(settings.trustedDeviceId, forKey: .trustedDeviceId)
    try container.encodeIfPresent(settings.trustedDeviceName, forKey: .trustedDeviceName)
}
