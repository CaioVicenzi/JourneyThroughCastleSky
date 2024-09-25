//
//  TopDownScene_IO.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

/// Criei essa extensão para evitar muito código acumulado na TopDownScene
/// Essa extensão conterá todas as funções relacionadas ao input do usuário.
extension TopDownScene {
    override func keyDown(with event: NSEvent) {
        if gameState == .NORMAL {
            movementSystem.keyDown(event)
        }
        
        if event.keyCode == 36 {
            if gameState == .NORMAL {
                frindlies.forEach { friendly in
                    if movementSystem.isOtherNearPlayer(friendly.positionComponent, range: 30) {
                        dialogsToPass.append(contentsOf: friendly.dialogueComponent.dialogs)
                        dialogSystem.nextDialogue()
                    }
                }
            } else {
                dialogSystem.nextDialogue()
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        
        if clickedNode.name == "buttonCatch"{
            itemSystem.catchItem()
            dialogSystem.nextDialogue()
        }
        
        
        if clickedNode.name == "buttonInventory" {
            self.itemSystem.inventoryButtonPressed()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        movementSystem.movePlayer()
        movementSystem.updateCameraPosition()
        movementSystem.checkColision ()
        itemSystem.verifyButtonCatch()
    }
}
