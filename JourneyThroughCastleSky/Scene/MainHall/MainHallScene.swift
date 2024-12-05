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

var alreadyOpenCutscene : Bool = false

class MainHallScene: TopDownScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        if !alreadyOpenCutscene {
            let cutsceneHelper = CutsceneHelper()
            self.cutsceneSystem.addCutscenes(cutsceneHelper.cutsceneOne)
            
            self.cutsceneSystem.nextCutscenes()
            alreadyOpenCutscene = true
        }
    }
}
