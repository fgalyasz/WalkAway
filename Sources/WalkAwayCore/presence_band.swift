import Foundation

public enum PresenceBand: Equatable {
    case near
    case away
    case unknown
}

public enum LockAction: Equatable {
    case none
    case lock
}

public func presenceBand(
    rssi: Int?,
    lockRssi: Int,
    hasTrustedDevice: Bool,
    hasReceivedSample: Bool
) -> PresenceBand {
    if !hasTrustedDevice || !hasReceivedSample { return .unknown }
    guard let rssi else { return .away }
    if rssi >= lockRssi { return .near }
    return .away
}
