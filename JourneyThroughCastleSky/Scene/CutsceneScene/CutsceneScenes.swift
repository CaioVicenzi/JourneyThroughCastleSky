//
//  CutsceneSceneOne.swift
//  JourneyThroughCastleSky
//
//  Created by João Ângelo on 03/10/24.
//

import Foundation
import SpriteKit

class CutsceneScenes: SKScene{
    
    var countCutscene: Int = 1
    var cutscene: CutsceneComponent?
    var cutsceneTimer: Timer?
    var previousScene : TopDownScene? = nil
    var scenes : [Cutscene] = []
    
    func config (_ previousScene : TopDownScene, scenes : [Cutscene]) {
        self.previousScene = previousScene
        self.scenes = scenes
    }
    
    override func didMove(to view: SKView) {
        cutsceneTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(displayNextCutscene), userInfo: nil, repeats: true)
        displayNextCutscene()
    }
    
    @objc func displayNextCutscene(){
        setupCutscene()
    }
    
    private func setupCutscene () {
        guard let firstScene = scenes.first else {
            cutsceneTimer?.invalidate()
            goBackToScene()
            return
        }
        
        let backgroundNode = firstScene.background
        let subtitle = firstScene.displayText
        
        cutscene = CutsceneComponent(background: backgroundNode, subtitles: subtitle)
        
        cutscene?.displayCutscene(scene: self)
        scenes.removeFirst()
    }
    
    override func mouseDown(with event: NSEvent) {
        displayNextCutscene()
    }
    
    override func willMove(from view: SKView) {
        cutsceneTimer?.invalidate()
        cutsceneTimer = nil
    }
    
    private func goBackToScene () {
        self.view?.presentScene(previousScene)
    }
    
}
