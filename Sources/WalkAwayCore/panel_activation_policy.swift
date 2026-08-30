import Foundation

public enum PanelActivationPolicy {
    public static func shouldUseRegularPolicy(visibleKeyableWindowCount: Int) -> Bool {
        visibleKeyableWindowCount > 0
    }
}
