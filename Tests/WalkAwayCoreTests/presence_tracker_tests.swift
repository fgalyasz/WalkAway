import XCTest
@testable import WalkAwayCore

private let start = Date(timeIntervalSince1970: 1_000_000)

private func armedSettings() -> WalkAwaySettings {
    settingsWithDevice(.default, deviceId: "watch")
}

private func tick(_ tracker: inout PresenceTracker, rssi: Int?, after seconds: Int) -> LockAction {
    tracker.evaluate(settings: armedSettings(), rssi: rssi, now: start.addingTimeInterval(TimeInterval(seconds)))
}

final class PresenceTrackerTests: XCTestCase {
    func testNearDoesNotLock() {
        var tracker = PresenceTracker()
        XCTAssertEqual(tick(&tracker, rssi: -40, after: 0), .none)
        XCTAssertEqual(tick(&tracker, rssi: -40, after: 30), .none)
    }

    func testAwayBelowDelayDoesNotLock() {
        var tracker = PresenceTracker()
        _ = tick(&tracker, rssi: -40, after: 0)
        _ = tick(&tracker, rssi: -90, after: 1)
        XCTAssertEqual(tick(&tracker, rssi: -90, after: 7), .none)
    }

    func testAwayPastDelayLocksOnce() {
        var tracker = PresenceTracker()
        _ = tick(&tracker, rssi: -40, after: 0)
        _ = tick(&tracker, rssi: -90, after: 1)
        XCTAssertEqual(tick(&tracker, rssi: -90, after: 9), .lock)
        XCTAssertEqual(tick(&tracker, rssi: -90, after: 20), .none)
    }

    func testReturnNearAllowsNextLock() {
        var tracker = PresenceTracker()
        _ = tick(&tracker, rssi: -40, after: 0)
        _ = tick(&tracker, rssi: -90, after: 1)
        _ = tick(&tracker, rssi: -90, after: 9)
        XCTAssertEqual(tick(&tracker, rssi: -40, after: 10), .none)
        _ = tick(&tracker, rssi: -90, after: 11)
        XCTAssertEqual(tick(&tracker, rssi: -90, after: 19), .lock)
    }

    func testDisarmedNeverLocks() {
        var tracker = PresenceTracker()
        var settings = armedSettings()
        settings.armed = false
        _ = tracker.evaluate(settings: settings, rssi: -40, now: start)
        let action = tracker.evaluate(settings: settings, rssi: -90, now: start.addingTimeInterval(30))
        XCTAssertEqual(action, .none)
    }

    func testNoDeviceNeverLocks() {
        var tracker = PresenceTracker()
        let action = tracker.evaluate(settings: .default, rssi: -90, now: start.addingTimeInterval(30))
        XCTAssertEqual(action, .none)
    }

    func testUnknownBeforeSampleDoesNotLock() {
        var tracker = PresenceTracker()
        let action = tracker.evaluate(settings: armedSettings(), rssi: nil, now: start.addingTimeInterval(30))
        XCTAssertEqual(action, .none)
        XCTAssertNil(tracker.awaySince)
    }

    func testEvaluateNeverUnlocks() {
        var tracker = PresenceTracker()
        _ = tick(&tracker, rssi: -40, after: 0)
        _ = tick(&tracker, rssi: -90, after: 8)
        XCTAssertEqual(tick(&tracker, rssi: -40, after: 9), .none)
    }
}
