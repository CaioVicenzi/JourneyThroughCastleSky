//
//  FighterComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

protocol IsFighter: HasHealth {
    var fighterComponent: FighterComponent {get}
}

class FighterComponent: Component {
    
    var hasActionInQueue: Bool {
        return actionInQueue != nil
    }
    
    var attacks: [Attack] = []
    var actionInQueue: HasExecutionTime?
    
    
    
    var damage : Int
    var dodged = false
    
    init(damage: Int) {
        self.damage = damage
    }
}
