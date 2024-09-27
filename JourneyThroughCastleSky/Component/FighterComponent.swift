//
//  FighterComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class FighterComponent: Component {
    var damage : Int
    var dodged = false
    
    init(damage: Int) {
        self.damage = damage
    }
}
