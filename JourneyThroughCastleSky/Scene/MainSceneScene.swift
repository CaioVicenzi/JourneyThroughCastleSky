//
//  MainMenuScene.swift
//  JourneyThroughCastleSky
//
//  Created by Caio Marques on 25/09/24.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    let titleLabel : SKLabelNode = SKLabelNode(text: "Jouney Through Castle Sky")
    var startGameButton : SKShapeNode? = nil
    
    override func didMove(to view: SKView) {
        titleLabel.position = PositionHelper.singleton.centralizeQuarterUp(titleLabel)
        titleLabel.position.x += titleLabel.frame.width / 2
        addChild(titleLabel)
        
        startGameButton = SKShapeNode(rect: CGRect(origin: PositionHelper.singleton.centralizeQuarterDown(SKNode()), size: CGSize(width: 200, height: 50)))
        
        if let startGameButton {
            startGameButton.position.x -= startGameButton.frame.width / 2
        }
        
        startGameButton?.name = "startGameButton"
        
        if let startGameButton {
            addChild(startGameButton)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNode = self.atPoint(location)
        
        if clickedNode.name == "startGameButton" {
            let gameScene = SKScene(fileNamed: "MainHallScene.sks")
            gameScene?.scaleMode = .aspectFill
             
            let transition = SKTransition.fade(withDuration: 1.0)
            if let gameScene {
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
         
         
        
    }
}
