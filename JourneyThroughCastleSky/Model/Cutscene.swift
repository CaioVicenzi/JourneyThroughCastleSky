//
//  Cutscene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 29/10/24.
//

import Foundation
import SpriteKit

class Cutscene {
    var background : SKSpriteNode
    var displayText : String
    var isFirst = false
    
    init(background: SKSpriteNode, displayText: String) {
        self.background = background
        self.displayText = displayText
    }
}
