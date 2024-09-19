//
//  Item.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation
import SpriteKit

class Item {
    let interactableComponent = InteractableComponent()
    let dialogueComponent : DialogueComponent?
    let consumableComponent : ConsumableComponent?
    let spriteComponent : SpriteComponent
    let positionComponent : PositionComponent
    
    init(name : String, spriteName: String, dialogs : [Dialogue], effect : Effect, x: Int, y: Int) {
        self.dialogueComponent = DialogueComponent(dialogs: dialogs)
        self.consumableComponent = ConsumableComponent(nome: name, effect: effect)
        self.spriteComponent = SpriteComponent(spriteName)
        self.positionComponent = PositionComponent(xPosition: x, yPosition: y)
    }
    
    init(spriteName: String, x: Int, y: Int) {
        consumableComponent = nil
        dialogueComponent = nil
        self.spriteComponent = SpriteComponent(spriteName)
        self.positionComponent = PositionComponent(xPosition: x, yPosition: y)
    }
}
