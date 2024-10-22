//
//  StaminaComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class StaminaComponent: Component {
    var stamina : Int
    var maxStamina : Int
    
    init(stamina: Int, maxStamina : Int) {
        self.stamina = stamina
        self.maxStamina = maxStamina
    }
}
