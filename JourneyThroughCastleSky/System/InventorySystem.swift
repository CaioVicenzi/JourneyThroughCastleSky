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
            
        gameScene.inventory?.optionSelected = 0
        gameScene.dialogSystem.next()
        gameScene.inventory?.closePause()
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
            gameScene.inventory?.setupPause()
            gameScene.gameState = .PAUSE
        } else {
            gameScene.inventory?.closePause()
        }
        
        gameScene.inventory?.cleanInput()
    }
    
    
    
    func selectItemInventory (_ keyCode : UInt16) {
        /*
        guard let inventory = gameScene.inventory else {return}
        
        // quantidade de itens que tem dentro do inventário personagem.
        let inventoryItemSelected = inventory.inventoryItemSelected
         */
        let inventoryItemsCount = User.singleton.inventoryComponent.itens.count

        guard let option = gameScene.inventory?.optionSelected else {
            return
        }
        
        switch keyCode {
            case 0x7B:  // LEFT key
            
            if option > 0 {
                gameScene.inventory?.optionSelected -= 1
            }
            
            
            case 0x7C:  // RIGHT key
                if option < inventoryItemsCount - 1 {
                    gameScene.inventory?.optionSelected += 1
                }
            default: break
        }
         
    }
}
