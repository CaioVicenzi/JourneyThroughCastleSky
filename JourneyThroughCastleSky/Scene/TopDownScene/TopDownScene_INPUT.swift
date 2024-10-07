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
        
        if gameState == .INVENTORY {
            selectItemInventory(event)
        }
        
        if gameState == .PAUSE {
            selectPauseOption(event)
        }
        
        let isEnterKey = event.keyCode == 36
        let isIKey = event.keyCode == 34
        let isEscKey = event.keyCode == 53
        
        if isEnterKey { // tecla enter
            enterKeyPressed()
        }
        
        if isIKey { // tecla i
            iKeyPressed()
        }
        
        if isEscKey {// tecla Esc
            escKeyPressed()
        }
    }
    
    private func selectPauseOption (_ event : NSEvent){
        switch event.keyCode {
            case 0x7E: // UP key
                pauseUIComponent.pressUpKey()
            case 0x7D:  // DOWN key
                pauseUIComponent.pressDownKey()
            case 36:
                pauseUIComponent.pressEnterKey()
            default: break
        }
    }
    
    private func selectItemInventory (_ event : NSEvent) {
        // quantidade de itens que tem dentro do inventário personagem.
        let inventoryItemsCount = User.singleton.inventoryComponent.itens.count
        
        switch event.keyCode {
            case 0x7E: // UP key
                break
            case 0x7B:  // LEFT key
            if inventoryItemSelected > 0 {
                    inventoryItemSelected -= 1
                }
            case 0x7D:  // DOWN key
                break
            case 0x7C:  // RIGHT key
            if inventoryItemSelected < inventoryItemsCount - 1  {
                inventoryItemSelected += 1
            }
            case 32: // u key
                uKeyPressed()
            default: break
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
        } else if gameState == .DIALOG_FINISHED  {
            dialogSystem.nextDialogue()
        } else if gameState == .INVENTORY {
            itemSystem.inventoryButtonPressed()
            let itemSelected = User.singleton.inventoryComponent.itens[inventoryItemSelected]
            
            descriptionsToPass.append(DescriptionToPass(sprite: itemSelected.spriteComponent.sprite, description: itemSelected.readableComponent.readableDescription))
            inventoryItemSelected = 0
            dialogSystem.nextDialogue()
        }
    }
    
    private func uKeyPressed () {
        let itemThatsGoingToBeUsed = User.singleton.inventoryComponent.itens[inventoryItemSelected]
        itemSystem.useItem(itemThatsGoingToBeUsed)
        
    }
    
    private func iKeyPressed () {
        if gameState == .NORMAL || gameState == .INVENTORY {
            itemSystem.inventoryButtonPressed()
        }
    }
    
    private func escKeyPressed () {
        if gameState == .PAUSE {
            gameState = .NORMAL
            pauseUIComponent.cleanMenuPause(cameraNode: self.cameraNode)
        } else if gameState == .NORMAL{ // somente pode dar pause quando o jogo estiver no modo normal
            gameState = .PAUSE
            movementSystem.mostRecentMove = []
            pauseUIComponent.addToScene(self)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        movementSystem.movePlayer()
        movementSystem.updateCameraPosition()
        movementSystem.checkColision ()
        itemSystem.showCatchLabel()
        if gameState == .INVENTORY {
            updateInventorySquares()
            updateLabelUseItem()
        }
    }
}
