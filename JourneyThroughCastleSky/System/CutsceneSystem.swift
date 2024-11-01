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
    
    func addCutscenes (_ cutscenes : [Cutscene]) {
        self.gameScene.cutsceneSystem.cutscenes.append(contentsOf: cutscenes)
    }
    
    func nextCutscenes () {
        // primeiro passo: pegar a próxima lista de cenas das cutscenes
        guard cutscenes.first != nil else {
            return
        }
        
        TopDownScene.GameSceneData.shared = nil

        // segundo passo: abrir a CutsceneScenes e configurar ela com as cutscenes.
        let cutscene = CutsceneScenes(size: gameScene.size)
        cutscene.config(gameScene, scenes: cutscenes, dialogsAfterCutscene: self.gameScene.dialogSystem.dialogsToPassAfterCutscene)
        self.gameScene.cutsceneSystem.cutscenes.removeAll()
        gameScene.view?.presentScene(cutscene, transition: SKTransition.fade(withDuration: 2.0))
    }
}
