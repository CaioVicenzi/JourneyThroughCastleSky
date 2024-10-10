import CoreGraphics

class Math {

    static func clamp(value: CGFloat, minV: CGFloat, maxV: CGFloat) -> CGFloat {
        return max(min(value, maxV), minV)
    }
    
}
