import XCTest
@testable import WalkAwayCore

final class PanelActivationPolicyTests: XCTestCase {
    func testOneVisibleWindowUsesRegularPolicy() {
        XCTAssertTrue(PanelActivationPolicy.shouldUseRegularPolicy(visibleKeyableWindowCount: 1))
    }

    func testZeroWindowsUsesAccessoryPolicy() {
        XCTAssertFalse(PanelActivationPolicy.shouldUseRegularPolicy(visibleKeyableWindowCount: 0))
    }

    func testNegativeCountUsesAccessoryPolicy() {
        XCTAssertFalse(PanelActivationPolicy.shouldUseRegularPolicy(visibleKeyableWindowCount: -1))
    }
}
