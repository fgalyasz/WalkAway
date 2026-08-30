import Foundation
import ServiceManagement
import WalkAwayCore

func isRunningFromAppBundle() -> Bool {
    Bundle.main.bundleURL.pathExtension.lowercased() == "app"
}

func isLaunchAtLoginEnabled() -> Bool {
    let status = SMAppService.mainApp.status
    return status == .enabled || status == .requiresApproval
}

func applyLaunchAtLogin(desired: Bool) {
    if isRunningFromAppBundle() == false { return }
    if desired { tryEnableLaunchAtLogin(); return }
    tryDisableLaunchAtLogin()
}

func tryEnableLaunchAtLogin() {
    if isLaunchAtLoginEnabled() { return }
    do { try SMAppService.mainApp.register() } catch { }
}

func tryDisableLaunchAtLogin() {
    if !isLaunchAtLoginEnabled() { return }
    do { try SMAppService.mainApp.unregister() } catch { }
}

func syncedLaunchAtLogin(stored: Bool) -> Bool {
    if isRunningFromAppBundle() == false { return stored }
    let result = LaunchAtLoginSyncHelper.computeSync(
        storedValue: stored,
        systemValue: isLaunchAtLoginEnabled()
    )
    return result.updatedValue
}
