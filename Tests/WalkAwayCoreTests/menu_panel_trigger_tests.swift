import XCTest
@testable import WalkAwayCore

final class MenuPanelTriggerTests: XCTestCase {
    func testItemActionPresents() {
        XCTAssertTrue(shouldPresentStatusPanel(trigger: .itemAction))
    }

    func testMenuDidCloseDoesNotPresent() {
        XCTAssertFalse(shouldPresentStatusPanel(trigger: .menuDidClose))
    }
}
