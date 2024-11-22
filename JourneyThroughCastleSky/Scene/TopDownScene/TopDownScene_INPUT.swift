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
        let isIKey = event.keyCode == 34
        let isEscKey = event.keyCode == 53
        let isEnterKey = event.keyCode == 36
        
        if gameState == .NORMAL {
            movementSystem.input(event)
            if isEnterKey {
                // fale com o amigável mais próximo ou pegue o item mais próximo (se existirem)
                friendlySystem.talkToNearestFriendly()
                itemSystem.catchNearestItem()
            }
            if isEscKey {// tecla Esc
                //menuSystem.togglePause()
                inventorySystem.inventoryButtonPressed()
            }
        } else if gameState == .PAUSE {
            inventory?.input(Int(event.keyCode))
        } else if gameState == .DIALOG_FINISHED || gameState == .WAITING_DIALOG {
            dialogSystem.input(event.keyCode)
        }
        
        if isIKey { // tecla i
            inventorySystem.inventoryButtonPressed()
        }
    }
}

