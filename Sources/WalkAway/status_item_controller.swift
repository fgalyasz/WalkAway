import AppKit
import WalkAwayCore

protocol StatusItemActions: AnyObject {
    func toggleArm()
    func lockNow()
    func quitApp()
}

final class StatusItemController: NSObject {
    private let statusItem: NSStatusItem
    private let menu: NSMenu
    private let statusLine: NSMenuItem
    private let armItem: NSMenuItem
    weak var actions: StatusItemActions?

    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        menu = NSMenu()
        statusLine = NSMenuItem()
        armItem = NSMenuItem()
        super.init()
        buildMenu()
    }

    func apply(settings: WalkAwaySettings) {
        statusLine.title = statusTitle(settings)
        armItem.title = settings.armed ? "Disarm" : "Arm"
        armItem.isEnabled = settings.trustedDeviceId != nil
        statusItem.button?.image = menuImage(armed: settings.armed)
    }

    @objc func handleToggleArm() { actions?.toggleArm() }

    @objc func handleLockNow() { actions?.lockNow() }

    @objc func handleQuit() { actions?.quitApp() }
}

private func statusTitle(_ settings: WalkAwaySettings) -> String {
    if settings.trustedDeviceId == nil { return "No trusted device" }
    return settings.armed ? "Armed" : "Disarmed"
}

private func menuImage(armed: Bool) -> NSImage? {
    let name = armed ? "lock.fill" : "lock.open"
    return NSImage(systemSymbolName: name, accessibilityDescription: "WalkAway")
}

private extension StatusItemController {
    func buildMenu() {
        statusLine.isEnabled = false
        armItem.action = #selector(handleToggleArm)
        armItem.target = self
        let lockItem = NSMenuItem(title: "Lock Now", action: #selector(handleLockNow), keyEquivalent: "")
        lockItem.target = self
        finishMenu(lockItem: lockItem)
    }

    func finishMenu(lockItem: NSMenuItem) {
        let quitItem = NSMenuItem(title: "Quit WalkAway", action: #selector(handleQuit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(statusLine)
        menu.addItem(armItem)
        menu.addItem(lockItem)
        menu.addItem(.separator())
        menu.addItem(quitItem)
        statusItem.menu = menu
        statusItem.button?.toolTip = "WalkAway"
    }
}
