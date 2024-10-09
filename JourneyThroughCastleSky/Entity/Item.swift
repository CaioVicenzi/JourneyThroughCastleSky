//
//  Item.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation
import SpriteKit

class Item : Identifiable{
    let id = UUID()
    let interactableComponent = InteractableComponent()
    let dialogueComponent : DialogueComponent?
    let consumableComponent : ConsumableComponent?
    let spriteComponent : SpriteComponent
    let positionComponent : PositionComponent
    let readableComponent : ReadableComponent
    
    init(name : String, spriteName: String, dialogs : [Dialogue] = [], effect : Effect, x: Int, y: Int, description : String) {
        self.dialogueComponent = DialogueComponent(dialogs: dialogs)
        self.consumableComponent = ConsumableComponent(nome: name, effect: effect)
        self.spriteComponent = SpriteComponent(spriteName)
        self.positionComponent = PositionComponent(xPosition: x, yPosition: y)
        self.readableComponent = ReadableComponent(readableDescription: description)
    }
    
    init(spriteName: String, x: Int, y: Int, description : String) {
        consumableComponent = nil
        dialogueComponent = nil
        self.spriteComponent = SpriteComponent(spriteName)
        self.positionComponent = PositionComponent(xPosition: x, yPosition: y)
        self.readableComponent = ReadableComponent(readableDescription: description)
    }
}
