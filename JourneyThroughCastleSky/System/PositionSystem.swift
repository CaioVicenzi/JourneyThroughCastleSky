//
//  PositionSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/10/24.
//

import Foundation

/// Toda a lógica das telas de TopDown que tem relação ao posicionamento dos elementos
class PositionSystem: System {
    static func calcDistanceFromUser (_ positionComponent : PositionComponent) -> CGFloat {
        let xPlayer = User.singleton.positionComponent.xPosition
        let yPlayer = User.singleton.positionComponent.yPosition
        
        let xItem = positionComponent.xPosition
        let yItem = positionComponent.yPosition
        
        let x = pow(CGFloat(xPlayer) - CGFloat(xItem), 2)
        let y = pow(CGFloat(yPlayer) - CGFloat(yItem), 2)
        
        return sqrt(CGFloat(x) + CGFloat(y))
    }
    
    static func isOtherNearPlayer(_ positionOther : PositionComponent, range : CGFloat) -> Bool {
        let distance = calcDistanceFromUser(positionOther)
        return distance < range
    }
    
    static func isAnyNearPlayer (_ elements : [PositionComponent] ) -> Bool {
        var anyNear = false

        elements.forEach { pc in
            if isOtherNearPlayer(pc, range: 50) {
                anyNear = true
            }
        }
        
        return anyNear
    }
}
