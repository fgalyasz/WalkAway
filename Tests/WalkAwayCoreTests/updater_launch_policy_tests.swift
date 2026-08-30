import XCTest
@testable import WalkAwayCore

final class UpdaterLaunchPolicyTests: XCTestCase {
    func testInstalledAppBundleStartsUpdater() {
        XCTAssertTrue(UpdaterLaunchPolicy.shouldStartUpdater(bundlePath: "/Applications/WalkAway.app"))
    }

    func testSwiftRunBinaryDoesNotStartUpdater() {
        let path = "/Users/dev/WalkAway/.build/debug/WalkAway"
        XCTAssertFalse(UpdaterLaunchPolicy.shouldStartUpdater(bundlePath: path))
    }

    func testNonAppPathDoesNotStartUpdater() {
        XCTAssertFalse(UpdaterLaunchPolicy.shouldStartUpdater(bundlePath: "/tmp/WalkAway"))
    }
}
