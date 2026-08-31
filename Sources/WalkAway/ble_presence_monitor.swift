import CoreBluetooth
import Foundation
import WalkAwayCore

protocol BlePresenceMonitorDelegate: AnyObject {
    func bleMonitorDidUpdate(_ monitor: BlePresenceMonitor)
}

struct SeenAdvertisement {
    var name: String
    var window: RssiWindow
    var lastSeen: Date
}

final class BlePresenceMonitor: NSObject, CBCentralManagerDelegate {
    weak var delegate: BlePresenceMonitorDelegate?
    private var manager: CBCentralManager?
    private var seen: [UUID: SeenAdvertisement] = [:]
    var trustedDeviceId: String?
    private(set) var adapterState: CBManagerState = .unknown

    func start() {
        if manager != nil { return }
        manager = CBCentralManager(delegate: self, queue: .main)
    }

    var status: BleAdapterStatus {
        adapterStatus(from: adapterState)
    }

    func trustedRssi(now: Date) -> Int? {
        guard let advertisement = trustedAdvertisement() else { return nil }
        if now.timeIntervalSince(advertisement.lastSeen) > rssiStaleInterval { return nil }
        return advertisement.window.average
    }

    func devices(now: Date) -> [DiscoveredDevice] {
        seen.compactMap { pair in freshDevice(id: pair.key, advertisement: pair.value, now: now) }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        adapterState = central.state
        if central.state == .poweredOn { beginScan(central) }
        delegate?.bleMonitorDidUpdate(self)
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        recordDiscovery(peripheral, advertisementData, RSSI.intValue, Date())
        delegate?.bleMonitorDidUpdate(self)
    }
}

func adapterStatus(from state: CBManagerState) -> BleAdapterStatus {
    if state == .poweredOn { return .ready }
    if state == .poweredOff { return .poweredOff }
    if state == .unauthorized { return .unauthorized }
    return .unavailable
}

private extension BlePresenceMonitor {
    func beginScan(_ central: CBCentralManager) {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        central.scanForPeripherals(withServices: nil, options: options)
    }

    func trustedAdvertisement() -> SeenAdvertisement? {
        guard let id = trustedUUID() else { return nil }
        return seen[id]
    }

    func trustedUUID() -> UUID? {
        guard let trustedDeviceId else { return nil }
        return UUID(uuidString: trustedDeviceId)
    }

    func freshDevice(id: UUID, advertisement: SeenAdvertisement, now: Date) -> DiscoveredDevice? {
        if now.timeIntervalSince(advertisement.lastSeen) > 12 { return nil }
        let rssi = now.timeIntervalSince(advertisement.lastSeen) > rssiStaleInterval
            ? nil
            : advertisement.window.average
        return DiscoveredDevice(id: id.uuidString, name: advertisement.name, rssi: rssi)
    }

    func recordDiscovery(
        _ peripheral: CBPeripheral,
        _ data: [String: Any],
        _ rssi: Int,
        _ now: Date
    ) {
        if rssi == 127 { return }
        let name = bleDeviceName(peripheral, data)
        upsertSeen(id: peripheral.identifier, name: name, rssi: rssi, now: now)
    }

    func upsertSeen(id: UUID, name: String, rssi: Int, now: Date) {
        var advertisement = seen[id] ?? SeenAdvertisement(name: name, window: RssiWindow(), lastSeen: now)
        advertisement.name = name
        advertisement.window.push(rssi)
        advertisement.lastSeen = now
        seen[id] = advertisement
    }
}

func bleDeviceName(_ peripheral: CBPeripheral, _ data: [String: Any]) -> String {
    if let name = peripheral.name, name.isEmpty == false { return name }
    if let name = data[CBAdvertisementDataLocalNameKey] as? String, name.isEmpty == false {
        return name
    }
    return "Unnamed device"
}
