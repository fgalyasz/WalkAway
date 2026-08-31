import XCTest
@testable import WalkAwayCore

final class PanelPlacementTests: XCTestCase {
    func testCentersOnPrimaryFrame() {
        let visible = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        let frame = PanelPlacement.centeredFrame(visibleFrame: visible, size: CGSize(width: 480, height: 430))
        XCTAssertEqual(frame.origin.x, 720)
        XCTAssertEqual(frame.origin.y, 325)
        XCTAssertEqual(frame.size, CGSize(width: 480, height: 430))
    }

    func testCentersOnSecondDisplay() {
        let visible = CGRect(x: 1920, y: 0, width: 1920, height: 1080)
        let frame = PanelPlacement.centeredFrame(visibleFrame: visible, size: CGSize(width: 420, height: 252))
        XCTAssertEqual(frame.origin.x, 1920 + (1920 - 420) / 2)
        XCTAssertTrue(visible.contains(frame))
    }

    func testClampsWhenLargerThanScreen() {
        let visible = CGRect(x: 0, y: 0, width: 800, height: 600)
        let frame = PanelPlacement.centeredFrame(visibleFrame: visible, size: CGSize(width: 1200, height: 900))
        XCTAssertEqual(frame, visible)
    }

    func testDoesNotPlaceOffscreenOnTheRight() {
        let visible = CGRect(x: 0, y: 0, width: 1512, height: 982)
        let frame = PanelPlacement.centeredFrame(visibleFrame: visible, size: CGSize(width: 420, height: 252))
        XCTAssertLessThanOrEqual(frame.maxX, visible.maxX)
        XCTAssertGreaterThanOrEqual(frame.minX, visible.minX)
    }
}
