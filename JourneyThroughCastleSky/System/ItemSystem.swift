//
//  ItemSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation
import SpriteKit

class ItemSystem: System {
    var items : [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    

    
    /// função que pega o item mais próximo.
    func catchNearestItem (){
        items.forEach { item in
            let itemNearUser = PositionSystem.isOtherNearPlayer(item.positionComponent, range: 50)
            if itemNearUser{
                
                let isCrystal = item.consumableComponent?.effect.type == .UP_LEVEL
                
                let userHasKey = User.singleton.inventoryComponent.itens.contains { item in
                    item.consumableComponent?.nome == "Chaves"
                }
                
                if isCrystal {
                    if userHasKey {
                        catchItem(item)
                    } else {
                        gameScene.dialogSystem.inputDialog("Não consigo pegar o cristal sem a chave...", person: "Você", velocity: 20)
                    }
                } else {
                    catchItem(item)
                }
                
                gameScene.dialogSystem.nextDialogue()
            }
        }
    }
    
    private func removeNearestItemSprite (_ name : String) {
        gameScene.enumerateChildNodes(withName: name) { node, _ in
            let positionComponent = PositionComponent(xPosition: Int(node.position.x), yPosition: Int(node.position.y))
            if PositionSystem.isOtherNearPlayer(positionComponent, range: 50){
                if node.parent != nil {
                    node.removeFromParent()
                }
            }
        }
    }
    
    /// Essa função pega um item, exibe os diálogos e coloca no inventário
    private func catchItem (_ item : Item) {
        removeNearestItemSprite(item.consumableComponent!.nome)

        // remover o item do mapa.
        item.spriteComponent.sprite.removeFromParent()
                
        // adicionar os diálogos do item dentro da lista de diálogos para passar.
        if let dialogs = item.dialogueComponent?.dialogs {
            gameScene.dialogSystem.inputDialogs(dialogs)
        }
                
        // adiciona também a descrição do item
        if let sprite = item.spriteComponent.sprite.copy() as? SKSpriteNode {
            gameScene.descriptionsToPass.append(DescriptionToPass(sprite: sprite, description: item.readableComponent.readableDescription))
        }
                
        gameScene.catchLabel?.removeFromParent()
        User.singleton.inventoryComponent.itens.append(item)
                
        items.removeAll { currentItem in
            currentItem.id == item.id
        }
    }
    
    
    
    /// Função que verifica se vai exibir o botão de pegar o item
    func showCatchLabel () {
        // se a existe algum item perto do usuário, então adiciona o buttonCatch na gameScene, caso contrário, remove o buttonCatch da cena.
        if PositionSystem.isAnyNearPlayer(items.map({ item in item.positionComponent})) && gameScene.gameState == .NORMAL {
            if self.gameScene.catchLabel?.parent == nil {
                self.gameScene.setupCatchLabel()
            }
        } else {
            if self.gameScene.catchLabel?.parent != nil {
                self.gameScene.catchLabel?.removeFromParent()
            }
        }
    }
     
    
    static func useItem (_ item : Item) {
        if let effect = item.consumableComponent?.effect {
            switch effect.type {
            case .CURE:
                cure(item.consumableComponent!.effect.amount)
            case .DAMAGE:
                User.singleton.fighterComponent.damage += effect.amount
            case .STAMINE:
                User.singleton.staminaComponent.stamina += effect.amount
            case .NONE:
                break
            case .UP_LEVEL:
                User.singleton.upLevel()
            }
        }
    }
    
    private static func cure (_ amount : Int) {
        if User.singleton.healthComponent.health + amount >= 100 {
            User.singleton.healthComponent.health = 100
        } else {
            User.singleton.healthComponent.health += amount
        }
    }
}
