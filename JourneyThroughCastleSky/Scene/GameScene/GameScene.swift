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
