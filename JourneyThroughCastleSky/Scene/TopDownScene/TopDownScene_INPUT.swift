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
        
        if event.keyCode == 36 { // tecla enter
            enterKeyPressed()
        }
        
        if event.keyCode == 34 { // tecla i
            iKeyPressed()
        }
    }
    
    // Função ativada quando a tecla Enter for pressionada do teclado do usuário.
    private func enterKeyPressed () {
        if gameState == .NORMAL {
            // se existir algum amigável por perto, então fale com o amigável mais próximo.
            if friendlySystem.isAnyFriendlyNear() {
                friendlySystem.talkToNearestFriendly()
            }
            
            // se houver um item perto, então pegue o item mais próximo
            itemSystem.catchNearestItem()
        } else {
            dialogSystem.nextDialogue()
        }
    }
    
    
    
    private func iKeyPressed () {
        itemSystem.inventoryButtonPressed()
    }
    
    override func update(_ currentTime: TimeInterval) {
        movementSystem.movePlayer()
        movementSystem.updateCameraPosition()
        movementSystem.checkColision ()
        itemSystem.verifyButtonCatch()
    }
}
