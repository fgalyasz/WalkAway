import Foundation

public struct PresenceTracker: Equatable {
    public var awaySince: Date?
    public var lockedThisAbsence: Bool
    public var hasReceivedSample: Bool

    public init() {
        awaySince = nil
        lockedThisAbsence = false
        hasReceivedSample = false
    }

    public mutating func evaluate(
        settings: WalkAwaySettings,
        rssi: Int?,
        now: Date
    ) -> LockAction {
        if rssi != nil { hasReceivedSample = true }
        if !settings.armed { return resetForDisarm() }
        return action(for: band(settings, rssi), delay: settings.awayDelaySeconds, now: now)
    }

    private func band(_ settings: WalkAwaySettings, _ rssi: Int?) -> PresenceBand {
        presenceBand(
            rssi: rssi,
            lockRssi: settings.lockRssi,
            hasTrustedDevice: settings.trustedDeviceId != nil,
            hasReceivedSample: hasReceivedSample
        )
    }

    private mutating func resetForDisarm() -> LockAction {
        awaySince = nil
        lockedThisAbsence = false
        return .none
    }

    private mutating func action(for band: PresenceBand, delay: Int, now: Date) -> LockAction {
        if band == .near { return resetForNear() }
        if band == .unknown { return resetAwayClock() }
        return handleAway(delay: delay, now: now)
    }

    private mutating func resetForNear() -> LockAction {
        awaySince = nil
        lockedThisAbsence = false
        return .none
    }

    private mutating func resetAwayClock() -> LockAction {
        awaySince = nil
        return .none
    }

    private mutating func handleAway(delay: Int, now: Date) -> LockAction {
        if awaySince == nil { awaySince = now }
        if lockedThisAbsence { return .none }
        if secondsAway(now: now) < delay { return .none }
        lockedThisAbsence = true
        return .lock
    }

    private func secondsAway(now: Date) -> Int {
        guard let awaySince else { return 0 }
        return Int(now.timeIntervalSince(awaySince))
    }
}
