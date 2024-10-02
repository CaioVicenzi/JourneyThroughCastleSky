//
//  Wall.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 26/09/24.
//

import Foundation
import SpriteKit

class Wall : UIComponent{
    var xPosition : CGFloat
    var yPostion : CGFloat
    var xSize : CGFloat
    var ySize : CGFloat
    var wall : SKShapeNode? = nil
    
    init(xPosition: CGFloat, yPostion: CGFloat, xSize: CGFloat, ySize: CGFloat, wall: SKShapeNode? = nil) {
        self.xPosition = xPosition
        self.yPostion = yPostion
        self.xSize = xSize
        self.ySize = ySize
        self.wall = wall
    }
    
    func addToScene (_ scene : SKScene) {
        wall = SKShapeNode(rect: CGRect(x: xPosition, y: yPostion, width: xSize, height: ySize))
        guard let wall else {return}
        
        
        wall.position.y += 200
        wall.fillColor = .brown
        wall.zPosition = 2
        
        let basedX = xPosition + (wall.frame.width / 2)
        let basedY = yPostion + (wall.frame.height / 4)
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.frame.size, center: CGPoint(x: basedX, y: basedY))
        
        wall.physicsBody?.categoryBitMask = PhysicCategory.wall
        wall.physicsBody?.collisionBitMask = PhysicCategory.character
        wall.physicsBody?.contactTestBitMask = PhysicCategory.character
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.isDynamic = false // não se move
        scene.addChild(wall)
    }
}
