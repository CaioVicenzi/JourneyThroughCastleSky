//
//  UserInventory.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 12/09/24.
//

import Foundation
import SpriteKit

class User: Entity, IsFighter {
    static let singleton = User()
    
    var healthComponent: HealthComponent {
        getComponent(HealthComponent.self) as! HealthComponent
    }
    var inventoryComponent: InventoryComponent {
        getComponent(InventoryComponent.self) as! InventoryComponent
    }
    var movementComponent: MovementComponent {
        getComponent(MovementComponent.self) as! MovementComponent
    }
    var staminaComponent: StaminaComponent {
        getComponent(StaminaComponent.self) as! StaminaComponent
    }
    var spriteComponent: SpriteComponent {
        getComponent(SpriteComponent.self) as! SpriteComponent
    }
    
    var fighterComponent: FighterComponent {
        getComponent(FighterComponent.self) as! FighterComponent
    }
    
    var affectedByEffectComponent: AffectedByEffect {
        getComponent(AffectedByEffect.self) as! AffectedByEffect
    }
    
    var positionComponent: PositionComponent {
        getComponent(PositionComponent.self) as! PositionComponent
    }
    
    var skillComponent: SkillComponent {
        getComponent(SkillComponent.self) as! SkillComponent
    }
    
    override init() {
        super.init()
        addComponent(HealthComponent(health: 100))
        addComponent(InventoryComponent())
        addComponent(MovementComponent(velocity: 3))
        addComponent(StaminaComponent(stamina: 100))
        addComponent(SpriteComponent("sprite"))
        addComponent(FighterComponent(damage: 5))
        addComponent(AffectedByEffect())
        addComponent(PositionComponent(xPosition: 100, yPosition: 100))
        addComponent(SkillComponent())
        
        fighterComponent.attacks.append(.init(damage: 100, executionTime: 2))
    }
    
}
