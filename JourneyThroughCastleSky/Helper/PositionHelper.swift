//
//  PositionHelper.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import Foundation
import SwiftUI
import SpriteKit

class PositionHelper {
    static let singleton = PositionHelper()
    
    var larguraTela : CGFloat = 0.0
    var alturaTela : CGFloat = 0.0
    
    func config(_ scene : SKScene) {
        larguraTela = scene.size.width
        alturaTela = scene.size.height
    }
    
    func centralize (_ node : SKNode) -> CGPoint {
        let x = (larguraTela / 2) - (node.frame.size.width / 2)
        let y = (alturaTela / 2) - (node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    
    func centralizeQuarterRight (_ node : SKNode) -> CGPoint {
        let x = (larguraTela / 1.5) - (node.frame.size.width / 2)
        let y = (alturaTela / 1.5) - (node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    func centralizeQuarterLeft (_ node : SKNode) -> CGPoint {
        let x = (larguraTela / 4) - (node.frame.size.width / 2)
        let y = (alturaTela / 4) - (node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    func centralizeQuarterUp (_ node : SKNode) -> CGPoint {
        let x = (larguraTela / 2) - (node.frame.size.width / 2)
        let y = (alturaTela / 1.5) - (node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    func centralizeQuarterDown (_ node : SKNode) -> CGPoint {
        let x = (larguraTela / 2) - (node.frame.size.width / 2)
        let y = (alturaTela / 4) - (node.frame.size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    func rightUpCorner (_ node : SKNode) -> CGPoint {
        let x = larguraTela - 100
        let y = alturaTela - 100
        return CGPoint(x: x, y: y)
    }
}
