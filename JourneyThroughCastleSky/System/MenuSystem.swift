//
//  MenuSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/10/24.
//

import Foundation

class MenuSystem {
    var gameScene : TopDownScene!
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func toggleInventory () {
        let gameState = gameScene.gameState
        let pauseUIComponent = gameScene.pauseUIComponent
        
        
        if gameState == .PAUSE {
            gameScene.gameState = .NORMAL
            pauseUIComponent.cleanMenuPause(cameraNode: gameScene.cameraNode)
        } else if gameState == .NORMAL{ // somente pode dar pause quando o jogo estiver no modo normal
            gameScene.gameState = .PAUSE
            gameScene.movementSystem.mostRecentMove = []
            gameScene.pauseUIComponent.addToScene(gameScene)
        }
    }
}
