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
    var checkpoint : Checkpoint? = nil
    
    override func didMove(to view: SKView) {
        super.config()
        super.setupNodes()
        setupWall()
        setupCheckpoint()
    }
    
    private func setupWall () {
        let wall1 = Wall(xPosition: 500, yPostion: 400, xSize: 300, ySize: 10)
        wall1.addToScene(self)
    }
    
    private func setupCheckpoint () {
        self.checkpoint = Checkpoint(xPosition: 1000, yPosition: 100, nextScene: GameScene(size: self.size, enemies: [], itens: [], friendlies: [], background: SKSpriteNode(imageNamed: "background")))
        checkpoint?.addToScene(self)
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
            self.view?.presentScene(checkpoint?.nextScene ?? SKScene(), transition: SKTransition.fade(withDuration: 1.0)) 
        }
    }
}
