//
//  MovementSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation
import SpriteKit

class MovementSystem {
    var gameScene : GameScene!
    
    func config (_ gameScene : GameScene) {
        self.gameScene = gameScene
    }
    
    func movePlayer () {
        let velocity : Int = User.singleton.movementComponent.velocity
        let movimentoX = User.singleton.movementComponent.moveX
        let movimentoY = User.singleton.movementComponent.moveY
        
        
        if movimentoX >= velocity || movimentoX <= -velocity {
            if movimentoX < 0 {
                User.singleton.movementComponent.moveX += velocity
                User.singleton.positionComponent.xPosition -= velocity
                updateUserPosition()
            } else {
                User.singleton.movementComponent.moveX -= velocity
                User.singleton.positionComponent.xPosition += velocity
                updateUserPosition()
            }
        }
        
        if movimentoY >= velocity || movimentoY <= -velocity {
            if movimentoY < 0 {
                User.singleton.movementComponent.moveY += velocity
                User.singleton.positionComponent.yPosition -= velocity
                updateUserPosition()
            } else {
                User.singleton.movementComponent.moveY -= velocity
                User.singleton.positionComponent.yPosition += velocity
                updateUserPosition()
            }
        }
    }
    
    private func updateUserPosition () {
        if gameScene != nil {
            gameScene.playerSprite!.position.x = CGFloat(User.singleton.positionComponent.xPosition)
            gameScene.playerSprite!.position.y = CGFloat(User.singleton.positionComponent.yPosition)
        }
    }
    
    func updateCameraPosition () {
        //self.camera?.position = helloWorld.position
        
        guard let playerSprite = gameScene.playerSprite, let background = gameScene.background else {
            print("'não temos nada..'")
            return
        }
        var cameraPosition = playerSprite.position
                
        // Calcular os limites da câmera
        let cameraHalfWidth = gameScene.size.width / 2
        let cameraHalfHeight = gameScene.size.height / 2
                
        // Limitar o movimento da câmera nos eixos X e Y
        let minX = cameraHalfWidth
        let maxX = background.size.width - cameraHalfWidth
        let minY = cameraHalfHeight
        let maxY = background.size.height - cameraHalfHeight
                
        // Verificar se a câmera está nos limites horizontais
        if cameraPosition.x < minX {
            cameraPosition.x = minX
        } else if cameraPosition.x > maxX {
            cameraPosition.x = maxX
        }
                
        // Verificar se a câmera está nos limites verticais
        if cameraPosition.y < minY {
            cameraPosition.y = minY
        } else if cameraPosition.y > maxY {
            cameraPosition.y = maxY
        }
        
        // Atualizar a posição da câmera
        gameScene.cameraNode.position = cameraPosition
    }
    
    func keyDown (_ event : NSEvent) {
        guard let character = event.charactersIgnoringModifiers else {
            return
        }
                    
        let moveAmount = 10
        
        switch character {
        case "w" :
            User.singleton.movementComponent.moveY += moveAmount
        case "a" :
            User.singleton.movementComponent.moveX -= moveAmount
        case "s" :
            User.singleton.movementComponent.moveY -= moveAmount
        case "d" :
            User.singleton.movementComponent.moveX += moveAmount
            default: break
        }
    }
    
    func keyUp (_ event : NSEvent) {
        User.singleton.movementComponent.moveX = 0
        User.singleton.movementComponent.moveY = 0
    }
    
    func checkColision () {
        if isEnemyNearPlayer() {
            // Troca para a próxima cena
            let nextScene = BatalhaScene(size: gameScene.size)
            nextScene.config(enemy: gameScene.enemy)
            gameScene.enemy.spriteComponent.sprite.removeFromParent()
            nextScene.scaleMode = .aspectFill
                    
            let transition = SKTransition.fade(withDuration: 1.0)
            gameScene.view?.presentScene(nextScene, transition: transition)
        }
         
    }
    
    func isEnemyNearPlayer() -> Bool {
        let enemyX = gameScene.enemy.positionComponent.xPosition
        let enemyY = gameScene.enemy.positionComponent.yPosition
        
        let playerX = User.singleton.positionComponent.xPosition
        let playerY = User.singleton.positionComponent.yPosition
        
        let distance = sqrt(pow(CGFloat(playerX) - CGFloat(enemyX), 2) + pow(CGFloat(playerY) - CGFloat(enemyY), 2))
        return distance < 30
         
    }
}
