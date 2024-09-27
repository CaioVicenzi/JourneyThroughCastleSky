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
    }
    
}

/*
class User {
    static var singleton : User = User()
    
    var inventory : [Item] = []
    var life : Int = 100
    var damage : Int = 5
    
    
    func useItem (by index : Int, label : SKLabelNode) {
        let item = inventory[index]
        
        switch item {
        case .BALOON:
            damage += 10
        case .CUPCAKE:
            life += 15
            label.text = "Life: \(life)"
        }
        
        inventory.remove(at: index)
    }
}


enum Item : String {
    case BALOON = "balloon"
    case CUPCAKE = "cupcake"
}
 */
