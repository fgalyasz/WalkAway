import XCTest
@testable import WalkAwayCore

final class SettingsTests: XCTestCase {
    func testClampDelayBounds() {
        XCTAssertEqual(clampDelay(1), 3)
        XCTAssertEqual(clampDelay(8), 8)
        XCTAssertEqual(clampDelay(99), 60)
    }

    func testPickingDeviceArms() {
        let next = settingsWithDevice(.default, deviceId: "iphone")
        XCTAssertEqual(next.trustedDeviceId, "iphone")
        XCTAssertTrue(next.armed)
    }

    func testRoundTripFile() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-settings-test.json")
        let settings = settingsWithDevice(.default, deviceId: "watch")
        try saveSettings(settings, to: url)
        XCTAssertEqual(loadSettings(from: url), settings)
        try FileManager.default.removeItem(at: url)
    }

    func testMissingFileReturnsDefault() {
        let url = URL(fileURLWithPath: "/tmp/walkaway-missing-\(UUID().uuidString).json")
        XCTAssertEqual(loadSettings(from: url), .default)
    }
}
