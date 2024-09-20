//
//  ItemSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation

class ItemSystem {
    var gameScene : GameScene!
    var isInventoryOpen : Bool = false
    
    
    
    func config (_ gameScene : GameScene) {
        self.gameScene = gameScene
    }
    
    func inventoryButtonPressed () {
        if isInventoryOpen {
            gameScene.inventory?.removeFromParent()
            gameScene.inventory?.children.forEach({ node in
                node.removeFromParent()
            })
        } else {
            gameScene.setupInventory()
        
        }
        
        isInventoryOpen.toggle()
    }
    
    func catchItem (){
        var nearestItem : Item? = nil
        var nearestDistance : CGFloat = 0.0
        
        gameScene.itens.forEach { item in
            if nearestItem == nil {
                nearestItem = item
                nearestDistance = calcDistanceItem(item)
                
            } else {
                // calcular a distância
                let distance = calcDistanceItem(item)
                
                if distance <= nearestDistance {
                    nearestItem = item
                    nearestDistance = distance
                }
            }
        }
        
        if let nearestItem {
            catchItem(nearestItem)
        }
    }
    
    private func catchItem (_ item : Item) {
        // função para adicionar o balão ao inventário do usuário.
        item.spriteComponent.sprite.removeFromParent()
        
        item.dialogueComponent?.dialogs.forEach({ dialogue in
            gameScene.dialogsToPass.append(dialogue)
            
            
        })
        
        //item.positionComponent.yPosition = 4000
        gameScene.buttonCatch?.removeFromParent()
        User.singleton.inventoryComponent.itens.append(item)
    }
    
    private func verifyItemIsNear (_ item : Item) -> Bool {
        if item.spriteComponent.sprite.parent == nil {
            return false
        }
        
        if item.spriteComponent.sprite.parent?.name == "inventory" {
            return false
        }
        
        return calcDistanceItem(item) < 50
    }
    
    private func calcDistanceItem (_ item : Item) -> CGFloat {
        let xPlayer = User.singleton.positionComponent.xPosition
        let yPlayer = User.singleton.positionComponent.yPosition
        
        let xItem = item.positionComponent.xPosition
        let yItem = item.positionComponent.yPosition
        
        let x = pow(CGFloat(xPlayer) - CGFloat(xItem), 2)
        let y = pow(CGFloat(yPlayer) - CGFloat(yItem), 2)
        
        return sqrt(CGFloat(x) + CGFloat(y))
    }
    
    /// Função que verifica se vai exibir o botão de pegar o item
    func verifyButtonCatch () {
        
        // primeiro verifica se existe algum item perto do usuário e armazena na variável showButtonCatch
        var showButtonCatch = false
        gameScene.itens.forEach { item in
            if verifyItemIsNear(item) {
                showButtonCatch = true
            }
        }
        
        // se a showButtonCatch for verdadeira, então adiciona o buttonCatch na gameScene, caso contrário, remove o buttonCatch da cena.
        if showButtonCatch {
            if self.gameScene.buttonCatch?.parent == nil {
                self.gameScene.setupButtonCatch()
            }
        } else {
            if self.gameScene.buttonCatch?.parent != nil {
                self.gameScene.buttonCatch?.removeFromParent()
            }
        }
    }
}
