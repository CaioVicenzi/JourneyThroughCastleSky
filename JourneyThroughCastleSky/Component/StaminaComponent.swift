//
//  StaminaComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

protocol HasStamina {
    
    var staminaComponent: StaminaComponent { get }
    
}

class StaminaComponent: Component {
    var stamina : Int
    
    init(stamina: Int) {
        self.stamina = stamina
    }
}
