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
    
    let healthComponent = HealthComponent(health: 100)
    let inventoryComponent = InventoryComponent()
    let movementComponent = MovementComponent(velocity: 3)
    let staminaComponent = StaminaComponent(stamina: 100)
    let spriteComponent = SpriteComponent ("sprite")
    let fighterComponent = FighterComponent(damage: 5)
    let affectedByEffectComponent = AffectedByEffect()
    let positionComponent = PositionComponent(xPosition: 100, yPosition: 100)
    
    
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
