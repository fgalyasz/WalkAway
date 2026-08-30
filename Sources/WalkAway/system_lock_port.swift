import Foundation
import WalkAwayCore

struct SystemLockPort: LockPort {
    func lockScreen() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", "tell application \"System Events\" to lock screen"]
        try? process.run()
    }
}
