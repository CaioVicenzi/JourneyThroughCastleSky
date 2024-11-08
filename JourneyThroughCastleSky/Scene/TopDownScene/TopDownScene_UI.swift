//
//  TopDownScene_UI.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit


/// Como a TopDownScene estava ficando muito gigantesca e enorme, eu decidi dividir as partes que renderizam a UI do jogo para esse arquivo.
extension TopDownScene {
    /// Função que faz o setup do sprite do usuário, posicionando ele dentro do mapa..
    internal func setupPlayer () {
        // descobrir onde está o spawn e colocar o usuário lá
        
        if let spawnLocation {
            User.singleton.positionComponent.xPosition = Int(spawnLocation.x)
            User.singleton.positionComponent.yPosition = Int(spawnLocation.y)
        } else {
            if let spawn = childNode(withName: "spawn") {
                User.singleton.positionComponent.xPosition = Int(spawn.position.x)
                User.singleton.positionComponent.yPosition = Int(spawn.position.y)
            }
        }
        
        setupSpritePosition(User.singleton.spriteComponent, User.singleton.positionComponent)
        
        let sprite = User.singleton.spriteComponent.sprite
        
        
        let xSize = sprite.size.width / 2
        let ySize = sprite.size.height / 4
        
        sprite.zPosition = 10
        
        sprite.physicsBody = SKPhysicsBody(
            rectangleOf: .init(width: xSize, height: ySize),
            center: .init(x: 0, y: -sprite.size.height / 2 + ySize / 2)
        )
        sprite.physicsBody?.categoryBitMask  = PhysicCategory.character
        sprite.physicsBody?.collisionBitMask = PhysicCategory.wall
        sprite.physicsBody?.contactTestBitMask = PhysicCategory.wall
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = true // pode se mover
        sprite.physicsBody?.allowsRotation = false
        sprite.zPosition = 6
        
    }
    
    /// Função que faz o setup de qualquer elemento que contenha um sprite, um posicionamento e uma escala.
    func setupSpritePosition (_ spriteComponent : SpriteComponent, _ positionComponent : PositionComponent, scale : CGSize = CGSize(width: 50, height: 50)) {
        let sprite = spriteComponent.sprite
        sprite.position.y = CGFloat(positionComponent.yPosition)
        sprite.position.x = CGFloat(positionComponent.xPosition)
        
        if sprite.parent == nil {
            addChild(sprite)
        }
    }
    
    // MARK: FUNÇÕES QUE FAZEM O SETUP DE OUTROS ELEMENTOS DENTRO DO MAPA.
    
    func setupCatchLabel () {
        self.catchLabel = SKLabelNode()
        catchLabel?.text = "Press Enter to catch item"
        catchLabel?.fontColor = .blue
        catchLabel?.fontName = "Helvetica-Bold"
        catchLabel?.fontSize = 12
        catchLabel?.position = CGPoint(x: -(self.size.width / 3.47), y: -(self.size.height / 3))
        catchLabel?.zPosition = 3
        
        if let catchLabel {
            if catchLabel.parent == nil {
                cameraNode.addChild(catchLabel)
            }
        }
    }
}
