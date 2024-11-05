//
//  MainHallScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 11/09/24.
//

import SpriteKit
import GameplayKit

protocol Command {
    func execute() -> Void
}

class Consumable: Command {
    func execute() {
        
    }
}

var jaMostrou : Bool = false

class MainHallScene: TopDownScene {
    override func didMove(to view: SKView) {
        BackgroundMusicHelper.singleton.stopMusic()
        //BackgroundMusicHelper.singleton.playMusic("MainHallMusic")
        
        super.didMove(to: view)
        if !jaMostrou {
            let cutsceneHelper = CutsceneHelper()
            self.cutsceneSystem.addCutscenes(cutsceneHelper.cutsceneOne) //.addCutscene(cutsceneHelper.cutsceneOne)
            
            self.cutsceneSystem.nextCutscenes()
            jaMostrou = true
        }
        
    }
}
