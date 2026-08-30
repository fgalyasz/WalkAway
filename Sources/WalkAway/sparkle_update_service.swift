import AppKit
import Foundation
import Sparkle
import WalkAwayCore

final class SparkleUpdateService {
    private var controller: SPUStandardUpdaterController?

    func start() {
        let path = Bundle.main.bundlePath
        if UpdaterLaunchPolicy.shouldStartUpdater(bundlePath: path) == false { return }
        controller = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }

    func checkForUpdates() {
        if let controller {
            controller.checkForUpdates(nil)
            return
        }
        presentUnavailableAlert()
    }
}

func presentUnavailableAlert() {
    let alert = makeUnavailableAlert()
    alert.runModal()
}

func makeUnavailableAlert() -> NSAlert {
    let alert = NSAlert()
    alert.messageText = UpdateMenuCopy.updaterUnavailableTitle
    alert.informativeText = UpdateMenuCopy.updaterUnavailableMessage
    alert.alertStyle = .informational
    return alert
}
