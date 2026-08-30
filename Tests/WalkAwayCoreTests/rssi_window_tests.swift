import XCTest
@testable import WalkAwayCore

final class RssiWindowTests: XCTestCase {
    func testEmptyAverageIsNil() {
        XCTAssertNil(RssiWindow().average)
    }

    func testSingleSampleIsItself() {
        var window = RssiWindow()
        window.push(-70)
        XCTAssertEqual(window.average, -70)
    }

    func testAverageOfFive() {
        var window = RssiWindow()
        [-60, -70, -80, -90, -100].forEach { window.push($0) }
        XCTAssertEqual(window.average, -80)
    }

    func testDropsOldestPastLimit() {
        var window = RssiWindow(limit: 3)
        [-10, -20, -30, -40].forEach { window.push($0) }
        XCTAssertEqual(window.average, -30)
    }

    func testResetClearsSamples() {
        var window = RssiWindow()
        window.push(-50)
        window.reset()
        XCTAssertNil(window.average)
        XCTAssertEqual(window.samples, [])
    }
}
