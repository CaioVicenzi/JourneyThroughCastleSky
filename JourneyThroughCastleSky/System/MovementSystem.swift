//
//  MovementSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation
import SpriteKit

class MovementSystem {
    var gameScene : TopDownScene!
    
    var mostRecentMove : [Move] = []
    
    enum Move {
        case UP, DOWN, LEFT, RIGHT
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func movePlayer () {
        if mostRecentMove.isEmpty {
            User.singleton.spriteComponent.sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            return
        }
        
        // Atualiza a posição do sprite com base nas teclas pressionadas
        var moveX: CGFloat = 0
        var moveY: CGFloat = 0
        let playerSpeed = 150.0

        switch mostRecentMove.last {
            case .UP: moveY += playerSpeed
            case .DOWN: moveY -= playerSpeed
            case .LEFT: moveX -= playerSpeed
            case .RIGHT: moveX += playerSpeed
            case nil: break
        }
        
        User.singleton.spriteComponent.sprite.physicsBody?.velocity = CGVector(dx: moveX, dy: moveY)
        updateUserPosition()
    }
    
    
    private func updateUserPosition () {
        User.singleton.positionComponent.xPosition = Int(User.singleton.spriteComponent.sprite.position.x)
        User.singleton.positionComponent.yPosition = Int(User.singleton.spriteComponent.sprite.position.y)
    }
    
    func updateCameraPosition () {
        //self.camera?.position = helloWorld.position
        guard let background = gameScene.background else {print("Não temos background no updateCameraPosition"); return}
        let playerSprite = User.singleton.spriteComponent.sprite
        
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
        switch event.keyCode {
            case 0x7E: // W key
            mostRecentMove.append(.UP)
            case 0x7B:  // A key
                mostRecentMove.append(.LEFT)
            case 0x7D:  // S key
                mostRecentMove.append(.DOWN)
            case 0x7C:  // D key
                mostRecentMove.append(.RIGHT)
            default:
                break
            }
    }
    
    func keyUp (_ event : NSEvent) {
        switch event.keyCode {
            case 0x7E: // SETA PARA CIMA
            endMove(.UP)
            case 0x7B:  // SETA PARA A ESQUERDA
                endMove(.LEFT)
            case 0x7D:  // SETA PARA BAIXO
                endMove(.DOWN)
            case 0x7C:  // SETA PARA DIREITA
                endMove(.RIGHT)
            default:
                break
            }
    }
    
    private func endMove (_ move : Move) {
        mostRecentMove.removeAll { listedMove in
            move == listedMove
        }
        
    }
    
    func checkColision () {
        gameScene.enemies.forEach { enemy in
            if isOtherNearPlayer(enemy.positionComponent, range: 30) {
                // Troca para a próxima cena
                let nextScene = BatalhaScene(size: gameScene.size)
                nextScene.config(enemy: enemy)
                enemy.spriteComponent.sprite.removeFromParent()
                nextScene.scaleMode = .aspectFill
                        
                let transition = SKTransition.fade(withDuration: 1.0)
                nextScene.config(gameScene)
                gameScene.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    func isOtherNearPlayer(_ positionOther : PositionComponent, range : CGFloat) -> Bool {
        let otherX = positionOther.xPosition
        let otherY = positionOther.yPosition
        
        let playerX = User.singleton.positionComponent.xPosition
        let playerY = User.singleton.positionComponent.yPosition
        
        let distance = sqrt(pow(CGFloat(playerX) - CGFloat(otherX), 2) + pow(CGFloat(playerY) - CGFloat(otherY), 2))
        return distance < range
    }
    
    
}
