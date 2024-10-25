//
//  InventorySystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/10/24.
//

import Foundation
import SpriteKit

/// Toda a lógica envolvida com o inventário será desenvolvida aqui dentro dessa classe
class InventorySystem: System {

    
    /// Função criada para que a partir de um inteiro que representa a posição de um elemento dentro do inventário, é possível você usar um item.
    func useItemFromInventory (in position : Int) {
        guard let item = InventorySystem.getInventoryItem(position) else {
            return
        }
        
        ItemSystem.useItem(item)
            
        if item.consumableComponent?.effect.type == .NONE || item.consumableComponent?.effect.type == .UP_LEVEL {
            //não é pra remover
            gameScene.dialogSystem.inputDialog("I can't consume this item...", person: "You", velocity: 20)
        } else {
            // é pra remover
            InventorySystem.removeItemFromInventory(item)
        }
            
        gameScene.inventoryItemSelected = 0
        gameScene.dialogSystem.nextDialogue()
        closeInventory()
    }
    
    static func removeItemFromInventory(_ item : Item) {
        User.singleton.inventoryComponent.itens.removeAll { i in
            i.id == item.id
        }
    }
    
    static func getInventoryItem (_ position : Int) -> Item? {
        guard position < User.singleton.inventoryComponent.itens.count else {
            return nil
        }
        
        return User.singleton.inventoryComponent.itens[position]
    }
    
    func inventoryButtonPressed () {
        if gameScene.gameState == .NORMAL {
            gameScene.setupInventory()
            gameScene.gameState = .INVENTORY
        } else {
            closeInventory()
        }
    }
    
    private func closeInventory () {
        guard let inventory = gameScene.inventory else {print("não temos inventory"); return}
        /*
        // Cria o efeito de fadeIn para poder adicionar ele dentro dos componentes do inventory.
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let fadeOutAndRemove = SKAction.sequence([fadeOut, removeAction])
        
        
        gameScene.inventory?.children.forEach({ node in
            node.run(fadeOutAndRemove)
            node.removeFromParent()
        })
        
        inventory.run(fadeOutAndRemove)

         */
        gameScene.gameState = .NORMAL

        gameScene.inventory?.children.forEach({ node in
            node.removeFromParent()
        })
        inventory.removeFromParent()
    }
    
    func selectItemInventory (_ keyCode : UInt16) {
        // quantidade de itens que tem dentro do inventário personagem.
        let inventoryItemsCount = User.singleton.inventoryComponent.itens.count
        let inventoryItemSelected = gameScene.inventoryItemSelected
        
        switch keyCode {
            case 0x7B:  // LEFT key
            if inventoryItemSelected > 0 {
                gameScene.inventoryItemSelected -= 1
                }
            case 0x7C:  // RIGHT key
            if inventoryItemSelected < inventoryItemsCount - 1  {
                gameScene.inventoryItemSelected += 1
            }
            default: break
        }
    }
    
    func input (_ keyCode : UInt16) {
        let isEnterKey = keyCode == 36
        
        selectItemInventory(keyCode)
        if isEnterKey {
            self.useItemFromInventory(in: gameScene.inventoryItemSelected)
        }
    }
}
