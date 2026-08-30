import XCTest
@testable import WalkAwayCore

final class AppcastFeedBuilderTests: XCTestCase {
    func testEnclosureFilenameUsesVersion() {
        XCTAssertEqual(AppcastFeedBuilder.enclosureFilename(version: "0.1.1"), "WalkAway-0.1.1.zip")
    }

    func testEnclosureURLUsesSiteDownloads() {
        let url = AppcastFeedBuilder.enclosureURL(version: "0.1.1")
        XCTAssertEqual(url, "https://tenprintsoftware.com/downloads/walkaway/WalkAway-0.1.1.zip")
    }

    func testFeedURLIsTenPrintDownloads() {
        XCTAssertEqual(
            AppcastFeedBuilder.feedURL,
            "https://tenprintsoftware.com/downloads/walkaway/appcast.xml"
        )
    }

    func testXMLContainsShortVersionAndZipName() {
        let xml = AppcastFeedBuilder.xml(items: [makeSampleItem()])
        XCTAssertTrue(xml.contains("sparkle:shortVersionString=\"0.1.1\""))
        XCTAssertTrue(xml.contains("WalkAway-0.1.1.zip"))
        XCTAssertTrue(xml.contains("<title>WalkAway</title>"))
    }

    func testXMLContainsLengthAndSignature() {
        let xml = AppcastFeedBuilder.xml(items: [makeSampleItem()])
        XCTAssertTrue(xml.contains("length=\"12345\""))
        XCTAssertTrue(xml.contains("sparkle:edSignature=\"SIG\""))
        XCTAssertTrue(xml.contains("sparkle:version=\"42\""))
    }

    func testXMLEscapesEnclosureURL() {
        let item = AppcastItem(
            shortVersion: "1.0.0",
            buildVersion: "1",
            pubDate: Date(timeIntervalSince1970: 0),
            descriptionHTML: "notes",
            enclosureURL: "https://example.com/a&b.zip",
            enclosureLength: 1,
            edSignature: "x"
        )
        let xml = AppcastFeedBuilder.xml(items: [item])
        XCTAssertTrue(xml.contains("a&amp;b.zip"))
        XCTAssertFalse(xml.contains("url=\"https://example.com/a&b.zip\""))
    }

    func testMenuCopyIsCheckForUpdates() {
        XCTAssertEqual(UpdateMenuCopy.checkForUpdates, "Check for Updates…")
    }

    func testXMLEscapesQuotesInSignature() {
        let item = AppcastItem(
            shortVersion: "1.0.0",
            buildVersion: "1",
            pubDate: Date(timeIntervalSince1970: 0),
            descriptionHTML: "notes",
            enclosureURL: "https://example.com/a.zip",
            enclosureLength: 1,
            edSignature: "a\"b"
        )
        let xml = AppcastFeedBuilder.xml(items: [item])
        XCTAssertTrue(xml.contains("a&quot;b"))
        XCTAssertFalse(xml.contains("edSignature=\"a\"b\""))
    }

    func testEmptyFeedStillHasChannelTitle() {
        let xml = AppcastFeedBuilder.xml(items: [])
        XCTAssertTrue(xml.contains("<title>WalkAway</title>"))
        XCTAssertFalse(xml.contains("<item>"))
    }
}

private func makeSampleItem() -> AppcastItem {
    AppcastItem(
        shortVersion: "0.1.1",
        buildVersion: "42",
        pubDate: Date(timeIntervalSince1970: 1_777_248_000),
        descriptionHTML: "WalkAway 0.1.1",
        enclosureURL: AppcastFeedBuilder.enclosureURL(version: "0.1.1"),
        enclosureLength: 12345,
        edSignature: "SIG"
    )
}
