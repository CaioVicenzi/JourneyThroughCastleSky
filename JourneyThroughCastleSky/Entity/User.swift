//
//  UserInventory.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 12/09/24.
//

import Foundation
import SpriteKit


class User: Entity {
    static let singleton = User()
    var currentPhase : GamePhase
    
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
    
    var levelComponent : LevelComponent {
        getComponent(LevelComponent.self) as! LevelComponent
    }
    
    override init() {
        self.currentPhase = .MAIN_HALL_SCENE
        super.init()
        addComponent(HealthComponent(health: 100))
        addComponent(InventoryComponent())
        addComponent(MovementComponent(velocity: 3))
        addComponent(StaminaComponent(stamina: 100, maxStamina: 100))
        addComponent(SpriteComponent("sprite"))
        addComponent(FighterComponent(damage: 5))
        addComponent(AffectedByEffect())
        addComponent(PositionComponent(xPosition: 100, yPosition: 100))
        addComponent(SkillComponent())
        addComponent(LevelComponent(0))
    }
    
    /// Função para aumentar o level do user, ele aumenta o level, a saúde máxima, a saúde, além de maximizar a estamina, além de aumentar o dano do usuário.
    func upLevel () {
        levelComponent.level += 1
        self.healthComponent.maxHealth += 10
        self.healthComponent.health = self.healthComponent.maxHealth
        self.staminaComponent.maxStamina += 10
        self.staminaComponent.stamina = self.staminaComponent.maxStamina
        self.fighterComponent.damage += 10
    }
}
