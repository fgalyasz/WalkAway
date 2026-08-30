import XCTest
@testable import WalkAwayCore

final class MenuStatusTests: XCTestCase {
    func testNoDeviceWhenReady() {
        XCTAssertEqual(menuStatusTitle(settings: .default, adapter: .ready), "No trusted device")
    }

    func testArmedWhenDevicePicked() {
        let settings = settingsWithDevice(.default, deviceId: "watch", deviceName: "Watch")
        XCTAssertEqual(menuStatusTitle(settings: settings, adapter: .ready), "Armed")
    }

    func testDisarmedTitle() {
        var settings = settingsWithDevice(.default, deviceId: "watch")
        settings.armed = false
        XCTAssertEqual(menuStatusTitle(settings: settings, adapter: .ready), "Disarmed")
    }

    func testBluetoothOffWins() {
        let settings = settingsWithDevice(.default, deviceId: "watch")
        XCTAssertEqual(menuStatusTitle(settings: settings, adapter: .poweredOff), "Bluetooth off")
    }

    func testUnauthorizedWins() {
        XCTAssertEqual(
            menuStatusTitle(settings: .default, adapter: .unauthorized),
            "Bluetooth permission needed"
        )
    }

    func testUnavailableWins() {
        XCTAssertEqual(menuStatusTitle(settings: .default, adapter: .unavailable), "Bluetooth unavailable")
    }

    func testEvaluateRequiresReadyArmedDevice() {
        XCTAssertFalse(shouldEvaluatePresence(adapter: .poweredOff, settings: .default))
        XCTAssertFalse(shouldEvaluatePresence(adapter: .ready, settings: .default))
        var settings = settingsWithDevice(.default, deviceId: "watch")
        XCTAssertTrue(shouldEvaluatePresence(adapter: .ready, settings: settings))
        settings.armed = false
        XCTAssertFalse(shouldEvaluatePresence(adapter: .ready, settings: settings))
    }
}
