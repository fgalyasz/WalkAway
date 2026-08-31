import CoreGraphics

public enum PanelPlacement {
    public static func centeredFrame(visibleFrame: CGRect, size: CGSize) -> CGRect {
        let fitted = fittedSize(size, in: visibleFrame)
        return CGRect(origin: centeredOrigin(visibleFrame, fitted), size: fitted)
    }
}

func fittedSize(_ size: CGSize, in visible: CGRect) -> CGSize {
    CGSize(width: min(size.width, visible.width), height: min(size.height, visible.height))
}

func centeredOrigin(_ visible: CGRect, _ size: CGSize) -> CGPoint {
    let x = clamp(visible.midX - size.width / 2, visible.minX, visible.maxX - size.width)
    let y = clamp(visible.midY - size.height / 2, visible.minY, visible.maxY - size.height)
    return CGPoint(x: x, y: y)
}

func clamp(_ value: CGFloat, _ lower: CGFloat, _ upper: CGFloat) -> CGFloat {
    max(lower, min(value, upper))
}
