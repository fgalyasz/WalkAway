import Foundation

public struct AppcastItem {
    public let shortVersion: String
    public let buildVersion: String
    public let pubDate: Date
    public let descriptionHTML: String
    public let enclosureURL: String
    public let enclosureLength: Int
    public let edSignature: String

    public init(
        shortVersion: String,
        buildVersion: String,
        pubDate: Date,
        descriptionHTML: String,
        enclosureURL: String,
        enclosureLength: Int,
        edSignature: String
    ) {
        self.shortVersion = shortVersion
        self.buildVersion = buildVersion
        self.pubDate = pubDate
        self.descriptionHTML = descriptionHTML
        self.enclosureURL = enclosureURL
        self.enclosureLength = enclosureLength
        self.edSignature = edSignature
    }
}

public enum AppcastFeedBuilder {
    public static let feedURL = "https://tenprintsoftware.com/downloads/walkaway/appcast.xml"

    public static func xml(items: [AppcastItem]) -> String {
        wrapChannel(body: items.map(itemXML).joined(separator: "\n"))
    }

    public static func enclosureFilename(version: String) -> String {
        "WalkAway-\(version).zip"
    }

    public static func enclosureURL(version: String) -> String {
        "https://tenprintsoftware.com/downloads/walkaway/\(enclosureFilename(version: version))"
    }
}

func wrapChannel(body: String) -> String {
    let header = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    let rss = "<rss version=\"2.0\" xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\">\n"
    return header + rss + "  <channel>\n    <title>WalkAway</title>\n" + body + "\n  </channel>\n</rss>\n"
}

func itemXML(_ item: AppcastItem) -> String {
    itemLines(item).joined(separator: "\n")
}

func itemLines(_ item: AppcastItem) -> [String] {
    itemMarkup(
        title: escapeXML("Version \(item.shortVersion)"),
        date: rfc822(item.pubDate),
        description: item.descriptionHTML,
        enclosure: enclosureAttributes(item)
    )
}

func itemMarkup(title: String, date: String, description: String, enclosure: String) -> [String] {
    [
        "    <item>",
        "      <title>\(title)</title>",
        "      <pubDate>\(date)</pubDate>",
        "      <description><![CDATA[\(description)]]></description>",
        "      <enclosure \(enclosure) />",
        "    </item>"
    ]
}

func enclosureAttributes(_ item: AppcastItem) -> String {
    let url = escapeXML(item.enclosureURL)
    let version = escapeXML(item.buildVersion)
    let shortVersion = escapeXML(item.shortVersion)
    let signature = escapeXML(item.edSignature)
    return enclosureAttributeString(url, version, shortVersion, item.enclosureLength, signature)
}

func enclosureAttributeString(
    _ url: String,
    _ version: String,
    _ shortVersion: String,
    _ length: Int,
    _ signature: String
) -> String {
    "url=\"\(url)\" sparkle:version=\"\(version)\" sparkle:shortVersionString=\"\(shortVersion)\" length=\"\(length)\" type=\"application/octet-stream\" sparkle:edSignature=\"\(signature)\""
}

func rfc822(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +0000"
    return formatter.string(from: date)
}

func escapeXML(_ raw: String) -> String {
    raw.replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
        .replacingOccurrences(of: "\"", with: "&quot;")
}
