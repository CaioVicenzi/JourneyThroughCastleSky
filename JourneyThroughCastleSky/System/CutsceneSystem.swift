//
//  CutsceneSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 29/10/24.
//

import Foundation
import SpriteKit

class CutsceneSystem: System {
    var cutscenes : [Cutscene] = []
    
    func addCutscene (_ cutscenes : [Cutscene]) {
        self.gameScene.cutsceneSystem.cutscenes.append(contentsOf: cutscenes)
    }
    
    func nextCutscene () {
        // primeiro passo: pegar a próxima lista de cenas das cutscenes
        guard let firstCutscene = cutscenes.first else {
            return
        }
        
        
        let cutscene = CutsceneScenes(size: gameScene.size)
        cutscene.config(gameScene, scenes: cutscenes)
        gameScene.view?.presentScene(cutscene, transition: SKTransition.fade(withDuration: 2.0))
        
        self.gameScene.cutsceneSystem.cutscenes.removeAll()
    }
    
}
