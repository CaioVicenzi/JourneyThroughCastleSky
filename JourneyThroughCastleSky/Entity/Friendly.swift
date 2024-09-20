//
//  Friendly.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 20/09/24.
//

import Foundation

class Friendly {
    let spriteComponent : SpriteComponent
    let positionComponent : PositionComponent
    let dialogueComponent : DialogueComponent
    
    init(spriteName: String, xPosition: Int, yPosition : Int, dialogs : [Dialogue]) {
        self.spriteComponent = SpriteComponent(spriteName)
        self.dialogueComponent = DialogueComponent(dialogs: dialogs)
        self.positionComponent = PositionComponent(xPosition: xPosition, yPosition: yPosition)
    }
}
