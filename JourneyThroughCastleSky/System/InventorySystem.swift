//
//  InventorySystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/10/24.
//

import Foundation
import SpriteKit

/// Toda a lógica envolvida com o inventário será desenvolvida aqui dentro dessa classe
class InventorySystem {
    var gameScene : TopDownScene!
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    /// Função criada para que a partir de um inteiro que representa a posição de um elemento dentro do inventário, é possível você usar um item.
    func useItemFromInventory (in position : Int) {
        let item = InventorySystem.getInventoryItem(position)
        ItemSystem.useItem(item)
        
        if item.consumableComponent?.effect.type == .NONE {
            //não é pra remover
            gameScene.dialogsToPass.append(Dialogue(text: "I can't consume this item...", person: "You", velocity: 20))
        } else {
            // é pra remover
            InventorySystem.removeItemFromInventory(item)
        }
    }
    
    static func removeItemFromInventory(_ item : Item) {
        User.singleton.inventoryComponent.itens.removeAll { i in
            i.id == item.id
        }
    }
    
    static func getInventoryItem (_ position : Int) -> Item {
        guard position < User.singleton.inventoryComponent.itens.count else {
            fatalError("Item dessa posição não existe.")
        }
        
        return User.singleton.inventoryComponent.itens[position]
    }
    
    func inventoryButtonPressed () {
        if gameScene.gameState == .NORMAL {
            gameScene.setupInventory()
            gameScene.gameState = .INVENTORY
        } else {
            guard let inventory = gameScene.inventory else {return}
            // Cria o efeito de fadeIn para poder adicionar ele dentro dos componentes do inventory.
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let removeAction = SKAction.removeFromParent()
            let fadeOutAndRemove = SKAction.sequence([fadeOut, removeAction])
            
            inventory.run(fadeOutAndRemove)
            
            gameScene.inventory?.children.forEach({ node in
                node.run(fadeOutAndRemove)
                node.removeFromParent()
            })
            gameScene.gameState = .NORMAL
        }
    }
}
