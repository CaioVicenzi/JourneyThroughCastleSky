//
//  Enemy.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation
import SpriteKit

class Enemy : Identifiable{
    let id : UUID = UUID()
    let healthComponent : HealthComponent
    let spriteComponent : SpriteComponent
    let fightAIComponent : FightAIComponent = FightAIComponent()
    let positionComponent : PositionComponent
    let affectedByEffectComponent : AffectedByEffect = AffectedByEffect()
    let fighterComponent : FighterComponent
    
    init(x: Int, y: Int, damage : Int, health : Int, spriteName : String) {
        positionComponent = PositionComponent(xPosition: x, yPosition: y)
        fighterComponent = FighterComponent(damage: damage)
        spriteComponent = SpriteComponent(spriteName)
        healthComponent = HealthComponent(health: health)
    }
}
