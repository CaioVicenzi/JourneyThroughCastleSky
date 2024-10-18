//
//  MainHallScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import SpriteKit
import GameplayKit

protocol Command {
    func execute() -> Void
}

class Consumable: Command {
    func execute() {
        
    }
}

class MainHallScene: TopDownScene {
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        
        let primeiroBody: SKPhysicsBody
        let segundoBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            primeiroBody = contact.bodyA
            segundoBody = contact.bodyB
        } else {
            primeiroBody = contact.bodyB
            segundoBody = contact.bodyA
        }
        
        let collidedWithDoorNextScene = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint
        if collidedWithDoorNextScene {
            if User.singleton.inventoryComponent.itens.contains(where: { item in
                item.consumableComponent?.nome == "Chaves"
            }) {
                goNextScene()
            } else {
                self.dialogSystem.inputDialog("Preciso da chave para entrar aqui...", person: "You", velocity: 20)
                dialogSystem.nextDialogue()
            }        }
    }
}
