//
//  SpriteComponent.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 18/09/24.
//

import Foundation
import SpriteKit

class SpriteComponent: Component {
    var sprite : SKSpriteNode
    
    init(_ spriteName: String) {
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        
    }
}
