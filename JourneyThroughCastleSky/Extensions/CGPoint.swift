import Foundation
import CoreGraphics
import simd

extension CGPoint {
    init(simd: simd_float2) {
        let x = CGFloat(simd.x)
        let y = CGFloat(simd.y)
        self.init(x: x, y: y)
    }
}
