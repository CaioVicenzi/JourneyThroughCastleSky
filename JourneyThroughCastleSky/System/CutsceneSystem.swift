//
//  CutsceneSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 29/10/24.
//

import Foundation
import SpriteKit

class CutsceneSystem : System {
    var cutscenes : [[Cutscene]] = []
    
    override func config(_ gameScene: TopDownScene) {
        self.gameScene = gameScene
    }
    
    func addCutscene (_ cutscenes : [Cutscene]) {
        self.cutscenes.append(cutscenes)
    }
    
    func nextCutscene () {
        // primeiro passo: pegar a próxima lista de cenas das cutscenes
        guard let firstCutscene = cutscenes.first, !firstCutscene.isEmpty else {
            return
        }
        
        
        let cutscene = CutsceneScenes(size: gameScene.size)
        cutscene.config(gameScene, scenes: firstCutscene)
        gameScene.view?.presentScene(cutscene, transition: SKTransition.fade(withDuration: 2.0))
        
        self.cutscenes.removeFirst()
    }
    
}
