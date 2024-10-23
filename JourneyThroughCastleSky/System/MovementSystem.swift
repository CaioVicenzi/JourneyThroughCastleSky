//
//  MovementSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 19/09/24.
//

import Foundation
import SpriteKit


/// Uma classe onde toda a lógica relacionada ao movimento dentro de uma TopDownScene está contida.
class MovementSystem {
    var gameScene : TopDownScene!
    
    // essa variável é um array de todas as teclas que estão pressionadas, a mais recente é a que vai valer, isso faz com que o movimento do usuário seja igual a outros jogos.
    var mostRecentMove : [Move] = []
    
    enum Move {
        case UP, DOWN, LEFT, RIGHT
    }
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func movePlayer () {

        
        // Atualiza a posição do sprite com base nas teclas pressionadas
        var moveX: CGFloat = 0
        var moveY: CGFloat = 0
        let playerSpeed = 300.0

        switch mostRecentMove.last {
            case .UP: moveY += playerSpeed
            case .DOWN: moveY -= playerSpeed
            case .LEFT: moveX -= playerSpeed
            case .RIGHT: moveX += playerSpeed
            case nil: break
        }
        
        User.singleton.spriteComponent.sprite.physicsBody?.velocity = CGVector(dx: moveX, dy: moveY)
        updateUserPosition()
        updateCameraPosition()
    }
    
    
    private func updateUserPosition () {
        User.singleton.positionComponent.xPosition = Int(User.singleton.spriteComponent.sprite.position.x)
        User.singleton.positionComponent.yPosition = Int(User.singleton.spriteComponent.sprite.position.y)
    }
    
    func input (_ event : NSEvent) {
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
    
    // lógica que vai atualizar a posição da câmera (isso provavelmente será alterado no futuro
    func updateCameraPosition () {
        let playerSprite = User.singleton.spriteComponent.sprite
        var cameraPosition = playerSprite.position
        let cameraHalfSize = gameScene.frame.size.half
        let bounds = gameScene.bounds
        
        // Limitar o movimento da câmera nos eixos X e Y
        let minX = bounds.minX + cameraHalfSize.width
        let maxX = bounds.maxX - cameraHalfSize.width
        let minY = bounds.minY + cameraHalfSize.height
        let maxY = bounds.maxY - cameraHalfSize.height
                
        
        cameraPosition.x = Math
            .clamp(value: cameraPosition.x, minV: minX, maxV: maxX)
        
        cameraPosition.y = Math
            .clamp(value: cameraPosition.y, minV: minY, maxV: maxY)
      
        
        // Atualizar a posição da câmera
        gameScene.cameraNode.position = cameraPosition
    }
}
