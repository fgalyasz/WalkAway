import Foundation

func appVersionString() -> String {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
       version.isEmpty == false {
        return version
    }
    return versionFromResourceFile()
}

func versionFromResourceFile() -> String {
    guard let url = Bundle.main.url(forResource: "VERSION", withExtension: nil) else { return "0.1.0" }
    guard let contents = try? String(contentsOf: url, encoding: .utf8) else { return "0.1.0" }
    let trimmed = contents.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? "0.1.0" : trimmed
}
