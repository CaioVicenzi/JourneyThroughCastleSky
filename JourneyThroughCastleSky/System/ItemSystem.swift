//
//  ItemSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation
import SpriteKit

class ItemSystem {
    var gameScene : TopDownScene!
    var isInventoryOpen : Bool = false
    var items : [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func inventoryButtonPressed () {
        if isInventoryOpen {
            gameScene.inventory?.removeFromParent()
            gameScene.inventory?.children.forEach({ node in
                node.removeFromParent()
            })
            gameScene.removeLabelUseItem()
            gameScene.gameState = .NORMAL
        } else {
            gameScene.setupInventory()
            gameScene.gameState = .INVENTORY
        }
        
        isInventoryOpen.toggle()
        
    }
    
    /// função que pega o item mais próximo.
    func catchNearestItem (){
        items.forEach { item in
            if isItemNearUser(item) {
                removeNearestItemSprite(item.consumableComponent!.nome)
                catchItem(item)
                items.removeAll { currentItem in
                    currentItem.id == item.id
                }
                gameScene.dialogSystem.nextDialogue()
            }
        }
    }
    
    private func removeNearestItemSprite (_ name : String) {
        gameScene.enumerateChildNodes(withName: name) { node, _ in
            let positionComponent = PositionComponent(xPosition: Int(node.position.x), yPosition: Int(node.position.y))
            if self.isPositionNearPlayer(positionComponent) {
                if node.parent != nil {
                    node.removeFromParent()
                }
            }
        }
    }
    
    /// Essa função serve para ver se o sprite está perto do player
    private func isPositionNearPlayer(_ positionComponent : PositionComponent) -> Bool {
        return calcDistanceFromUser(positionComponent) < 50
    }
    
    /// Essa função pega um item, exibe os diálogos e coloca no inventário
    private func catchItem (_ item : Item) {
        // função para adicionar o balão ao inventário do usuário.
        item.spriteComponent.sprite.removeFromParent()
        
        // para cada um dos diálogos dentro do componente do item,
        populateDialogs(item.dialogueComponent?.dialogs)
        
        if let sprite = item.spriteComponent.sprite.copy() as? SKSpriteNode {
            gameScene.descriptionsToPass.append(DescriptionToPass(sprite: sprite, description: item.readableComponent.readableDescription))
        }
        
        //gameScene.buttonCatch?.removeFromParent()
        gameScene.catchLabel?.removeFromParent()
        User.singleton.inventoryComponent.itens.append(item)
    }
    
    private func populateDialogs (_ dialogs : [Dialogue]?) {
        dialogs?.forEach({ dialogue in
            gameScene.dialogsToPass.append(dialogue)
        })
    }
    
    private func isItemNearUser (_ item : Item) -> Bool {
        if gameScene.gameState == .NORMAL {
            return calcDistanceFromUser(item.positionComponent) < 50
        } else {
            return false
        }
    }
    
    private func calcDistanceFromUser (_ positionComponent : PositionComponent) -> CGFloat {
        let xPlayer = User.singleton.positionComponent.xPosition
        let yPlayer = User.singleton.positionComponent.yPosition
        
        let xItem = positionComponent.xPosition
        let yItem = positionComponent.yPosition
        
        let x = pow(CGFloat(xPlayer) - CGFloat(xItem), 2)
        let y = pow(CGFloat(yPlayer) - CGFloat(yItem), 2)
        
        return sqrt(CGFloat(x) + CGFloat(y))
    }
    
    /// Função que verifica se vai exibir o botão de pegar o item
    func showCatchLabel () {
        // se a existe algum item perto do usuário, então adiciona o buttonCatch na gameScene, caso contrário, remove o buttonCatch da cena.
        if isAnyItemNear() {
            if self.gameScene.catchLabel?.parent == nil {
                self.gameScene.setupCatchLabel()
            }
        } else {
            if self.gameScene.catchLabel?.parent != nil {
                self.gameScene.catchLabel?.removeFromParent()
            }
        }
    }
    
    
    // função que verifica se existe algum item perto do usuário
    func isAnyItemNear () -> Bool {
        var anyItemNear = false
        items.forEach { item in
            if isItemNearUser(item) {
                anyItemNear = true
            }
        }
        return anyItemNear
    }
    
    func useItem (_ item : Item) {
        if let effect = item.consumableComponent?.effect {
            switch effect.type {
            case .CURE:
                User.singleton.healthComponent.health += effect.amount
            case .DAMAGE:
                User.singleton.fighterComponent.damage += effect.amount
            case .STAMINE:
                User.singleton.staminaComponent.stamina += effect.amount
            case .NONE:
                break
            }
        }
    }
}
