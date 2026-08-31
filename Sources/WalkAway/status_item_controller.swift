import AppKit
import WalkAwayCore

protocol StatusItemActions: AnyObject {
    func toggleArm()
    func lockNow()
    func openPreferences()
    func openAbout()
    func checkForUpdates()
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

    func apply(settings: WalkAwaySettings, adapter: BleAdapterStatus) {
        statusLine.title = menuStatusTitle(settings: settings, adapter: adapter)
        armItem.title = settings.armed ? "Disarm" : "Arm"
        armItem.isEnabled = settings.trustedDeviceId != nil
        statusItem.button?.image = menuImage(armed: settings.armed)
    }

    @objc func handleToggleArm() { actions?.toggleArm() }
    @objc func handleLockNow() { actions?.lockNow() }
    @objc func handleQuit() { actions?.quitApp() }

    @objc func handlePreferences() {
        presentPanel(.itemAction, #selector(openPreferencesNow))
    }

    @objc func handleAbout() {
        presentPanel(.itemAction, #selector(openAboutNow))
    }

    @objc func handleCheckForUpdates() {
        presentPanel(.itemAction, #selector(openUpdatesNow))
    }

    func presentPanel(_ trigger: MenuPanelTrigger, _ selector: Selector) {
        if shouldPresentStatusPanel(trigger: trigger) == false { return }
        perform(selector, with: nil, afterDelay: 0)
    }

    @objc func openPreferencesNow() { actions?.openPreferences() }
    @objc func openAboutNow() { actions?.openAbout() }
    @objc func openUpdatesNow() { actions?.checkForUpdates() }
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
        finishMenu()
    }

    func finishMenu() {
        addStatusItems()
        addActionItems()
        addQuitItem()
        statusItem.menu = menu
        statusItem.button?.toolTip = "WalkAway"
    }

    func addStatusItems() {
        menu.addItem(statusLine)
        menu.addItem(armItem)
        menu.addItem(actionItem("Lock Now", #selector(handleLockNow)))
        menu.addItem(.separator())
    }

    func addActionItems() {
        menu.addItem(actionItem("Preferences…", #selector(handlePreferences)))
        menu.addItem(actionItem(UpdateMenuCopy.checkForUpdates, #selector(handleCheckForUpdates)))
        menu.addItem(actionItem("About WalkAway", #selector(handleAbout)))
        menu.addItem(.separator())
    }

    func addQuitItem() {
        let quitItem = actionItem("Quit WalkAway", #selector(handleQuit))
        quitItem.keyEquivalent = "q"
        menu.addItem(quitItem)
    }

    func actionItem(_ title: String, _ selector: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: selector, keyEquivalent: "")
        item.target = self
        return item
    }
}
