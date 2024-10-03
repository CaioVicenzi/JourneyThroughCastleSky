//
//  GameScene.swift
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

class GameScene: TopDownScene {
    
    override func didMove(to view: SKView) {
        super.config()
        super.setupNodes()
        setupWalls()
        setupCheckpoint()
    }
    
    private func setupWalls () {
        enumerateChildNodes(withName: "wall") { node, _ in
            Wall.setupPhysicsBody(node as! SKSpriteNode)
        }
    }
    
    private func setupCheckpoint () {
        //self.checkpoint = Checkpoint(xPosition: 1000, yPosition: 100, nextScene: GameScene(size: self.size, enemies: [], itens: [], friendlies: []))
        //checkpoint?.addToScene(self)
        
        let checkPoint = childNode(withName: "checkpoint") as? SKSpriteNode
        guard let checkPoint else {print("Não existe o checkpoint");return}
        
        checkPoint.physicsBody = SKPhysicsBody(rectangleOf: checkPoint.size)
        checkPoint.physicsBody?.categoryBitMask = PhysicCategory.checkpoint
        checkPoint.physicsBody?.collisionBitMask = PhysicCategory.character
        checkPoint.physicsBody?.contactTestBitMask = PhysicCategory.character
        checkPoint.physicsBody?.affectedByGravity = false
        checkPoint.physicsBody?.isDynamic = false // não se move
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        movementSystem.keyUp(event)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let primeiroBody: SKPhysicsBody
        let segundoBody: SKPhysicsBody
                
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            primeiroBody = contact.bodyA
            segundoBody = contact.bodyB
        } else {
            primeiroBody = contact.bodyB
            segundoBody = contact.bodyA
        }
        
        
        if primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint {
            self.view?.presentScene(SKScene(), transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    
    
}
