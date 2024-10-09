//
//  CutsceneComponent.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 07/10/24.
//

import Foundation
import SpriteKit

class CutsceneComponent: Component{
    var background: SKSpriteNode
    var subtitles: String
    
    init(background: SKSpriteNode, subtitles: String) {
        self.background = background
        self.subtitles = subtitles
    }
    
    func updateCutscene(newBackground: SKSpriteNode, newSubtitles: String){
        self.background = newBackground
        self.subtitles = newSubtitles
    }
    
    func displayCutscene(scene: SKScene){
        scene.removeAllChildren()
        
        background.position = CGPoint(x: scene.size.width, y: scene.size.height)
        scene.addChild(background)
        
        let subtitleLabel = SKLabelNode(text: subtitles)
        subtitleLabel.fontSize = 20
        subtitleLabel.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(subtitleLabel)
    }
}