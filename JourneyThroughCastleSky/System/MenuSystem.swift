//
//  MenuSystem.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 07/10/24.
//

import Foundation

class MenuSystem: System {
    var gameScene : TopDownScene!
    
    func config (_ gameScene : TopDownScene) {
        self.gameScene = gameScene
    }
    
    func togglePause () {
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
    
    func input (_ keyCode : UInt16){
        switch keyCode {
            case 0x7E: // UP key
                gameScene.pauseUIComponent.pressUpKey()
            case 0x7D:  // DOWN key
                gameScene.pauseUIComponent.pressDownKey()
            case 36:
                gameScene.pauseUIComponent.pressEnterKey()
            default: break
        }
    }
}
