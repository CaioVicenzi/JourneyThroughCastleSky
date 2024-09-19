//
//  GameSceneController.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 17/09/24.
//

import Foundation
import SpriteKit

class GameSceneController {
    var gameScene : GameScene!
    
    func config(gameScene : GameScene) {
        self.gameScene = gameScene
    }
    
    func moveEnemyTowardsPlayer() {
        /*
        let playerPosition = gameScene.player.position
        let enemyPosition = gameScene.enemy.position
           
        // Calcula a direção do inimigo em relação ao jogador
        let dx = playerPosition.x - enemyPosition.x
        let dy = playerPosition.y - enemyPosition.y
        let direction = CGPoint(x: dx, y: dy)
           
        // Normaliza a direção (para ter um vetor de comprimento 1)
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)
        let normalizedDirection = CGPoint(x: direction.x / length, y: direction.y / length)
           
        // Velocidade do inimigo
        let enemySpeed: CGFloat = 100.0 // Ajuste conforme necessário
           
        // Atualiza a posição do inimigo
        let moveAmount = CGPoint(x: normalizedDirection.x * enemySpeed * CGFloat(1.0/60.0), // Considera o frame rate (60 fps)
                                    y: normalizedDirection.y * enemySpeed * CGFloat(1.0/60.0))
           
        gameScene.enemy.position = CGPoint(x: gameScene.enemy.position.x + moveAmount.x,
                                 y: gameScene.enemy.position.y + moveAmount.y)
         */
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
    
    
    private func verifyItemIsNear (_ item : Item) -> Bool {
        let xPlayer = User.singleton.positionComponent.xPosition
        let yPlayer = User.singleton.positionComponent.yPosition
        
        let xItem = item.positionComponent.xPosition
        let yItem = item.positionComponent.yPosition
        
        let x = pow(CGFloat(xPlayer) - CGFloat(xItem), 2)
        let y = pow(CGFloat(yPlayer) - CGFloat(yItem), 2)
        
        let distance = sqrt(CGFloat(x) + CGFloat(y))
        
        return distance < 50
    }
    
    private func catchItem (_ item : Item) {
        // função para adicionar o balão ao inventário do usuário.
        item.spriteComponent.sprite.removeFromParent()
        item.positionComponent.yPosition = 4000
        gameScene.buttonCatch?.removeFromParent()
        User.singleton.inventoryComponent.itens.append(item)
    }
    
    func mouseDown (_ event : NSEvent) {
        let location = event.location(in: gameScene)
        let clickedNode = gameScene.atPoint(location)
        
        
        if clickedNode.name == "buttonCatch"{
            if verifyItemIsNear(gameScene.item1) {
                catchItem(gameScene.item1)
            }
            
            if verifyItemIsNear(gameScene.item2) {
                catchItem(gameScene.item2)
            }
        }
        
         
        if clickedNode.name == "buttonInventory" {
            if let inventory = gameScene.inventory {
                if inventory.parent != nil {
                    inventory.removeFromParent()
                } else {
                    gameScene.setupInventory()
                }
            } else {
                gameScene.setupInventory()
            }
        }
    }
}
