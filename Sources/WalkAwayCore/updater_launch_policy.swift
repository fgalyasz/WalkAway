import Foundation

public enum UpdaterLaunchPolicy {
    public static func shouldStartUpdater(bundlePath: String) -> Bool {
        URL(fileURLWithPath: bundlePath).pathExtension.lowercased() == "app"
    }
}
