import XCTest
@testable import WalkAwayCore

final class LaunchAtLoginSyncTests: XCTestCase {
    func testMatchingDoesNotUpdate() {
        let result = LaunchAtLoginSyncHelper.computeSync(storedValue: true, systemValue: true)
        XCTAssertFalse(result.shouldUpdatePreference)
        XCTAssertTrue(result.updatedValue)
    }

    func testSystemWinsOnMismatch() {
        let result = LaunchAtLoginSyncHelper.computeSync(storedValue: true, systemValue: false)
        XCTAssertTrue(result.shouldUpdatePreference)
        XCTAssertFalse(result.updatedValue)
    }

    func testSystemEnabledWins() {
        let result = LaunchAtLoginSyncHelper.computeSync(storedValue: false, systemValue: true)
        XCTAssertTrue(result.shouldUpdatePreference)
        XCTAssertTrue(result.updatedValue)
    }
}
