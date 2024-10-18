//
//  MainHall.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/10/24.
//

import Foundation
import SpriteKit

class MainHall : TopDownScene {
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
        
        let primeiroBody: SKPhysicsBody
        let segundoBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            primeiroBody = contact.bodyA
            segundoBody = contact.bodyB
        } else {
            primeiroBody = contact.bodyB
            segundoBody = contact.bodyA
        }
        
        let collidedWithDoorNextScene = primeiroBody.categoryBitMask == PhysicCategory.character && segundoBody.categoryBitMask == PhysicCategory.checkpoint
        if collidedWithDoorNextScene {
            goNextScene()
        }
    }
}
