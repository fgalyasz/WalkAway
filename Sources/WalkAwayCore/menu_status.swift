import Foundation

public enum BleAdapterStatus: Equatable {
    case ready
    case poweredOff
    case unauthorized
    case unavailable
}

public func menuStatusTitle(settings: WalkAwaySettings, adapter: BleAdapterStatus) -> String {
    if adapter == .poweredOff { return "Bluetooth off" }
    if adapter == .unauthorized { return "Bluetooth permission needed" }
    if adapter == .unavailable { return "Bluetooth unavailable" }
    return armedStatusTitle(settings)
}

public func armedStatusTitle(_ settings: WalkAwaySettings) -> String {
    if settings.trustedDeviceId == nil { return "No trusted device" }
    return settings.armed ? "Armed" : "Disarmed"
}

public func shouldEvaluatePresence(adapter: BleAdapterStatus, settings: WalkAwaySettings) -> Bool {
    adapter == .ready && settings.armed && settings.trustedDeviceId != nil
}
