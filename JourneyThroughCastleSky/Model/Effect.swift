//
//  Effect.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation

class Effect {
    let type : EffectType
    let amount : Int
    
    init(type: EffectType, amount: Int) {
        self.type = type
        self.amount = amount
    }
}

enum EffectType {
    case CURE
    case DAMAGE
    case NONE
}
