//
//  CutsceneSceneOne.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 03/10/24.
//

import Foundation
import SpriteKit

class CutsceneScenes: SKScene{
    
    var countCutscene: Int = 0
    var cutscene: CutsceneComponent?
    var cutsceneTimer: Timer?
    
    override func didMove(to view: SKView) {
        cutsceneTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(displayNextCutscene), userInfo: nil, repeats: true)
    }
    
    @objc func displayNextCutscene(){
        if countCutscene == 0{
            let backgroundNode = SKSpriteNode(imageNamed: "Cutscene1")
            
            let initialSubtitles = "A long time ago..."
            
            cutscene = CutsceneComponent(background: backgroundNode, subtitles: initialSubtitles)
            
            cutscene?.displayCutscene(scene: self)
            
            countCutscene += 1
        }
        else if countCutscene == 1{
            let backgroundNode = SKSpriteNode(imageNamed: "Cutscene2")
            
            let initialSubtitles = "In a galaxy far far away"
            
            cutscene = CutsceneComponent(background: backgroundNode, subtitles: initialSubtitles)
            
            cutscene?.displayCutscene(scene: self)
            
            countCutscene += 1
        }
        else if countCutscene == 2{
            let backgroundNode = SKSpriteNode(imageNamed: "Cutscene3")
            
            let initialSubtitles = "Tan tan tan tan..."
            
            cutscene = CutsceneComponent(background: backgroundNode, subtitles: initialSubtitles)
            
            cutscene?.displayCutscene(scene: self)
            
            countCutscene += 1
        }
    }
    
    override func willMove(from view: SKView) {
        cutsceneTimer?.invalidate()
        cutsceneTimer = nil
    }
    
}
