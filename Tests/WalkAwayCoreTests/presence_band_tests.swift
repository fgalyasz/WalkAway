import XCTest
@testable import WalkAwayCore

final class PresenceBandTests: XCTestCase {
    func testNoDeviceIsUnknown() {
        XCTAssertEqual(presenceBand(rssi: -40, lockRssi: -80, hasTrustedDevice: false, hasReceivedSample: false), .unknown)
    }

    func testNoSampleYetIsUnknown() {
        XCTAssertEqual(presenceBand(rssi: nil, lockRssi: -80, hasTrustedDevice: true, hasReceivedSample: false), .unknown)
    }

    func testLostSignalAfterSampleIsAway() {
        XCTAssertEqual(presenceBand(rssi: nil, lockRssi: -80, hasTrustedDevice: true, hasReceivedSample: true), .away)
    }

    func testThresholdIsNear() {
        XCTAssertEqual(presenceBand(rssi: -80, lockRssi: -80, hasTrustedDevice: true, hasReceivedSample: true), .near)
    }

    func testWeakerThanThresholdIsAway() {
        XCTAssertEqual(presenceBand(rssi: -81, lockRssi: -80, hasTrustedDevice: true, hasReceivedSample: true), .away)
    }

    func testStrongerThanThresholdIsNear() {
        XCTAssertEqual(presenceBand(rssi: -40, lockRssi: -80, hasTrustedDevice: true, hasReceivedSample: true), .near)
    }
}
