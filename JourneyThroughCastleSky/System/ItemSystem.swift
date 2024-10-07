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
    var items : [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
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
            if self.gameScene.positionSystem.isOtherNearPlayer(positionComponent, range: 50){
                if node.parent != nil {
                    node.removeFromParent()
                }
            }
        }
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
            return gameScene.positionSystem.calcDistanceFromUser(item.positionComponent) < 50
        } else {
            return false
        }
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
    
    static func useItem (_ item : Item) {
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
