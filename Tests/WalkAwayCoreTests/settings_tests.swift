import XCTest
@testable import WalkAwayCore

final class SettingsTests: XCTestCase {
    func testClampDelayBounds() {
        XCTAssertEqual(clampDelay(1), 3)
        XCTAssertEqual(clampDelay(8), 8)
        XCTAssertEqual(clampDelay(99), 60)
    }

    func testClampRssiBounds() {
        XCTAssertEqual(clampRssi(-20), -40)
        XCTAssertEqual(clampRssi(-80), -80)
        XCTAssertEqual(clampRssi(-120), -100)
    }

    func testPickingDeviceArms() {
        let next = settingsWithDevice(.default, deviceId: "iphone", deviceName: "iPhone")
        XCTAssertEqual(next.trustedDeviceId, "iphone")
        XCTAssertEqual(next.trustedDeviceName, "iPhone")
        XCTAssertTrue(next.armed)
    }

    func testRoundTripFile() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-settings-test.json")
        let settings = settingsWithDevice(.default, deviceId: "watch", deviceName: "Watch")
        try saveSettings(settings, to: url)
        XCTAssertEqual(loadSettings(from: url), settings)
        try FileManager.default.removeItem(at: url)
    }

    func testMissingFileReturnsDefault() {
        let url = URL(fileURLWithPath: "/tmp/walkaway-missing-\(UUID().uuidString).json")
        XCTAssertEqual(loadSettings(from: url), .default)
    }

    func testLegacyJsonWithoutNameLoads() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-legacy.json")
        let json = """
        {"armed":true,"lockRssi":-75,"awayDelaySeconds":12,"launchAtLogin":false,"trustedDeviceId":"watch"}
        """
        try json.data(using: .utf8)?.write(to: url)
        let loaded = loadSettings(from: url)
        XCTAssertEqual(loaded.trustedDeviceId, "watch")
        XCTAssertNil(loaded.trustedDeviceName)
        XCTAssertEqual(loaded.lockRssi, -75)
        try FileManager.default.removeItem(at: url)
    }

    func testCorruptFileReturnsDefault() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-bad.json")
        try Data("not-json".utf8).write(to: url)
        XCTAssertEqual(loadSettings(from: url), .default)
        try FileManager.default.removeItem(at: url)
    }

    func testEmptyObjectUsesDefaults() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-empty.json")
        try Data("{}".utf8).write(to: url)
        XCTAssertEqual(loadSettings(from: url), .default)
        try FileManager.default.removeItem(at: url)
    }

    func testRoundTripDefaultEncodesNilDevice() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("walkaway-default.json")
        try saveSettings(.default, to: url)
        XCTAssertEqual(loadSettings(from: url), .default)
        try FileManager.default.removeItem(at: url)
    }

    func testDefaultSettingsURL() {
        let url = defaultSettingsURL()
        XCTAssertTrue(url.path.contains("WalkAway/settings.json"))
    }
}
