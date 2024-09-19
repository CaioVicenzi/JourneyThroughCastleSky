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
        } else {
            gameScene.setupInventory()
        }
        
        isInventoryOpen.toggle()
    }
    
    func catchItem (){
        if verifyItemIsNear(gameScene.item1) {
            catchItem(gameScene.item1)
        }
        
        if verifyItemIsNear(gameScene.item2) {
            catchItem(gameScene.item2)
        }
    }
    
    private func catchItem (_ item : Item) {
        // função para adicionar o balão ao inventário do usuário.
        item.spriteComponent.sprite.removeFromParent()
        
        //item.positionComponent.yPosition = 4000
        gameScene.buttonCatch?.removeFromParent()
        User.singleton.inventoryComponent.itens.append(item)
    }
    
    private func verifyItemIsNear (_ item : Item) -> Bool {
        print(User.singleton.inventoryComponent.itens)
        
        if item.spriteComponent.sprite.parent == nil {
            return false
        }
        
        if item.spriteComponent.sprite.parent?.name == "inventory" {
            return false
        }
        
        let xPlayer = User.singleton.positionComponent.xPosition
        let yPlayer = User.singleton.positionComponent.yPosition
        
        let xItem = item.positionComponent.xPosition
        let yItem = item.positionComponent.yPosition
        
        let x = pow(CGFloat(xPlayer) - CGFloat(xItem), 2)
        let y = pow(CGFloat(yPlayer) - CGFloat(yItem), 2)
        
        let distance = sqrt(CGFloat(x) + CGFloat(y))
        
        return distance < 50
    }
    
    func verifyButtonCatch () {
        if verifyItemIsNear(gameScene.item1) || verifyItemIsNear(gameScene.item2) {
            if gameScene.buttonCatch?.parent == nil {
                gameScene.setupButtonCatch()
            }
        } else {
            if gameScene.buttonCatch?.parent != nil {
                gameScene.buttonCatch?.removeFromParent()
            }
        }
    }
}
