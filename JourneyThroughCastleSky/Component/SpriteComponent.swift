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
    var fighterSprite : SKSpriteNode
    
    init(_ spriteName: String) {
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        fighterSprite = SKSpriteNode(imageNamed: "\(spriteName)-fighter")
    }
}
