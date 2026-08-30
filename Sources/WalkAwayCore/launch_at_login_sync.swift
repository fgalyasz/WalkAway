import Foundation

public struct LaunchAtLoginSyncResult: Equatable {
    public let shouldUpdatePreference: Bool
    public let updatedValue: Bool

    public init(shouldUpdatePreference: Bool, updatedValue: Bool) {
        self.shouldUpdatePreference = shouldUpdatePreference
        self.updatedValue = updatedValue
    }
}

public enum LaunchAtLoginSyncHelper {
    public static func computeSync(storedValue: Bool, systemValue: Bool) -> LaunchAtLoginSyncResult {
        if storedValue == systemValue {
            return LaunchAtLoginSyncResult(shouldUpdatePreference: false, updatedValue: storedValue)
        }
        return LaunchAtLoginSyncResult(shouldUpdatePreference: true, updatedValue: systemValue)
    }
}
