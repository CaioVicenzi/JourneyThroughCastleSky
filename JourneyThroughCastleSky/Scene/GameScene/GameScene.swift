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
        setupWall()
    }
    
    private func setupWall () {
        let wall = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: 300, height: 10)))
        wall.position.y += 200
        wall.fillColor = .brown
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.frame.size)
        wall.physicsBody?.categoryBitMask = PhysicCategory.wall
        wall.physicsBody?.collisionBitMask = PhysicCategory.character
        wall.physicsBody?.contactTestBitMask = PhysicCategory.character
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.isDynamic = false // não se move
        addChild(wall)
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
}
