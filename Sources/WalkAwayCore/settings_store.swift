import Foundation

public func defaultSettingsURL() -> URL {
    let root = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    return root.appendingPathComponent("WalkAway/settings.json")
}

public func loadSettings(from url: URL) -> WalkAwaySettings {
    guard let data = try? Data(contentsOf: url) else { return .default }
    return (try? JSONDecoder().decode(WalkAwaySettings.self, from: data)) ?? .default
}

public func saveSettings(_ settings: WalkAwaySettings, to url: URL) throws {
    try FileManager.default.createDirectory(
        at: url.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    let data = try JSONEncoder().encode(settings)
    try data.write(to: url, options: .atomic)
}

public protocol LockPort {
    func lockScreen()
}
