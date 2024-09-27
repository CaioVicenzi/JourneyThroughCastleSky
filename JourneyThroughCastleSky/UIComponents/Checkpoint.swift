//
//  Checkpoint.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 26/09/24.
//

import Foundation
import SpriteKit

/// Classe que serve para inicializar componente na tela que ao colidir com o usuário ele leva o usuário para a próxima cena topdown.
class Checkpoint : UIComponent{
    var xPosition : CGFloat
    var yPosition : CGFloat
    var nextScene : SKScene
    
    init(xPosition: CGFloat, yPosition: CGFloat, nextScene : SKScene) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.nextScene = nextScene
    }
    
    func addToScene(_ scene: SKScene) {
        let checkpointSize = CGSize(width: 100, height: 100)
        
        let checkPoint = SKShapeNode(rectOf: checkpointSize)
        checkPoint.position.x = xPosition
        checkPoint.position.y = yPosition
        checkPoint.zPosition = 4
        checkPoint.fillColor = .yellow
        
        checkPoint.physicsBody = SKPhysicsBody(rectangleOf: checkpointSize)
        
        checkPoint.physicsBody?.categoryBitMask = PhysicCategory.checkpoint
        checkPoint.physicsBody?.collisionBitMask = PhysicCategory.character
        checkPoint.physicsBody?.contactTestBitMask = PhysicCategory.character
        checkPoint.physicsBody?.affectedByGravity = false
        checkPoint.physicsBody?.isDynamic = false // não se move
        
        scene.addChild(checkPoint)
    }
}
