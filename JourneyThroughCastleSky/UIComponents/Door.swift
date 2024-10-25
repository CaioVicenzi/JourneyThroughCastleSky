//
//  Door.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 24/10/24.
//

import Foundation
import SpriteKit


class Door: SKSpriteNode {
    
    var enabled = true
    
    var destiny: String {
        return self.userData?.value(forKey: "destiny") as! String
    }
    
    var spawnDirection: CGVector {
        let directionString = self.userData?.value(forKey: "spawnDirection") as! String
        
        switch(directionString) {
            case "up":
                return .init(dx: 0, dy: 1)
            case "left":
                return .init(dx: -1, dy: 0)
            case "right":
                return .init(dx: 1, dy: 0)
            case "down":
                return .init(dx: 0, dy: -1)
            default:
                return .init(dx: 0, dy: 1)
        }
    }
    
    var destintyDoorName: String {
        return self.userData?.value(forKey: "doorDestiny") as! String
    }
    
    var destinyPhase: GamePhase? {
        return GamePhase(rawValue: self.destiny)
    }
    
    public func handleNodeContact(node: SKNode) {
        if (!enabled) {
            return
        }
        
        if node == User.singleton.spriteComponent.sprite {
            let nodeScene = node.scene as! TopDownScene
            
            if let destinyPhase {
                nodeScene.goNextScene(destinyPhase, destinyDoorName: self.destintyDoorName)
            }
        }
    }
    
    public func enable() {
        enabled = true
    }
    
    public func disable() {
        enabled = false
    }
}
