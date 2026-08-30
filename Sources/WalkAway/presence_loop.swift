import Foundation
import WalkAwayCore

final class PresenceLoop {
    private var tracker = PresenceTracker()
    private var timer: Timer?

    func reset() {
        tracker = PresenceTracker()
    }

    func start(onTick: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in onTick() }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func evaluate(settings: WalkAwaySettings, rssi: Int?, now: Date) -> LockAction {
        tracker.evaluate(settings: settings, rssi: rssi, now: now)
    }
}
