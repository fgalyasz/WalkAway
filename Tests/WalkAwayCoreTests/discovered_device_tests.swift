import XCTest
@testable import WalkAwayCore

final class DiscoveredDeviceTests: XCTestCase {
    func testTitleWithRssi() {
        let device = DiscoveredDevice(id: "a", name: "Watch", rssi: -62)
        XCTAssertEqual(deviceMenuTitle(device), "Watch (-62 dBm)")
    }

    func testTitleWithoutRssi() {
        let device = DiscoveredDevice(id: "a", name: "Watch", rssi: nil)
        XCTAssertEqual(deviceMenuTitle(device), "Watch (not in range)")
    }

    func testIncludesTrustedWhenMissing() {
        let settings = settingsWithDevice(.default, deviceId: "watch", deviceName: "Anna Watch")
        let listed = devicesIncludingTrusted([], settings: settings)
        XCTAssertEqual(listed.count, 1)
        XCTAssertEqual(listed[0].id, "watch")
        XCTAssertNil(listed[0].rssi)
    }

    func testPlaceholderWithoutName() {
        var settings = WalkAwaySettings.default
        settings.trustedDeviceId = "watch"
        settings.trustedDeviceName = nil
        let listed = devicesIncludingTrusted([], settings: settings)
        XCTAssertEqual(listed[0].name, "Trusted device")
    }

    func testDoesNotDuplicateTrusted() {
        let settings = settingsWithDevice(.default, deviceId: "watch", deviceName: "Anna Watch")
        let current = DiscoveredDevice(id: "watch", name: "Anna Watch", rssi: -50)
        let listed = devicesIncludingTrusted([current], settings: settings)
        XCTAssertEqual(listed.count, 1)
        XCTAssertEqual(listed[0].rssi, -50)
    }

    func testNoDeviceLeavesListUnchanged() {
        let current = DiscoveredDevice(id: "x", name: "Phone", rssi: -40)
        XCTAssertEqual(devicesIncludingTrusted([current], settings: .default), [current])
    }

    func testMenuRowsEmptyWithoutDevices() {
        XCTAssertEqual(deviceMenuRows([], settings: .default), [])
    }

    func testMenuRowsMapsTitleAndId() {
        let device = DiscoveredDevice(id: "watch", name: "Anna Watch", rssi: -62)
        let rows = deviceMenuRows([device], settings: .default)
        XCTAssertEqual(rows, [DeviceMenuRow(id: "watch", title: "Anna Watch (-62 dBm)")])
    }

    func testMenuRowsIncludesTrustedPlaceholder() {
        let settings = settingsWithDevice(.default, deviceId: "watch", deviceName: "Anna Watch")
        let rows = deviceMenuRows([], settings: settings)
        XCTAssertEqual(rows, [DeviceMenuRow(id: "watch", title: "Anna Watch (not in range)")])
    }

    func testMenuRowsKeepsDuplicateTitles() {
        let a = DiscoveredDevice(id: "a", name: "Watch", rssi: -50)
        let b = DiscoveredDevice(id: "b", name: "Watch", rssi: -50)
        let rows = deviceMenuRows([a, b], settings: .default)
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0].id, "a")
        XCTAssertEqual(rows[1].id, "b")
    }

    func testSortsByNameNotRssi() {
        let weak = DiscoveredDevice(id: "a", name: "Alpha", rssi: -90)
        let strong = DiscoveredDevice(id: "b", name: "Beta", rssi: -40)
        XCTAssertEqual(sortedDevicesForMenu([strong, weak]).map(\.id), ["a", "b"])
    }

    func testRssiChangeDoesNotReorder() {
        let first = sortedDevicesForMenu([
            DiscoveredDevice(id: "a", name: "Watch", rssi: -40),
            DiscoveredDevice(id: "b", name: "Phone", rssi: -90)
        ]).map(\.id)
        let second = sortedDevicesForMenu([
            DiscoveredDevice(id: "a", name: "Watch", rssi: -90),
            DiscoveredDevice(id: "b", name: "Phone", rssi: -40)
        ]).map(\.id)
        XCTAssertEqual(first, second)
    }

    func testSortsByIdWhenNamesMatch() {
        let late = DiscoveredDevice(id: "z", name: "Watch", rssi: -40)
        let early = DiscoveredDevice(id: "a", name: "Watch", rssi: -90)
        XCTAssertEqual(sortedDevicesForMenu([late, early]).map(\.id), ["a", "z"])
    }

    func testDoesNotReloadWhileMenuOpen() {
        XCTAssertFalse(shouldReloadDeviceMenu(isOpen: true))
    }

    func testReloadsWhenMenuClosed() {
        XCTAssertTrue(shouldReloadDeviceMenu(isOpen: false))
    }
}
